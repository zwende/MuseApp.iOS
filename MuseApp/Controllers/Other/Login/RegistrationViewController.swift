//
//  RegistrationViewController.swift
//  MuseApp
//
//  Created by Zoe Wende on 2/20/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegistrationViewController: UIViewController {

    struct Constants{
        static let cornerRadius: CGFloat = 10.0
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccountButton), for: .touchUpInside)
        usernameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        view.backgroundColor = .systemBackground
        addSubviews()
    }
    
    private let usernameField: UITextField = {
        let field = UITextField()
        field.attributedPlaceholder = NSAttributedString(string: "Username",
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = UIColor(named: "AppGray")
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor(named: "AppYellow")?.cgColor
        return field
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.attributedPlaceholder = NSAttributedString(string: "Email",
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = UIColor(named: "AppGray")
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor(named: "AppYellow")?.cgColor
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.isSecureTextEntry = true
        field.attributedPlaceholder = NSAttributedString(string: "Password",
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        field.returnKeyType = .continue
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = UIColor(named: "AppGray")
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor(named: "AppYellow")?.cgColor

        return field
    }()
    
    private let headerView: UIView = {
        //header;  logo here
        let header = UIView()
        header.clipsToBounds = true
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: 160, y: 285)
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 35)
        label.textColor = UIColor(named: "AppYellow")
        label.text = "Create Account"
        header.addSubview(label)
        header.backgroundColor = UIColor(named: "AppDarkGray")
        return header
    }()
    
    private let createAccountButton: UIButton = {
        let button =  UIButton()
        button.setTitle("Create Account", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = UIColor(named: "AppYellow")
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerView.frame = CGRect(x: 0,
                                  y: view.safeAreaInsets.top + 20,
                                  width: view.width,
                                  height: view.height/3.0)
        
        usernameField.frame = CGRect(x: 25,
                                     y: headerView.bottom + 20,
                                  width: view.width - 50,
                                          height: 52.0)
        
        emailField.frame = CGRect(x: 25,
                                  y: usernameField.bottom + 20,
                                  width: view.width - 50,
                                          height: 52.0)
        
        passwordField.frame = CGRect(x: 25,
                                     y: emailField.bottom + 20,
                                     width: view.width - 50,
                                             height: 52.0)

        
        createAccountButton.frame = CGRect(x: 25,
                                     y: passwordField.bottom + 30,
                                     width: view.width - 50,
                                             height: 50.0)
        
        
        view.backgroundColor = UIColor(named: "AppDarkGray")
        
        configureHeaderView()
        //assign frames
    }
    
    private func configureHeaderView(){
        guard headerView.subviews.count == 1 else{
            return
        }
        
        guard let backgroundView = headerView.subviews.first else{
            return
        }
        
        backgroundView.frame = headerView.bounds
    }
    private func addSubviews(){
        view.addSubview(usernameField)
        view.addSubview(passwordField)
        view.addSubview(emailField)
        view.addSubview(createAccountButton)
        view.addSubview(headerView)
    }
    
    @objc private func didTapCreateAccountButton(){
        emailField.resignFirstResponder()
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let username = usernameField.text, !username.isEmpty,
              let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty, password.count >= 8 else{
                  return
              }
        
        //login functionality
        AuthManager.shared.registerNewUser(username: username, email: email, password: password){ [weak self] success in
            DispatchQueue.main.async{
            if success {
                // Update database
//                let bio : String
//                let background : String?
//                let profilePicture: String?
//
                let newUser = User(username: username, bio: " ", background: " ", profilePicture: "", counts: UserCounts(following: 0, followers: 0, posts: 0), email: email, identifier: UserIdentifier(identifier: " "))
                    DatabaseManager.shared.insertNewUser(with: newUser) { inserted in
                    guard inserted else {
                        return
                    }

                    UserDefaults.standard.set(email, forKey: "email")
                    UserDefaults.standard.set(username, forKey: "username")
//                    UserDefaults.standard.set(bio, forKey: "bio")
                        //registered in
                        Auth.auth().currentUser?.sendEmailVerification{ error in }
                        let alert = UIAlertController(title: "Check Email", message: "Please go check your email", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self?.present(alert, animated: true)
                        //self.dismiss(animated: true, completion: nil)
                            }
                        }
            else{
            let alert = UIAlertController(title: "Log In Error", message: "We were unable to log you in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self?.present(alert, animated: true)
                }
        }
        }
    }
}


extension RegistrationViewController: UITextFieldDelegate {
        func textFieldShouldReturn(_ textField:UITextField) ->Bool{
            if textField == emailField{
                usernameField.becomeFirstResponder()
            }
            
            else if textField == usernameField{
                passwordField.becomeFirstResponder()
            }
            else if textField == passwordField{
                didTapCreateAccountButton()
            }
            return true
        }
}
