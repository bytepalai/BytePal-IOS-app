//
//  TextFieldAboveKeyboard.swift
//  BytePal
//
//  Created by may on 7/14/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

//final class KeyboardResponder: ObservableObject {
//    private var notificationCenter: NotificationCenter
//    @Published private(set) var currentHeight: CGFloat = 0
//
//    init(center: NotificationCenter = .default) {
//        notificationCenter = center
//        notificationCenter.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        notificationCenter.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//            print("Current height INIT: \(currentHeight)")
//    }
//
//    deinit {
//        notificationCenter.removeObserver(self)
//    }
//
//    @objc func keyBoardWillShow(notification: Notification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            currentHeight = keyboardSize.height
//            print("Current height: \(currentHeight)")
//        }
//    }
//
//    @objc func keyBoardWillHide(notification: Notification) {
//        currentHeight = 0
//    }
//}
//
//struct TextFieldAboveKeyboard: View {
//    @ObservedObject private var keyboard = KeyboardResponder()
//    @State private var textFieldInput: String = ""
//    
//    var body: some View {
//        GeometryReader { geometry in
//            VStack{
//                HStack{
//                    TextField("Enter text here",text: self.$textFieldInput)
//                        .padding(.bottom, self.keyboard.currentHeight)
//                }
//            }
//            .frame(width: 375, height: geometry.size.height, alignment: .bottom)
//                .edgesIgnoringSafeArea(.bottom)
//                .animation(.easeOut(duration: 0.16))
//                .border(Color.black, width: 1)
//        }
//    }
//}
//
//struct TextFieldAboveKeyboard_Previews: PreviewProvider {
//    static var previews: some View {
//        TextFieldAboveKeyboard()
//    }
//}
