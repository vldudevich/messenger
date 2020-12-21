//
//  AppDelegate.swift
//  messager
//
//  Created by vladislav dudevich on 11.12.2020.
//

import UIKit
import Firebase
import IQKeyboardManager
import FBSDKCoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:
                        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = MainTabBarViewController()
        window?.makeKeyAndVisible()
        FirebaseApp.configure()
        IQKeyboardManager.shared().isEnabled = true
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL,
                      options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool {
        ApplicationDelegate.shared.application( app,
                                                open: url,
                                                sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                annotation: options[UIApplication.OpenURLOptionsKey.annotation] ) }
}
