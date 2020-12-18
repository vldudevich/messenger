//
//  ViewController.swift
//  messager
//
//  Created by vladislav dudevich on 11.12.2020.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class ConversationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
    }
}

private extension ConversationViewController {
    func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {

            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        } else {
            let user = Auth.auth().currentUser

            user?.delete { error in
              if let error = error {
                // An error happened.
              } else {
                // Account deleted.
              }
            }
        }
    }
}
