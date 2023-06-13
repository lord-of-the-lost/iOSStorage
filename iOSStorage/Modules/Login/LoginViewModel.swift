//
//  LoginViewModel.swift
//  iOSStorage
//
//  Created by Николай Игнатов on 27.05.2023.
//

import Foundation

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
