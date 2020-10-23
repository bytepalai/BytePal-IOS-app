//
//  BytePalButton.swift
//  BytePal
//
//  Created by Heshan Yodagama on 10/11/20.
//

import SwiftUI

struct BytePalButton: View {
    
    var buttonTitle: String
    @Binding var dissabled: Bool
    var buttonTapped: () -> Void
    
    var body: some View {
        
        GeometryReader(content: { geometry in
            Button(action: {
                buttonTapped()
            }, label: {
                Text(buttonTitle)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
            })
            .frame(width: geometry.size.width, height: 60, alignment: .center)
            .background(dissabled ? Color.appTransparentGray:Color.appGreen)
            .cornerRadius(cornerRadious, antialiased: true)
            .disabled(dissabled)
            .shadow(radius: dissabled ? 1:50)
            .animation(.easeIn)
        })
    }
    
    //MARK: Constant and methods
    private let cornerRadious: CGFloat = 8
    private let buttonHeight: CGFloat = 60
}

struct BytePalButton_Previews: PreviewProvider {
    
    static var previews: some View {
        BytePalButton(buttonTitle: "MyButton", dissabled: .constant(true)) {
            print("buttonTapped")
        }
    }
}
