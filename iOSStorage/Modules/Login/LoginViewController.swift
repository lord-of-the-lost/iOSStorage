//
//  LoginViewController.swift
//  iOSStorage
//
//  Created by Николай Игнатов on 26.05.2023.
//

import UIKit

final class LoginViewController: UIViewController {
    
    private var viewModel: LoginViewModelProtocol
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Введите пароль"
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать пароль", for: .normal)
        button.backgroundColor = .darkGray
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init() {
        self.viewModel = LoginViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        viewModel.onStateDidChange = { [weak self] state in
            self?.updateUI(for: state)
        }
    }
    
    @objc private func actionButtonTapped() {
        switch viewModel.getCurrentState() {
        case .initial:
            let password = passwordTextField.text ?? ""
            if password.count >= 4 {
                viewModel.updateState(viewInput: .passwordReceived(password))
            } else {
                presentAlert(title: "Ошибка", message: "Пароль должен состоять минимум из четырех символов")
            }
        case .repeatPassword:
            let password = passwordTextField.text ?? ""
            let initialPassword = viewModel.getInitialPassword() ?? ""
            if password == initialPassword {
                navigationController?.pushViewController(DocumentsViewController(), animated: true)
            } else {
                presentAlert(title: "Ошибка", message: "Пароли не совпадают")
                viewModel.updateState(viewInput: .passwordReset)
            }
        }
    }
    
    private func updateUI(for state: LoginViewModel.State) {
        switch state {
        case .initial:
            passwordTextField.text = ""
            passwordTextField.placeholder = "Введите пароль"
            actionButton.setTitle("Создать пароль", for: .normal)
        case .repeatPassword:
            passwordTextField.text = ""
            passwordTextField.placeholder = "Повторите пароль"
            actionButton.setTitle("Введите пароль", for: .normal)
        }
    }
    
    func presentAlert(title: String, message: String, completionHandler: (() -> Void)? = nil) {
         let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
         let okAction = UIAlertAction(title: "OK", style: .default) { _ in
             completionHandler?()
         }
         alertController.addAction(okAction)
         present(alertController, animated: true, completion: nil)
     }
    
    private func setupView() {
        view.backgroundColor = .systemGray
        view.addSubview(passwordTextField)
        view.addSubview(actionButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
           
            actionButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
}

protocol LoginViewModelProtocol {
    var onStateDidChange: ((LoginViewModel.State) -> Void)? { get set }
    func getCurrentState() -> LoginViewModel.State
    func getInitialPassword() -> String?
    func updateState(viewInput: LoginViewModel.ViewInput)
}

final class LoginViewModel: LoginViewModelProtocol {
    enum State {
        case initial
        case repeatPassword
    }
    
    enum ViewInput {
        case passwordReceived(String)
        case passwordReset
    }
    
    var onStateDidChange: ((State) -> Void)?
    
    private var state: State = .initial
    private var initialPassword: String?
    
    func getCurrentState() -> State {
        return state
    }
    
    func getInitialPassword() -> String? {
        return initialPassword
    }
    
    func updateState(viewInput: ViewInput) {
        switch viewInput {
        case .passwordReceived(let password):
            initialPassword = password
            state = .repeatPassword
        case .passwordReset:
            initialPassword = nil
            state = .initial
        }
        onStateDidChange?(state)
    }
}
