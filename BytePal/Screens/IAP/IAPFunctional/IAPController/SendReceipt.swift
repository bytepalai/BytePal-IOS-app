//
//  SendReceipt.swift
//  BytePal
//
//  Created by Paul Ngouchet on 9/1/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//
import Foundation
import AVFoundation
import Alamofire

class Receipt {
    static func sendReceipt(productID:String,
                            receiptUrl:String,
                            originalTransactionId:String,
                            purchaseDateMs:String,
                            expiresDateMs:String,
                            latestReceipt:String,
                            webOrderLineItemId:String){
        
        //      Define header of POST Request
        let urlRequest =  "\(API_HOSTNAME)/save_receipt"
        var request = URLRequest(url: URL(string: "\(API_HOSTNAME)/save_receipt")!,
                                 timeoutInterval: Double.infinity)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        //Define body of POST Request
        // Change this to the environment variable when the user logs in
        let userInformation: UserInformation = UserInformation()
        let userID = userInformation.id
        print("----------- receipt(USER ID): \(userInformation.id)")
        
        let parameters : Parameters = [
            "user_id": userID,
            "original_transaction_id":originalTransactionId,
            "expires_date_ms":expiresDateMs,
            "latest_receipt": latestReceipt,
            "is_subscribed":"True",
            "will_auto_renew":"True",
            "web_order_line_item_id":webOrderLineItemId,
            "purchase_date_ms":purchaseDateMs,
            "product_id": productID,
            "receipt_url":receiptUrl
        ]
        
        print(parameters)

        let headers: HTTPHeaders = [
                   "Accept": "application/json"
               ]
        
        AF.request(urlRequest,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers
                  )
            .responseString  { response in
                print(response.request) // original url request
                print(response.response) // http url reponse
            
        }
        
    }
    
}

