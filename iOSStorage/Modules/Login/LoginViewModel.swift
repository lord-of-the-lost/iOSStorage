//
//  LoginViewModel.swift
//  iOSStorage
//
//  Created by Николай Игнатов on 27.05.2023.
//

import Foundation

//protocol LoginViewModelProtocol {
//    var onStateDidChange: ((LoginViewModel.State) -> Void)? { get set }
//    func updateState(viewInput: LoginViewModel.ViewInput)
//}
//
//final class LoginViewModel: LoginViewModelProtocol {
//    enum State {
//        case initial
//        case repeatPassword
//    }
//    
//    enum ViewInput {
//        case passwordRecived
//    }
//    
//    var onStateDidChange: ((State) -> Void)?
//    
//    private(set) var state: State = .initial {
//        didSet {
//            onStateDidChange?(state)
//        }
//    }
//    
//    func updateState(viewInput: ViewInput) {
//        switch viewInput {
//        case .addNewMessege:
//            state = .loadMesseges
//        }
//    }
//}
