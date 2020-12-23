//
//  LoginViewController.swift
//  messager
//
//  Created by vladislav dudevich on 11.12.2020.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class LoginViewController: UIViewController {

    private let scrollView = UIScrollView()
    
    private let myView = UIView()

    private let emailField = UITextField()
    private let passwordField = UITextField()
    
    private let loginFBButton = FBLoginButton()
    private let loginGLButton = GIDSignInButton()
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.addTarget(self, action: #selector(didTapedLogin), for: .touchUpInside)
        
        return button
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

private extension LoginViewController {
    
    @objc func didTapedRegisterNavButton() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapedLogin() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        guard let email = emailField.text,
              let password = passwordField.text,
              !email.isEmpty, !password.isEmpty else { alertUserLoginError(); return }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) {[weak self] authResult, error in
            guard let self = self else { return }
            guard let result = authResult, error == nil else { return }
            
            let user = result.user
            Logger.log(user)
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
        
    }
    func setupUI() {
        
        title = "Login"
        view.backgroundColor = .white

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapedRegisterNavButton))
        emailField.delegate = self
        passwordField.delegate = self
        loginFBButton.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(myView)
        
        myView.addSubview(imageView)
        myView.addSubview(emailField)
        myView.addSubview(passwordField)
        myView.addSubview(loginButton)
        myView.addSubview(loginFBButton)
        myView.addSubview(loginGLButton)
        
        Decorator.decorateTextField(textField: emailField, placeholderName: "Email", returnType: .next)
        Decorator.decorateTextField(textField: passwordField, placeholderName: "Password", returnType: .done)
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        loginFBButton.permissions = ["email, public_profile"]
        setConstaints()
    }
    
    func setConstaints() {
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          left: view.leftAnchor,
                          bottom: view.safeAreaLayoutGuide.bottomAnchor,
                          right: view.rightAnchor)
        
        myView.anchor(top: scrollView.topAnchor,
                      left: scrollView.leftAnchor,
                      bottom: scrollView.bottomAnchor,
                      right: scrollView.rightAnchor,
                      width: scrollView.widthAnchor,
                      height: scrollView.heightAnchor)
        
        imageView.anchorCenterXToSuperview()
        imageView.anchor(top: myView.safeAreaLayoutGuide.topAnchor,
                         topConstant: 16,
                         widthConstant: 150,
                         heightConstant: 150)
        
        emailField.anchorCenterXToSuperview()
        emailField.anchor(top: imageView.bottomAnchor,
                          left: myView.leftAnchor,
                          right: myView.rightAnchor,
                          topConstant: 32,
                          leftConstant: 32,
                          rightConstant: 32,
                          heightConstant: 50)
        
        passwordField.anchorCenterXToSuperview()
        passwordField.anchor(top: emailField.bottomAnchor,
                          left: myView.leftAnchor,
                          right: myView.rightAnchor,
                          topConstant: 32,
                          leftConstant: 32,
                          rightConstant: 32,
                          heightConstant: 50)
        
        loginButton.anchorCenterXToSuperview()
        loginButton.anchor(top: passwordField.bottomAnchor,
                          left: myView.leftAnchor,
                          right: myView.rightAnchor,
                          topConstant: 32,
                          leftConstant: 64,
                          rightConstant: 64,
                          heightConstant: 50)
        
        if let constraint = loginFBButton.constraints.first(where: { (constraint) -> Bool in
            return constraint.firstAttribute == .height
        }) {
            constraint.constant = 40.0
        }
        loginFBButton.anchorCenterXToSuperview()
        loginFBButton.anchor(top: loginButton.bottomAnchor,
                             width: loginButton.widthAnchor,
                             topConstant: 16)
        
        loginGLButton.anchorCenterXToSuperview()
        loginGLButton.anchor(top: loginFBButton.bottomAnchor,
                             width: loginFBButton.widthAnchor,
                             topConstant: 16)
    }
    
    func alertUserLoginError() {
        let alert = UIAlertController(title: "Error", message: "Wrong email or password", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            didTapedLogin()
        }
        
        return true
    }
}

extension LoginViewController: LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else { alertUserLoginError(); return }
        
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                         parameters: ["fields": "email, name"],
                                                         tokenString: token,
                                                         version: nil,
                                                         httpMethod: .get)
        facebookRequest.start { (_, result, error) in
            guard let result = result as? [String: Any], error == nil else { return }
            guard let userName = result["name"] as? String,
                  let email = result["email"] as? String else {print("failed to get name email from fb"); return }

            
            let nameComponents = userName.components(separatedBy: " ")
            guard nameComponents.count == 2 else { return }
            
            let firstName = nameComponents.first
            let lastName = nameComponents.last
            
            DatabaseManager.shared.userExists(with: email) { (exists) in
                if !exists {
                    DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstName ?? "firstName",
                                                                        lastName: lastName ?? "lastName",
                                                                        emailAdress: email))
                }
            }
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            FirebaseAuth.Auth.auth().signIn(with: credential) { [weak self] (authResult, error) in
                guard let self = self else { return }

                guard authResult != nil, error == nil else {
                    if let error = error {
                        print("error MFA needed")
                    }
                    return
                }
                print("Vse good")
                self.navigationController?.dismiss(animated: true, completion: nil)

            }
        }

    }
}

extension LoginViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else { print("Failed login google"); return }
        
        guard let email = user.profile.email,
              let firstName = user.profile.givenName,
              let lastName = user.profile.familyName else { return }
        
        DatabaseManager.shared.userExists(with: email) { (exists) in
            if !exists {
                DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstName,
                                                                    lastName: lastName,
                                                                    emailAdress: email))
            }
        }
        
        guard let authentication = user.authentication else {print("Missing auth object off of google user"); return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        FirebaseAuth.Auth.auth().signIn(with: credential) { (authResult, error) in
            guard authResult != nil, error == nil else { return }
            
        }
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("user was disconected")
    }
}
