//
//  UserBar.swift
//  BytePal
//
//  Created by Paul Ngouchet on 8/25/20.
//  Copyright © 2020 BytePal AI, LLC. All rights reserved.
//

import SwiftUI

//  User Inforamtion Bar (Top)
struct UserBar: View{
    var body: some View {
        GeometryReader { geometry in
            HStack(){
                Spacer()
                Image("logo")
                    .resizable()
                    .frame(width: 48, height: 48)
                    .shadow(color: convertHextoRGB(hexColor: "000000").opacity(0.16), radius: 2, x: 2, y: 3)
                Spacer()
            }
        }
    }
}

struct UserBar_Previews: PreviewProvider {
    static var previews: some View {
        UserBar()
    }
}
