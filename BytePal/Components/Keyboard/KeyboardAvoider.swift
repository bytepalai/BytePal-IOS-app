//
//  KeyboardAvoider.swift
//  BytePal
//
//  Created by Scott Hom on 7/14/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

final class KeyboardResponder: ObservableObject {
    
    // Notification Center Object (similar to observable object)
    private var notificationCenter: NotificationCenter
    
    // Observable Objects
    @Published var currentHeight: CGFloat = 0
    @Published private(set) var isUp: Bool = false
    
    init(center: NotificationCenter = .default) {
        notificationCenter = center
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        notificationCenter.removeObserver(self)
    }

    @objc func keyBoardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            currentHeight = keyboardSize.height
            isUp = true
        }
    }

    @objc func keyBoardWillHide(notification: Notification) {
        currentHeight = 0
        isUp = false 
    }
}

extension UIApplication {
    // Force keyboard to go down
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
