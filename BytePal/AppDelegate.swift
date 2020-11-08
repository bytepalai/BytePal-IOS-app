//
//  AppDelegate.swift
//  BytePal
//
//  Created by may on 7/10/20.
//  Copyright © 2020 BytePal. All rights reserved.
//

import UIKit
import CoreData
import FBSDKCoreKit
import GoogleSignIn
import PushNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate  {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let result = self.pushNotifications.start(instanceId: "9400f4c9-0860-409a-b5ea-7273af4abe98")
        let result2 = self.pushNotifications.registerForRemoteNotifications()
        try? self.pushNotifications.addDeviceInterest(interest: "hello")
               
        GIDSignIn.sharedInstance().clientID = "1005929182171-0k0i1sqdmet6hk0hrj3b1blfoiiul3op.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = googleDelegate

        return true
    }
    
    // Lock orientation to portrait
    static var orientationLock = UIInterfaceOrientationMask.portrait

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
    
    
    // Init push notificaitons
    let pushNotifications = PushNotifications.shared
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.pushNotifications.registerDeviceToken(deviceToken)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        self.pushNotifications.handleNotification(userInfo: userInfo)
    }
    
    // Define Google Sign Controller
    
    let googleDelegate: GoogleDelegate = GoogleDelegate()
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
      if let error = error {
        if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
          print("The user has not signed in before or they have since signed out.")
        } else {
          print("\(error.localizedDescription)")
        }
        // [START_EXCLUDE silent]
        NotificationCenter.default.post(
          name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: nil)
        // [END_EXCLUDE]
        return
      }
      // Perform any operations on signed in user here.
        let idToken = user.authentication.idToken ?? "" // Safe to send to the server
      let fullName = user.profile.name ?? ""          // full name
      let givenName = user.profile.givenName  ?? ""
      let familyName = user.profile.familyName  ?? ""
      let email = user.profile.email  ?? ""
        
      // [START_EXCLUDE]

      // Get userID BytePal API

        let bytePalAuth: BytePalAuth = BytePalAuth()
        let BPUserID: String = bytePalAuth.googleLogin(id: idToken, email: email, first_name: givenName, last_name: familyName)

      NotificationCenter.default.post(
        name: Notification.Name(rawValue: "ToggleAuthUINotification"),
        object: nil,
        userInfo: ["statusText": "Signed in user:\n\(fullName)"])
      // [END_EXCLUDE]
    }
    // [END signin_handler]
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
      withError error: NSError!) {
        
        print("------------ USING THIS HANDLER --------")
        
        if (error == nil) {
          print("Callback Success!!!")
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
      //IAPManager.shared.stopObserving()
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "BytePal")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
