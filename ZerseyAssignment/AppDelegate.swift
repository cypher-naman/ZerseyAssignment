//
//  AppDelegate.swift
//  ZerseyAssignment
//
//  Created by Naman Sharma on 28/06/20.
//  Copyright © 2020 Naman Sharma. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
//        window = UIWindow()
//        window?.makeKeyAndVisible()
//
//        let vc = SignInViewController()
//        window?.rootViewController = vc
//        window = UIWindow(frame: UIScreen.main.bounds)
//        window?.makeKeyAndVisible()
//        
//        let signInViewController = SignInViewController()
//        signInViewController.title = "Sign IN"
//        
//        let navigationController = NavigationController()
//        navigationController.title = "Assignment App"
//        let mainVC = MainViewController()
//        mainVC.title = "Draw Pad"
//        navigationController.viewControllers = [signInViewController,mainVC]
//        window?.rootViewController = navigationController
        return true
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


}

