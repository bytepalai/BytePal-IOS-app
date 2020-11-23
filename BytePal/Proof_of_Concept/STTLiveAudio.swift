//
//  STTLiveAudio.swift
//  BytePal
//
//  Created by Scott Hom on 7/14/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI
import Speech
import Foundation

//struct STTLiveAudio: View {
//    func viewDidAppear(_ animated: Bool){
//        // Configure the SFSpeechRecognizer object already
//        // stored in a local member variable.
//        speechRecognizer.delegate = self
//
//        // Make the authorization request
//        SFSpeechRecognizer.requestAuthorization { authStatus in
//
//        // The authorization status results in changes to the
//        // app’s interface, so process the results on the app’s
//        // main queue.
//           OperationQueue.main.addOperation {
//              switch authStatus {
//                 case .authorized:
//                    self.recordButton.isEnabled = true
//
//                 case .denied:
//                    self.recordButton.isEnabled = false
//                    self.recordButton.setTitle("User denied access
//                                to speech recognition", for: .disabled)
//
//                 case .restricted:
//                    self.recordButton.isEnabled = false
//                    self.recordButton.setTitle("Speech recognition
//                            restricted on this device", for: .disabled)
//
//                 case .notDetermined:
//                    self.recordButton.isEnabled = false
//                    self.recordButton.setTitle("Speech recognition not yet
//                                           authorized", for: .disabled)
//              }
//           }
//        }
//    }
//    var body: some View {
//        VStack {
//            Text("Request Permission to access microphone")
//        }
//        .onAppear(perform: {
//            // Configure the SFSpeechRecognizer object already
//            // stored in a local member variable.
//            speechRecognizer.delegate = self
//
//            // Make the authorization request
//            SFSpeechRecognizer.requestAuthorization { authStatus in
//
//            // The authorization status results in changes to the
//            // app’s interface, so process the results on the app’s
//            // main queue.
//               OperationQueue.main.addOperation {
//                  switch authStatus {
//                     case .authorized:
//                        self.recordButton.isEnabled = true
//
//                     case .denied:
//                        self.recordButton.isEnabled = false
//                        self.recordButton.setTitle("User denied access
//                                    to speech recognition", for: .disabled)
//
//                     case .restricted:
//                        self.recordButton.isEnabled = false
//                        self.recordButton.setTitle("Speech recognition
//                                restricted on this device", for: .disabled)
//
//                     case .notDetermined:
//                        self.recordButton.isEnabled = false
//                        self.recordButton.setTitle("Speech recognition not yet
//                                               authorized", for: .disabled)
//                  }
//               }
//            }
//        })
//    }
//}
//
//struct STTLiveAudio_Previews: PreviewProvider {
//    static var previews: some View {
//        STTLiveAudio()
//    }
//}
//
