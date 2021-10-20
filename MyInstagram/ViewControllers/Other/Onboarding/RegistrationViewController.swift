//
//  RegistrationViewController.swift
//  MyInstagram
//
//  Created by Pietro Vassallo on 06/10/21.
//

import UIKit
import FirebaseAuth

protocol RegistrationDelegate {
    func userWasRegistered(_ result: Bool)
}


class RegistrationViewController: UIViewController {
    
    struct Constants {
        static let cornerRadius: CGFloat = 8.0
    }
    
    var delegate:RegistrationDelegate?
    
    private let usernameField: UITextField = {
        let field = UITextField()
        
        field.placeholder = "Insert username"
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y:0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor

        return field
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        
        field.placeholder = "insert email"
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y:0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor

        return field
    }()
    
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.isSecureTextEntry = true
        field.placeholder = "Password..."
        field.returnKeyType = .continue
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y:0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()

    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign up", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        
        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        addSubviews()
        view.backgroundColor = .systemBackground
    }
    

    
    private func addSubviews() {
        view.addSubview(registerButton)
        view.addSubview(usernameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        usernameField.frame = CGRect(
            x: 25,
            y: view.safeAreaInsets.top + 100,
            width: view.width - 50,
            height: 52.0)
        
        emailField.frame = CGRect(
            x: 25,
            y: usernameField.bottom + 10,
            width: view.width - 50,
            height: 52.0)
    
        passwordField.frame = CGRect(
            x: 25,
            y: emailField.bottom + 10,
            width: view.width - 50,
            height: 52.0)
        
        registerButton.frame = CGRect(
            x: 25,
            y: passwordField.bottom + 30,
            width: view.width - 50,
            height: 52.0)
    }
    
    @objc private func didTapRegister() {
        passwordField.resignFirstResponder()
        usernameField.resignFirstResponder()
        emailField.resignFirstResponder()
    
        guard let email = emailField.text, !email.isEmpty,
              let username = usernameField.text, !username.isEmpty,
              let password = passwordField.text, !password.isEmpty, password.count >= 8
        else {
            return
        }
        
        AuthManager.shared.registerNewUser(username: username, email: email, password: password) {registered in
            DispatchQueue.main.async {
                if registered {
                    // good to go
                    self.delegate?.userWasRegistered(true)
                    
                } else {
                    // problems
                }
            }
            
        }
        
    }
    
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameField {
            emailField.becomeFirstResponder()
        }
        else if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else {
            didTapRegister()
        }
        
        return true
    }
}
