//
//  DataBaseManager.swift
//  messager
//
//  Created by vladislav dudevich on 15.12.2020.
//

import Foundation
import FirebaseDatabase

class DatabaseManager {
    
    private init() {}
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    func userExists(with email: String, completion: @escaping ((Bool) -> Void)) {
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        database.child(safeEmail).observeSingleEvent(of: .value, with: { (snapshot) in
            guard snapshot.value as? String != nil else { completion(false); return }
            
            completion(true)
        })
    }
    
    func insertUser(with user: ChatAppUser) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName
        ])
    }
    
    func removeDB() {
        database.removeAllObservers()
    }
}

struct ChatAppUser {
    let firstName: String
    let lastName: String
    let emailAdress: String
    
    var safeEmail: String {
        var safeEmail = emailAdress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}
