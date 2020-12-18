//
//  LoginViewController.swift
//  messager
//
//  Created by vladislav dudevich on 11.12.2020.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    private let scrollView = UIScrollView()
    
    private let myView = UIView()

    private let emailField = UITextField()
    
    private let passwordField = UITextField()
    
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
    
    @objc func didTapedRegister() {
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
                                                            action: #selector(didTapedRegister))
        emailField.delegate = self
        passwordField.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(myView)
        
        myView.addSubview(imageView)
        myView.addSubview(emailField)
        myView.addSubview(passwordField)
        myView.addSubview(loginButton)
        
        Decorator.shared.decorateTextField(textField: emailField, placeholderName: "Email", returnType: .next)
        Decorator.shared.decorateTextField(textField: passwordField, placeholderName: "Password", returnType: .done)
        
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
