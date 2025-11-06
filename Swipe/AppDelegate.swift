//
//  AppDelegate.swift
//  Swipe
//
//  Created by Apple  on 25/10/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit
import Stripe

import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate/*, MessagingDelegate*/ {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
         // Stripe.setDefaultPublishableKey("pk_live_phy6oQoNq0ZRjTKWpI668OD9004EN4r4tr")
         // Stripe.setDefaultPublishableKey("pk_test_51N4UjxIccD3egFe4JHkgdV0K73MeRhylVlcdj9pbMvjSZWsoeWRUy5d3Rqj1JTWG2cf6LkE7QhyKyOYG0rli2OgZ00bFYsbANS")
        
        StripeAPI.defaultPublishableKey = "pk_test_51N4UjxIccD3egFe4JHkgdV0K73MeRhylVlcdj9pbMvjSZWsoeWRUy5d3Rqj1JTWG2cf6LkE7QhyKyOYG0rli2OgZ00bFYsbANS"
        
//        public static String PUBLISHABLE_KEY = "pk_test_51N4UjxIccD3egFe4JHkgdV0K73MeRhylVlcdj9pbMvjSZWsoeWRUy5d3Rqj1JTWG2cf6LkE7QhyKyOYG0rli2OgZ00bFYsbANS";
//        public static String SECRET_KEY = "sk_test_51N4UjxIccD3egFe4x73rOXW2jt1gu4YAauRwFxSJnlF8Xy64UO2njD5EPfNnZ0mFKKJnw8uAZjpD4OJHBJ0Ai0U200OGV8U0w5";
        
        self.registerForRemoteNotifications(application)
        
        // Messaging.messaging().delegate = self
        
        self.firebaseTokenIs()
        return true
    }
    
    @objc func registerForRemoteNotifications(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()

    }
    
    @objc func firebaseTokenIs() {
        /*InstanceID.instanceID().instanceID { (result, error) in
          if let error = error {
            print("Error fetching remote instance ID: \(error)")
          } else if let result = result {
            print("Remote instance ID token: \(result.token)")
            
            let defaults = UserDefaults.standard
            defaults.set("\(result.token)", forKey: "deviceFirebaseToken")
            // self.instanceIDTokenMessage.text  = "Remote InstanceID token: \(result.token)"
          }
        }*/
    }
    
    /*
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
      print("Firebase registration token: \(fcmToken)")

      let dataDict:[String: String] = ["token": fcmToken]
      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    */
    
    @objc func deviceTokenForMessaging() {
        
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

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
      // if let messageID = userInfo[gcmMessageIDKey] {
        // print("Message ID: \(messageID)")
      // }

      // Print full message.
      print(userInfo)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
      // if let messageID = userInfo[gcmMessageIDKey] {
        // print("Message ID: \(messageID)")
     //  }

      // Print full message.
       print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }

}

