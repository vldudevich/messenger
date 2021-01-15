//
//  ProfileViewController.swift
//  messager
//
//  Created by vladislav dudevich on 11.12.2020.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class ProfileViewController: UIViewController {
    let tableView = UITableView()
    let data = ["Log Out"]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

private extension ProfileViewController {
    func createTableHeader() -> UIView? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else { return nil }
        let safeEmail = DatabaseManager.shared.safeEmail(emailAddress: email)
        let fileName = safeEmail + "_profile_picture_name.png"
        let path = "images/\(fileName)"
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: 150))
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = imageView.width / 2
        imageView.layer.masksToBounds = true
        
        headerView.addSubview(imageView)
        imageView.anchor(top: headerView.topAnchor,
                         left: headerView.leftAnchor,
                         bottom: headerView.bottomAnchor,
                         right: headerView.rightAnchor,
                         topConstant: 0,
                         leftConstant: 0,
                         bottomConstant: 0,
                         rightConstant: 0)
        StorageManager.shared.dowloadURL(for: path, completion: {[weak self] result in
            switch result {
            case .success(let url):
                self?.downloadImage(imageView: imageView, url: url)
            case .failure(let error):
                print("Failed to get dowload url: \(error)")
            }
        })
        return headerView
    }
    func downloadImage(imageView: UIImageView, url: URL) {
        URLSession.shared.dataTask(with: url, completionHandler: {data, _, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                imageView.image = image
            }
        }).resume()
    }
    func setupUI() {
        title = "Profile"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        view.addSubview(tableView)
        setConstrains()
        edgesForExtendedLayout = []
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.indentifier)
        tableView.tableFooterView = .init(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = createTableHeader()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.indentifier, for: indexPath)
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
            // Log out Facebook
            FBSDKLoginKit.LoginManager().logOut()
            // Log out Google
            GIDSignIn.sharedInstance()?.signOut()
            
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
