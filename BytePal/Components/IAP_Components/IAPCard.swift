//
//  IAPCard.swift
//  BytePal
//
//  Created by Paul Ngouchet on 8/28/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI



struct IAPCard: View {
    
    //var image: String
    //var plan: String
    var price: String
    //var action: String
    
    
    var body: some View {
        
        ZStack{
        RoundedRectangle(cornerRadius: 25, style: .continuous)                                          // Text box border
            .fill(convertHextoRGB(hexColor: "ffffff"))
            .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0))
            .shadow(color: convertHextoRGB(hexColor: "000000").opacity(0.33), radius: 4, x: 3, y: 3)
        VStack {
            Image(MAPIAP[price]![0])
                .renderingMode(.original)
                .resizable()
                //.aspectRatio(contentMode: .fit)
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
        //.cornerRadius(10)
        //.overlay(
            //RoundedRectangle(cornerRadius: 10).stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
        //)
        .padding([.top, .horizontal])
        //.background(Color.white)
        //.shadow(radius: 10.0)
        .cornerRadius(15)
        //.shadow(color: convertHextoRGB(hexColor: "000000").opacity(0.33), radius: 3, x: 3, y: 7)
        //.shadow(color:Color.black,radius:2)
        .background(convertHextoRGB(hexColor:"f8f4f4"))
        
            
        }
        
    }
}

struct IAPCard_Previews: PreviewProvider {
    static var previews: some View {
        IAPCard(price:"$9.99")

    }
}
