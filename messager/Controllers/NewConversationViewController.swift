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
        label.textColor = .black
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    private var users = [[String: String]]()
    private var results = [[String: String]]()
    private var hasFetched = false
    private var spinner = MBProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
}

private extension NewConversationViewController {

    func setupUI() {
        view.addSubview(tableView)
        view.addSubview(noResultLabel)
        tableView.fillToSuperview()
        noResultLabel.anchor(left: view.leftAnchor,
                             bottom: view.bottomAnchor,
                             right: view.rightAnchor,
                             leftConstant: 0,
                             bottomConstant: 16,
                             rightConstant: 0)
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(disTapCancelSearch))
        navigationController?.navigationBar.topItem?.titleView = searchBar
        searchBar.delegate = self
        searchBar.placeholder = searchPlaceholderText
        searchBar.becomeFirstResponder()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.indentifier)
        tableView.tableFooterView = .init(frame: .zero)
        tableView.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func searchUsers(query: String) {
        if hasFetched {
            filterUsers(with: query)
        } else {
            DatabaseManager.shared.getAllUsers { [weak self] (result) in
                switch result {
                case .success(let userCollection):
                    self?.hasFetched = true
                    self?.users = userCollection
                    self?.filterUsers(with: query)
                case .failure(let error):
                    print("Failed to get users: \(error)")
                }
            }
        }
    }
    
    func filterUsers(with term: String) {
        guard hasFetched else { return }
        spinner.hide(animated: true)
        let results: [[String: String]] = users.filter({
            guard let name = $0["name"]?.lowercased() else { return false }
            return name.hasPrefix(term.lowercased())
        })
        self.results = results
        updateUI()
    }
    
    func updateUI() {
        if results.isEmpty {
            noResultLabel.isHidden = false
            tableView.isHidden = true
        }else {
            noResultLabel.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
}
extension NewConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.indentifier, for: indexPath)
        cell.textLabel?.text = results[indexPath.row]["name"]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NewConversationViewController: UISearchBarDelegate {
    @objc func disTapCancelSearch() {
        dismiss(animated: true, completion: nil)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else { return }
        
        searchBar.resignFirstResponder()
        
        results.removeAll()
        spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        searchUsers(query: text)
    }
}

private extension NewConversationViewController {
    var searchPlaceholderText: String { "Search Users" }
}
