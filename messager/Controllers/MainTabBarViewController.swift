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
            createTabBarItem(tabBarTitle: "Chats", tabBarImage: "message", viewController: ConversationViewController()),
            createTabBarItem(tabBarTitle: "Profile", tabBarImage: "person", viewController: ProfileViewController())
        ]
    }
    
    func createTabBarItem(tabBarTitle: String,
                          tabBarImage: String,
                          viewController: UIViewController) -> UINavigationController {
        
        let navCont = UINavigationController(rootViewController: viewController)
        viewController.edgesForExtendedLayout = []
        navCont.tabBarItem.title = tabBarTitle
        navCont.tabBarItem.image = UIImage(systemName: tabBarImage)
        
        navCont.navigationBar.barTintColor = .lightGray
        navCont.navigationBar.tintColor = .systemBlue
        return navCont
    }
}
