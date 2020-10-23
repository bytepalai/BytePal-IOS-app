//
//  BytePalSecureTextField.swift
//  BytePal
//
//  Created by Heshan Yodagama on 10/12/20.
//

import SwiftUI

struct BytePalSecureTextField: View {
    
    var title: String
    var textFieldPlaceHolder: String
    @Binding var text: String
    
    var body: some View {
        ZStack {
            TransparentRoundedBackgroundView(cornerRadius: cornerRadius)
            
            VStack(alignment: .leading) {
                Text(title)
                    .fontWeight(.semibold)
                    .foregroundColor(.appFontColorBlack)
                SecureField(textFieldPlaceHolder, text: $text)
            }
            .padding()
        }
        .frame(height: viewHeight, alignment: .center)
    }
    
    //MARK: constant
    let cornerRadius: CGFloat = 15.0
    let viewHeight: CGFloat = 75
}

struct BytePalSecureTextField_Previews: PreviewProvider {
    
    @State static var text = ""
    
    static var previews: some View {
        BytePalSecureTextField(title: "Title", textFieldPlaceHolder: "placeholder", text: $text)
            .previewLayout(.sizeThatFits)
    }
}
