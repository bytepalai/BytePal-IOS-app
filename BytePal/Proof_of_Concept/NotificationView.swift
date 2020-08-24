//
//  NotificationView.swift
//  BytePal
//
//  Created by may on 7/20/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI
import UserNotifications


struct NotificationView: View {
    func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func makeNotification() {
        let content = UNMutableNotificationContent()
        content.title = "BytePal"
        content.subtitle = "How was lunch Paul?"
        content.sound = UNNotificationSound.default

        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
    
    var body: some View {
        VStack {
            Text("Notifications")
            Button(action: {
                self.requestNotificationPermissions()
                self.makeNotification()
            }){
                Text("Make Notification")
            }
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
