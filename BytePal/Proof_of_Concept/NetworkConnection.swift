//
//  NetworkConnection.swift
//  BytePal
//
//  Created by Scott Hom on 7/10/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI
import Network

struct NetworkConnection: View {
    @State var connectionStatus: Bool = true
    @State var cellularDataStatus: Bool = true
    let monitor = NWPathMonitor()
    
    func checkNetworkStatus() {
        self.monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.connectionStatus = true
            } else {
                self.connectionStatus = false
            }

            self.cellularDataStatus = path.isExpensive ? true : false
        }
        let queue = DispatchQueue(label: "Monitor")
        self.monitor.start(queue: queue)
    }
    func press() {
        print("Press")
    }
    
    var body: some View {
        VStack {
            connectionStatus ? Text("Connection Status: Connected") : Text("Connection Status: NOT Connected")
            cellularDataStatus ? Text("Cellular Data Connection Status: using") : Text("Cellular Data Connection Status: NOT being used")
            Button(action: {
                print("Button pressed")
                self.checkNetworkStatus()
            }){
                Text("Update")
            }
            Button(action: {
                print("Button pressed")
                self.press()
            }){
                Text("Press")
            }
        }
    }
}

struct NetworkConnection_Previews: PreviewProvider {
    static var previews: some View {
        NetworkConnection()
    }
}
