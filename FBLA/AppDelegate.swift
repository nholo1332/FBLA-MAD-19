//
//  AppDelegate.swift
//  FBLA
//
//  Created by Noah Holoubek on 1/19/19.
//  Copyright © 2019 Noah H. All rights reserved.
//

import UIKit
import Firebase
import FacebookCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    //TODO: Add comments for code
    //TODO: Clean up code and remove prints and commented code
    //TODO: Custom app icon
    //TODO: README with instructions
    //TODO: Finish the onboarding view

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Another setup for Facebook SDK
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //Configure and start Firebase
        FirebaseApp.configure()
        
        //Setup the root (main and initial) view controller and present it
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let vcController = LoadingViewController(nibName: "LoadingViewController", bundle: nil)
        
        window!.rootViewController = vcController
        window!.makeKeyAndVisible()
        
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
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        //Facebook SDK URL initialization
        let appId = SDKSettings.appId
        if url.scheme != nil && url.scheme!.hasPrefix("fb\(appId)") && url.host ==  "authorize" {
            return SDKApplicationDelegate.shared.application(app, open: url, options: options)
        }
        return false
    }


}

