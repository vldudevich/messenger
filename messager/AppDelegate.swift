//
//  AppDelegate.swift
//  messager
//
//  Created by vladislav dudevich on 11.12.2020.
//

import UIKit
import Firebase
import IQKeyboardManager

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:
                        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainTabBarViewController()
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        
        FirebaseApp.configure()
        IQKeyboardManager.shared().isEnabled = true
        
        return true
    }
}

