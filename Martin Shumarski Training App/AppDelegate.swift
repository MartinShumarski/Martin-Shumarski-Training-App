//
//  AppDelegate.swift
//  Martin Shumarski Training App
//
//  Created by Martin Shumarski on 4.02.19.
//  Copyright © 2019 Martin Shumarski. All rights reserved.
//

import UIKit
#if DEBUG
import AdSupport
#endif

import Leanplum
import UserNotifications
import IQKeyboardManagerSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
    
        // Override point for customization after application launch.
        Variables.initLPVariables()
//        DispatchQueue.main.async {
//          UIApplication.shared.registerForRemoteNotifications()
//        }
        registerForPush()
        
        Leanplum.setVerboseLoggingInDevelopmentMode(true)
        
        MessageTemplates.sharedTemplates()
        
        Leanplum.setAppId("app_3akJYWhfagBZwknwnvwUtImUqr3B0djmD3rTOqdapAw",
                          developmentKey:"dev_K99NEDFANXO0t0HyoqyLaAFg1xb5o3XuzB3u9DnDdhU")
        
        
    
    
       // MartinApp2 Keys - app_3akJYWhfagBZwknwnvwUtImUqr3B0djmD3rTOqdapAw and withProductionKey prod_qJfTbh7EAPQVnehPR6sDhCe7a3LIDNichs5VW01Mqkk
        // Martin Dev Key - dev_K99NEDFANXO0t0HyoqyLaAFg1xb5o3XuzB3u9DnDdhU
        
        
        //Leanplum.track("priorStart")
        Leanplum.trackInAppPurchases()
        
        Leanplum.start(userId:"marto3", attributes: ["attribute":"firstAttribute"])
        print("Start called")
        
        //Leanplum.setUserId("uniqueUser12")
      
        Leanplum.track("jsonEvent", params:["jsonParams":"{\"lat\":13.7457329,\"lng\":100.5392942}"])

        //Leanplum.forceContentUpdate()
        
        
        Leanplum.onStartResponse{ (success: Bool) in
            if success == true {
               let variants =  Leanplum.variants()
                print("These are my variants \(variants)")
                print("start response received")
                
            }
        }
        
        // IQ Keyboard manager - auto hide the keyboard
        IQKeyboardManager.shared.enable = true
        
        
     
        
        
        return true
    }
    
    

//    func application(_ application: UIApplication,
//                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
//                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        completionHandler(.newData)
//
//    }
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        let msg = "App Open Url \(url.absoluteURL)"
//        print(msg)
//        return false
//    }
    
  
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
    
    
    //    // Adding methods for disabled swizzling
    //
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Needs to be called if swizzling is disabled in Info.plist otherwise it won’t affect SDK if swizzling is enabled.
        let token = deviceToken.map { String(format: "%02.2hhx", $0)}.joined()
        print("This is the token " + token)
        Leanplum.didRegisterForRemoteNotifications(withDeviceToken:deviceToken)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Needs to be called if swizzling is disabled in Info.plist otherwise it won’t affect SDK if swizzling is enabled.
        Leanplum.didFailToRegisterForRemoteNotificationsWithError(error)
        let errror = Error.self
        print(error) }


    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let leanplumCompletionHandler: LeanplumFetchCompletionBlock = { (lpBlock:LeanplumUIBackgroundFetchResult) in
        let result = UIBackgroundFetchResult.init(rawValue: lpBlock)!
        var fetchResult = ""
        switch result {
        case .newData:
        fetchResult = "newData"
        case .noData:
        fetchResult = "noData"
        case .failed:
        fetchResult = "failed"
        @unknown default:
        fetchResult = "unknown"
        }
        print("Completion Handler executed \(fetchResult)")
        completionHandler(result)
        }

        Leanplum.didReceiveRemoteNotification(userInfo, fetchCompletionHandler: leanplumCompletionHandler)
        print("Success")
        print(userInfo)
        print(leanplumCompletionHandler)
    }
    
    
    
    // Uncomment below if Swizzling is Turned ON
    
//  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//    Leanplum.didReceive(response, withCompletionHandler: completionHandler)
//    print("Success")
//    }
//
//
//
//    func application(_ application: UIApplication,
//                     didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
//        // Needs to be called if swizzling is disabled in Info.plist otherwise it won’t affect SDK if swizzling is enabled.
//        Leanplum.didReceiveRemoteNotification(userInfo)
//    }
//    func application(_ application: UIApplication,
//                                        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
//                  fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//           completionHandler(.newData)
//            }
//
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler(.alert)
//    }
    
    
    
    
    func registerForPush () {
        //iOS-10
        if #available(iOS 10.0, *){
            let userNotifCenter = UNUserNotificationCenter.current()
            
            userNotifCenter.requestAuthorization(options: [.badge,.alert,.sound]){ (granted,error) in
                //Handle individual parts of the granting here.
                
                
            }
            
         
            //UIApplication.shared.registerForRemoteNotifications()
        }
            //iOS 8-9
        else if #available(iOS 8.0, *){
            let settings = UIUserNotificationSettings.init(types: [UIUserNotificationType.alert,UIUserNotificationType.badge,UIUserNotificationType.sound],
                                                           categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
            //iOS 7
        else{
            UIApplication.shared.registerForRemoteNotifications(matching:
                [UIRemoteNotificationType.alert,
                 UIRemoteNotificationType.badge,
                 UIRemoteNotificationType.sound])
        }
    

    }
 

}

