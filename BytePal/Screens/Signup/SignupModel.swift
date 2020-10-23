//
//  SignupModel.swift
//  BytePal
//
//  Created by may on 8/4/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import Foundation
import Combine

class SignUpViewModel: ObservableObject {
    
    init() {
        bindOutputs()
    }
    
    private var cancellables: [AnyCancellable] = []
    
    @Published var email = ""
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var password = ""
    @Published var sinUpButtonDissabled = true
    
    var valiedCredentials: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest4($email, $firstName, $lastName, $password)
            .map {
                if !$0.0.isEmpty, !$0.1.isEmpty, !$0.2.isEmpty, !$0.3.isEmpty {
                    return true
                } else {
                    return false
                }
            }
            .eraseToAnyPublisher()
    }
    
    func signUp() {
        
    }
    
    private func bindOutputs() {
        valiedCredentials
            .map({ !$0 })
            .assign(to: \.sinUpButtonDissabled, on: self)
            .store(in: &cancellables)
    }
}
