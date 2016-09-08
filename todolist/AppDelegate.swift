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


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        SKYContainer.defaultContainer().configAddress("YOUR-END-POINT")
        SKYContainer.defaultContainer().configureWithAPIKey("12345678901234567890123456789012")
        // This will prompt the user for permission to send remote notification
        application.registerUserNotificationSettings(UIUserNotificationSettings())
        application.registerForRemoteNotifications()
        
        SKYContainer.defaultContainer().registerDeviceCompletionHandler { (deviceID, error) in
            if error != nil {
                print("Failed to register device: \(error)")
                return
            }
            
            // You should put subscription creation logic in the following method
            // self.addSubscription(deviceID)
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("Registered for Push notifications with token: \(deviceToken)");
    }
    
    func container(container: SKYContainer!, didReceiveNotification notification: SKYNotification!) {
        print("received notification = \(notification)");
        NSNotificationCenter.defaultCenter().postNotificationName(ReceivedNotificationFromSkygaer, object: notification)
    }
}

