//
//  NewConversationViewController.swift
//  messager
//
//  Created by vladislav dudevich on 11.12.2020.
//

import UIKit
import MBProgressHUD

class NewConversationViewController: UIViewController {
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let noResultLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "No Results"
        label.textAlignment = .center
        label.textColor = .green
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    private var users = [[String: String]]()
    private var hasFetched = false
    private var spinner = MBProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
}

private extension NewConversationViewController {

    func setupUI() {
        navigationController?.navigationBar.topItem?.titleView = searchBar
        searchBar.delegate = self
        searchBar.placeholder = searchPlaceholderText
        searchBar.becomeFirstResponder()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(disTapCancelSearch))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.indentifier)
        tableView.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func searchUsers(query: String) {
        if hasFetched {
            
        } else {
            DatabaseManager.shared.getAllUsers { [weak self] (result) in
                switch result {
                case .success(let userCollection):
                    self?.users = userCollection
                case .failure(let error):
                    print("Failed to get users: \(error)")
                }
            }
        }
    }
    
    func filterUsers(with term: String) {
        guard hasFetched else { return }
    }
}
extension NewConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.indentifier, for: indexPath)
        cell.textLabel?.text = "test label"
        
        return cell
    }
}

extension NewConversationViewController: UISearchBarDelegate {
    @objc func disTapCancelSearch() {
        dismiss(animated: true, completion: nil)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else { return }
        
        spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        searchUsers(query: text)
        
    }
}

private extension NewConversationViewController {
    var searchPlaceholderText: String { "Search Users" }
}
