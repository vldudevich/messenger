//
//  ViewController.swift
//  messager
//
//  Created by vladislav dudevich on 11.12.2020.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import MBProgressHUD

class ConversationViewController: UIViewController {
    private let spinner = MBProgressHUD()
    private let tableView = UITableView()
    private let noConversationLabel: UILabel = {
        let label = UILabel()
        label.text = "No Conversation!"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
    }
}

private extension ConversationViewController {
    func setupUI() {
        title = "Chats"
        view.backgroundColor = .white
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(didTapAddButton))
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        edgesForExtendedLayout = []
        view.addSubview(noConversationLabel)
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.indentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.safeAreaLayoutGuide.leftAnchor,
                         bottom: view.bottomAnchor,
                         right: view.rightAnchor,
                        topConstant: 0,
                        leftConstant: 0,
                        bottomConstant: 0,
                        rightConstant: 0)
        fetchConversations()
    }
    func fetchConversations() {
        tableView.isHidden = false
    }
    
    @objc func didTapAddButton() {
        let navVC = UINavigationController(rootViewController: NewConversationViewController())
        present(navVC, animated: true)
    }
    
    func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {

            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        } else {
            let user = Auth.auth().currentUser

//            user?.delete { error in
//              if let error = error {
//                // An error happened.
//              } else {
//                // Account deleted.
//              }
//            }
        }
    }
}
extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.indentifier, for: indexPath)
        cell.textLabel?.text = "test"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ChatViewController()
        vc.title = "Jenny Smith"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
