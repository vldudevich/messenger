//
//  ProfileViewController.swift
//  messager
//
//  Created by vladislav dudevich on 11.12.2020.
//

import UIKit
import FirebaseAuth
class ProfileViewController: UIViewController {

    let tableView = UITableView()
    let data = ["Log Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

private extension ProfileViewController {
    func setupUI() {
        title = "Profile"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        view.addSubview(tableView)
        setConstrains()
        edgesForExtendedLayout = []
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = .init(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
    }
    
    func setConstrains() {
        tableView.anchor(top: view.topAnchor,
                         left: view.leftAnchor,
                         bottom: view.bottomAnchor,
                         right: view.rightAnchor,
                         topConstant: 0,
                         leftConstant: 0,
                         bottomConstant: 0,
                         rightConstant: 0)
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let actionController = UIAlertController(title: "Log out",
                                                 message: "Are you sure you want to log out",
                                                 preferredStyle: .alert)
        let logOutAction = UIAlertAction(title: "OK", style: .destructive) { [weak self] _ in

            guard let self = self else { return }
            do {
                try FirebaseAuth.Auth.auth().signOut()
                
                let vc = LoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
            catch {
                
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionController.addAction(logOutAction)
        actionController.addAction(cancelAction)
        
        present(actionController, animated: true)
    }
}
