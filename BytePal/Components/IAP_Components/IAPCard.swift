//
//  IAPCard.swift
//  BytePal
//
//  Created by Paul Ngouchet on 8/28/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI



struct IAPCard: View {
    
    // Arguments
    var price: String
    
    var body: some View {
        
        ZStack{
        RoundedRectangle(cornerRadius: 25, style: .continuous)
            .fill(convertHextoRGB(hexColor: "ffffff"))
            .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0))
            .shadow(color: convertHextoRGB(hexColor: "000000").opacity(0.33), radius: 4, x: 3, y: 3)
        VStack {
            Image(MAPIAP[price]![0])
                .renderingMode(.original)
                .resizable()
                .frame(width: 300, height: 300)
                
            
            HStack {
                VStack(alignment: .leading) {
                    Text(MAPIAP[price]![1])
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text(MAPIAP[price]![2])
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.primary)
                        .lineLimit(3)
                    Text(MAPIAP[price]![3].uppercased())
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                }
                .layoutPriority(100)
                
                Spacer()
                
            }
            .padding()
            
        }
        
        .padding([.top, .horizontal])
        .cornerRadius(15)
        .background(convertHextoRGB(hexColor:"f8f4f4"))
        
        }
        
    }
}

struct IAPCard_Previews: PreviewProvider {
    static var previews: some View {
        IAPCard(price:"$9.99")
    }
}
