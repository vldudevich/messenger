//
//  StorageManager.swift
//  messager
//
//  Created by vladislav dudevich on 24.12.2020.
//

import Foundation
import FirebaseStorage

typealias UploadPictureCompletion = (Result<String, Error>) -> Void

class StorageManager {
    
    private init() {}
    
    static let shared = StorageManager()
    private let storage = Storage.storage().reference()
    
    
    func uploadProfilePicture(with data: Data,
                              fileName: String,
                              completion: @escaping UploadPictureCompletion) {
        //failed upload
        storage.child("images/\(fileName)").putData(data, metadata: nil) {[weak self] (metada, error) in
            guard let self = self else { return }
            guard metada != nil, error == nil else {
                completion(.failure(Errors.noUserId))
                return
            }
            self.storage.child("images/\(fileName)").downloadURL { (url, error) in
                guard let url = url else {
                    completion(.failure(Errors.noUserId))
                    return
                }
                let urlString = url.absoluteString
                print("download url: \(urlString)")
                completion(.success(urlString))
            }
        }
    }
    
    func dowloadURL(for path: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let reference = storage.child((path))
        
        reference.downloadURL { (url, error) in
            guard let url = url, error == nil else {completion(.failure(Errors.noUserToken)); return }
            completion(.success(url))
        }
    }
}
