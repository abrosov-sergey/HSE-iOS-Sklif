//
//  AuthorizationViewController.swift
//  HSE-iOS-Sklif
//
//  Created Сергей Абросов on 14.04.2023.
//  Copyright © 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol AuthorizationViewInput: AnyObject {

}

protocol AuthorizationViewOutput: AnyObject {
  func viewDidLoad()
  func userAuth()
}


final class AuthorizationViewController: UIViewController {

  // MARK: - Outlets


  // MARK: - Properties

  var output: AuthorizationViewOutput?
    
    private var mainLabel: UILabel = {
        var label = UILabel()
        
        label.text = """
        Добро
        пожаловать!
        """
        
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 45)
        label.numberOfLines = 2
        
        return label
    }()
    
    private var emailLabel: UILabel = {
        var label = UILabel()
        label.text = "Почта"
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        return label
    }()
    
    private var passwordLabel: UILabel = {
        var label = UILabel()
        label.text = "Пароль"
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        return label
    }()
    
    private var emailTextField: UITextField = {
        var textField = UITextField()
        
        textField.attributedPlaceholder = NSAttributedString(
            string: "  Введите почту",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)]
        )
        
        textField.textColor = .systemGray
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        textField.layer.borderWidth = 1
        return textField
    }()
    
    private var passwordTextField: UITextField = {
        var textField = UITextField()
        
        textField.attributedPlaceholder = NSAttributedString(
            string: "  Введите пароль",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)]
        )
        
        textField.textColor = .systemGray
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        textField.layer.borderWidth = 1
        return textField
    }()
    
    private var forgotPassword: UIButton = {
        var button = UIButton()
        button.setTitle("Забыли пароль", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
        button.backgroundColor = .black
        button.setTitleColor(UIColor(red: 1, green: 1, blue: 11, alpha: 1) , for: .normal)
        return button
    }()
    
    private var signInButton: UIButton = {
        var button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 1) , for: .normal)
        return button
    }()
    
    private var signUpButton: UIButton = {
        var button = UIButton()
        button.setTitle("Зарегистрироваться", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 1) , for: .normal)
        return button
    }()
    
    private var separatorLabel: UILabel = {
        var label = UILabel()
        label.text = "Или"
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        return label
    }()

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
    output?.viewDidLoad()
      
      self.view.backgroundColor = .black
      
      setupUI()
  }

  // MARK: - Actions


  // MARK: - Setup

  private func setupUI() {
      setupLabels()
      setupTextFields()
      setupButtons()
  }
    
    private func setupLabels() {
        self.view.addSubview(mainLabel)
        self.view.addSubview(emailLabel)
        self.view.addSubview(passwordLabel)
        self.view.addSubview(separatorLabel)
        
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(142)
            make.left.equalToSuperview().inset(19)
        }
        
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(284)
            make.left.equalToSuperview().inset(19)
        }
        
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(377)
            make.left.equalToSuperview().inset(19)
        }
        
        separatorLabel.translatesAutoresizingMaskIntoConstraints = false
        separatorLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(646)
            make.left.equalToSuperview().inset(183)
        }
    }
    
    private func setupTextFields() {
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwordTextField)
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(309)
            make.left.equalToSuperview().inset(19)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(499)
        }
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(402)
            make.left.equalToSuperview().inset(19)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(406)
        }
    }
    
    private func setupButtons() {
        self.view.addSubview(forgotPassword)
        self.view.addSubview(signInButton)
        self.view.addSubview(signUpButton)
        
        forgotPassword.translatesAutoresizingMaskIntoConstraints = false
        forgotPassword.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(450)
            make.left.equalToSuperview().inset(270)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(370)
        }
        
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(591)
            make.left.equalToSuperview().inset(19)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(215)
        }
        
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(673)
            make.left.equalToSuperview().inset(19)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(133)
        }
        
        forgotPassword.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        forgotPassword.tag = 0
        
        signInButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        signInButton.tag = 1
        
        signUpButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        signUpButton.tag = 2
    }
    
    @objc func buttonAction(sender: UIButton!) {
       let btnsendtag: UIButton = sender
       
        let login = emailTextField.text ?? "", password = passwordTextField.text ?? ""
        
       if btnsendtag.tag == 0 {
           dismiss(animated: true, completion: nil)
       } else if btnsendtag.tag == 1 {
           dismiss(animated: true, completion: nil)
           
           if checkUserLoginAndPassword(login: login, password: password) {
               output?.userAuth()
           } else {
               let alert = UIAlertController(title: "Ошибка входа", message: "Неверно введен логин или пароль", preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "Ок", style: .default))
               present(alert, animated: true) {
                   return
               }
           }
       } else if btnsendtag.tag == 2 {
           dismiss(animated: true, completion: nil)
           
           if login.count > 0 && password.count > 0 {
               sendUserLoginAndPassword(login: login, password: password)
               
               output?.userAuth()
           } else {
               let alert = UIAlertController(title: "Ошибка регистрации", message: "Неверно введен логин или пароль", preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "Ок", style: .default))
               present(alert, animated: true) {
                   return
               }
           }
       }
   }
    
    private func checkUserLoginAndPassword(login: String, password: String) -> Bool {
        return true
    }
    
    private func sendUserLoginAndPassword(login: String, password: String) {
        
    }

  private func setupLocalization() {
      
  }
}

// MARK: - TroikaServiceViewInput

extension AuthorizationViewController: AuthorizationViewInput {

}
