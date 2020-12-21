//
//  MainTabBarViewController.swift
//  messager
//
//  Created by vladislav dudevich on 18.12.2020.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = [
            createTabBarItem(tabBarTitle: "Chats",
                             tabBarImage: "message",
                             viewController: ConversationViewController()),
            
            createTabBarItem(tabBarTitle: "Profile",
                             tabBarImage: "person",
                             viewController: ProfileViewController())
        ]
    }
    
    private func createTabBarItem(tabBarTitle: String,
                          tabBarImage: String,
                          viewController: UIViewController) -> UINavigationController {
        
        let navCont = UINavigationController(rootViewController: viewController)
        navCont.tabBarItem.title = tabBarTitle
        if #available(iOS 13.0, *) {
            navCont.tabBarItem.image = UIImage(systemName: tabBarImage)
        } else {
            navCont.tabBarItem.image = UIImage(named: tabBarImage)
        }
        navCont.navigationBar.prefersLargeTitles = true

        return navCont
    }
}
