//
//  AppDelegate.swift
//  dsm
//
//  Created by LinaNfinE on 6/2/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

import UIKit
//import AppTrackingTransparency
import AdSupport
import GoogleMobileAds
import FBAudienceNetwork
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //srand(UInt32(Date().timeIntervalSinceReferenceDate))
        //UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
        // Revisit Facebook用の広告トラッキング設定。ここでいいのか不明
        FBAdSettings.setAdvertiserTrackingEnabled(true)

        GADMobileAds.sharedInstance().start(completionHandler: nil)
        FirebaseApp.configure()

        // GoogleSignInの初期化を追加
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(
            clientID: "709569493981-q41hfgshokr29mmpmfdf3afeg9nod4fp.apps.googleusercontent.com"
        )
        
        return true
    }
    
    // iOS 9以降で必要なURL処理メソッド
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
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
        let notif: Notification = Notification(name: Notification.Name(rawValue: "applicationWillEnterForeground"), object: self)
        NotificationCenter.default.post(notif)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

