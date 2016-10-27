//
//  AppDelegate.swift
//  todolist
//
//  Created by david90 on 09/08/2016.
//  Copyright (c) 2016 david90. All rights reserved.
//

import UIKit
import SKYKit

public let ReceivedNotificationFromSkygaer = "ReceivedNotificationFromSkygaer"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SKYContainerDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        SKYContainer.default().configAddress("YOUR-END_POINT")
        SKYContainer.default().configure(withAPIKey: "12345678901234567890123456789012")

        // This will prompt the user for permission to send remote notification
        application.registerUserNotificationSettings(UIUserNotificationSettings())
        application.registerForRemoteNotifications()
        
        SKYContainer.default().delegate = self
        
        SKYContainer.default().registerDeviceCompletionHandler { (deviceID, error) in
            if error != nil {
                print("Failed to register device: \(error)")
                return
            }
            
            // You should put subscription creation logic in the following method
            self.addSubscription(deviceID!)
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Registered for Push notifications with token: \(deviceToken)");
    }
    
    func container(_ container: SKYContainer!, didReceive notification: SKYNotification!) {
        print("received notification = \(notification)");
        NotificationCenter.default.post(name: Notification.Name(rawValue: ReceivedNotificationFromSkygaer), object: notification)
    }
    
    func addSubscription(_ deviceID: String) {
        let query = SKYQuery(recordType: "todo", predicate: nil)
        let subscription = SKYSubscription(query: query, subscriptionID: "my todos")
        
        let operation = SKYModifySubscriptionsOperation(deviceID: deviceID, subscriptionsToSave: [subscription])
        operation?.deviceID = deviceID
        operation?.modifySubscriptionsCompletionBlock = { (savedSubscriptions, operationError) in
            DispatchQueue.main.async {
                if operationError != nil {
                    print(operationError)
                }
            }
        };
        SKYContainer.default().privateCloudDatabase.execute(operation)
    }
}

