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
import GoogleSignIn

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
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID

        return true
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
        let googleDidHandle = GIDSignIn.sharedInstance().handle(url)
        let facebookDidHandle = ApplicationDelegate.shared.application( application,
                                                                        open: url,
                                                                        sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                                        annotation: options[UIApplication.OpenURLOptionsKey.annotation] )
        return googleDidHandle || facebookDidHandle
    }
}
