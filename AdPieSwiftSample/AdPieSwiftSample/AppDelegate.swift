//
//  AppDelegate.swift
//  AdPieSwiftSample
//
//  Created by sunny on 2016. 5. 31..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

import UIKit
import AdPieSDK
import AppTrackingTransparency

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
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
        // 디버깅 적용
        AdPieSDK.sharedInstance().logging()
        
        if #available(iOS 14, *) {
            // ATT 알림을 통한 권한 요청
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                // SDK 초기화
                if AdPieSDK.sharedInstance().isInitialized == false {
                    AdPieSDK.sharedInstance().initWithMediaId("57342d787174ea39844cac11")
                }
            })
        } else {
            // SDK 초기화
            if AdPieSDK.sharedInstance().isInitialized == false {
                AdPieSDK.sharedInstance().initWithMediaId("57342d787174ea39844cac11")
            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

