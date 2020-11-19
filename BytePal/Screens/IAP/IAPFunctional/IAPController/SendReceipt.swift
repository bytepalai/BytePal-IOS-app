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
import SwiftUI

class Receipt {    
    static func sendReceipt(userID: String,
                            productID:String,
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
                
                // IAP Purchase Error handeling
                if response.response?.statusCode == 200 {
                    print("Purchased subscription succesfully")
                } else {
                    print("Error: Subscription purchased unsecesfully. HTTP Status Code: \(String(describing: response.response?.statusCode))")
                }
                
            }
        
    }
    
}

