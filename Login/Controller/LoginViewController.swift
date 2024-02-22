//
//  ViewController.swift
//  Login
//
//  Created by Tringapps on 06/02/24.
//

import UIKit

class LoginViewController: UIViewController {
    private weak var userNameTextField: UITextField!
    private weak var passwordTextField: UITextField!
    private weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        view.endEditing(true)

        userNameTextField.isUserInteractionEnabled = false
        passwordTextField.isUserInteractionEnabled = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.userNameTextField.isUserInteractionEnabled = true
        self.passwordTextField.isUserInteractionEnabled = true
    }

    private func setupUI() {
        view.backgroundColor = .white

        userNameTextField = createTextField(placeholder: "UserName", isSecureTextEntry: false)
        passwordTextField = createTextField(placeholder: "PassWord", isSecureTextEntry: true)
        loginButton = createButton(title: "Login", action: #selector(handleLogin))

        NSLayoutConstraint.activate([
            userNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userNameTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 350),
            userNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            userNameTextField.heightAnchor.constraint(equalToConstant: 40),

            passwordTextField.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),

            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            loginButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func createTextField(placeholder: String, isSecureTextEntry: Bool) -> UITextField {
        let textField = UITextField()
        view.addSubview(textField)
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.isSecureTextEntry = isSecureTextEntry
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }

    private func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton()
        view.addSubview(button)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    @objc private func handleLogin() {
        guard let userName = userNameTextField.text, let password = passwordTextField.text else {
            return
        }

        if userName.count >= 3 && password.count >= 3 {
            redirectToUserPage(userName: userName)
        } else {
            showAlert(title: "Invalid User", message: "Invalid Username and Password")
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func redirectToUserPage(userName: String) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)

        guard let homeViewController =
                storyBoard.instantiateViewController(
                    withIdentifier: "HomeViewController"
                ) as? HomeViewController else {
                fatalError("Invalid storyboard")
            }

        homeViewController.userName = userName
        navigationController?.pushViewController(homeViewController, animated: true)
        clearTextFields()
    }

    private func clearTextFields() {
        userNameTextField.text = ""
        passwordTextField.text = ""
    }
}
