//
//  AppDelegate.swift
//  Instasnaps
//
//  Created by Pritam Hinger on 26/12/17.
//  Copyright © 2017 AppDevelapp. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        window = UIWindow()
        window?.rootViewController = MainTabBarController()
        
        attemptRegisterForNotification(application)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Inside didRegisterForRemoteNotificationsWithDeviceToken with deviceToken : \(deviceToken)")
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Inside didReceiveRegistrationToken with fcmToken : \(fcmToken)")
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        guard let followerId = userInfo["followerId"] as? String else { return }
        
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileController.userId = followerId
        
        if let mainTabViewController = window?.rootViewController as? MainTabBarController{
            mainTabViewController.selectedIndex = 0
            mainTabViewController.presentedViewController?.dismiss(animated: true, completion: nil)
            
            guard let homeNavigaitonController = mainTabViewController.viewControllers?.first as? UINavigationController else { return}
            homeNavigaitonController.pushViewController(userProfileController, animated: true)
        }
        
    }
    
    func attemptRegisterForNotification(_ application: UIApplication) {
        print("Inside attemptRegisterForNotification")
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        let autorizationOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: autorizationOptions) { (granted, error) in
            if let error = error{
                print("Failed to get authorization", error)
                return
            }
            
            if(granted){
                print("Authorization granted")
            }
            else{
                print("Authorization denied")
            }
        }
        
        application.registerForRemoteNotifications()
    }
}

