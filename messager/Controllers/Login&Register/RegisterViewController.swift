//
//  RegisterViewController.swift
//  messager
//
//  Created by vladislav dudevich on 11.12.2020.
//

import UIKit
import FirebaseAuth
class RegisterViewController: UIViewController {

    private let scrollView = UIScrollView()
    
    private let scrollSubView = UIView()
    
    private let emailField = UITextField()
    
    private let passwordField = UITextField()
    
    private let firstNameField = UITextField()
    
    private let lastNameField = UITextField()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.addTarget(self, action: #selector(didTapedRegister), for: .touchUpInside)
        
        return button
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        if #available(iOS 13.0, *) {
            imageView.image = UIImage(systemName: "person.circle")
        } else {
            imageView.image = UIImage(named: "person")
        }
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private var changePhotoProfile = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        passwordField.delegate = self
        firstNameField.delegate = self
        lastNameField.delegate = self
        
        setupUI()
        
    }
}

private extension RegisterViewController {
    @objc func didTapChangePictureProfile() {
        view.endEditing(true)
        presentPhotoActionSheet()
    }
    
    @objc func didTapedRegister() {
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        
        guard let email = emailField.text,
              let password = passwordField.text,
              let firstName = firstNameField.text,
              let lastName = lastNameField.text,
              !email.isEmpty,
              !password.isEmpty,
              !firstName.isEmpty,
              !lastName.isEmpty
        else { alertUserRegistrationError(message: .noFullFillProfile); return }
        
        DatabaseManager.shared.userExists(with: email) { [weak self] exists in
            guard let self = self else { return }
            guard !exists else { self.alertUserRegistrationError(message: .noFullFillProfile); return }
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
                guard let self = self else { return }
                guard authResult != nil, error == nil else { return }
                
                DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstName,
                                                                    lastName: lastName,
                                                                    emailAdress: email))
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func alertUserRegistrationError(message: Errors) {
        
        let alert = UIAlertController(title: "Error",
                                      message: message.errorText,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Try Again",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func setupUI() {
        
        title = "Registration"
        
        scrollView.backgroundColor = .white
        
        scrollSubView.isUserInteractionEnabled = true
        view.addSubview(scrollView)
        scrollView.addSubview(scrollSubView)
        
        scrollSubView.addSubview(imageView)
        scrollSubView.addSubview(emailField)
        scrollSubView.addSubview(passwordField)
        scrollSubView.addSubview(firstNameField)
        scrollSubView.addSubview(lastNameField)
        scrollSubView.addSubview(registerButton)
        
        Decorator.decorateTextField(textField: emailField, placeholderName: "Email", returnType: .next)
        Decorator.decorateTextField(textField: passwordField, placeholderName: "Password", returnType: .next, isSecure: true)
        Decorator.decorateTextField(textField: firstNameField, placeholderName: "FirstName", returnType: .next)
        Decorator.decorateTextField(textField: lastNameField, placeholderName: "LastName", returnType: .done)
        
        setConstaints()
        
        changePhotoProfile = UITapGestureRecognizer(target: self, action: #selector(didTapChangePictureProfile))
        changePhotoProfile.numberOfTouchesRequired = 1
        scrollSubView.addGestureRecognizer(changePhotoProfile)
    }
    
    func setConstaints() {
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          left: view.leftAnchor,
                          bottom: view.safeAreaLayoutGuide.bottomAnchor,
                          right: view.rightAnchor)
        
        scrollSubView.anchor(top: scrollView.topAnchor,
                      left: scrollView.leftAnchor,
                      bottom: scrollView.bottomAnchor,
                      right: scrollView.rightAnchor,
                      width: scrollView.widthAnchor,
                      height: scrollView.heightAnchor)

        imageView.anchorCenterXToSuperview()
        imageView.anchor(top: scrollSubView.safeAreaLayoutGuide.topAnchor,
                         topConstant: 16,
                         widthConstant: 150,
                         heightConstant: 150)
        
        emailField.anchorCenterXToSuperview()
        emailField.anchor(top: imageView.bottomAnchor,
                          left: scrollSubView.leftAnchor,
                          right: scrollSubView.rightAnchor,
                          topConstant: 16,
                          leftConstant: 32,
                          rightConstant: 32,
                          heightConstant: 50)
        
        passwordField.anchorCenterXToSuperview()
        passwordField.anchor(top: emailField.bottomAnchor,
                             left: scrollSubView.leftAnchor,
                             right: scrollSubView.rightAnchor,
                             topConstant: 16,
                             leftConstant: 32,
                             rightConstant: 32,
                             heightConstant: 50)
        
        firstNameField.anchorCenterXToSuperview()
        firstNameField.anchor(top: passwordField.bottomAnchor,
                              left: scrollSubView.leftAnchor,
                              right: scrollSubView.rightAnchor,
                              topConstant: 16,
                              leftConstant: 32,
                              rightConstant: 32,
                              heightConstant: 50)
        
        lastNameField.anchorCenterXToSuperview()
        lastNameField.anchor(top: firstNameField.bottomAnchor,
                             left: scrollSubView.leftAnchor,
                             right: scrollSubView.rightAnchor,
                             topConstant: 16,
                             leftConstant: 32,
                             rightConstant: 32,
                             heightConstant: 50)
        
        registerButton.anchorCenterXToSuperview()
        registerButton.anchor(top: lastNameField.bottomAnchor,
                              left: scrollSubView.leftAnchor,
                              right: scrollSubView.rightAnchor,
                              topConstant: 16,
                              leftConstant: 64,
                              rightConstant: 64,
                              heightConstant: 50)
    }
    
    func presentPhotoActionSheet() {
        
        let actionSheet = UIAlertController(title: "Profile Picture",
                                            message: "How would you like to select a picture?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: { _ in
                                                
                                            }))
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                            style: .default,
                                            handler: { [weak self] _ in
                                                self?.presentCamera()
                                            }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo",
                                            style: .default,
                                            handler: { [weak self] _ in
                                                self?.presentPhotoPicker()
                                            }))
        
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            firstNameField.becomeFirstResponder()
        } else if textField == firstNameField {
            lastNameField.becomeFirstResponder()
        } else if textField == lastNameField {
            didTapedRegister()
        }
        return true
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        self.imageView.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

enum ErrorMessage: String {
    case emptyFill = "Please fill all textfield"
    case someError = ""
}
