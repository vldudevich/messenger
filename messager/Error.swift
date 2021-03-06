//
//  Error.swift
//  messager
//
//  Created by vladislav dudevich on 16.12.2020.
//

import Foundation

enum Errors: Error {
    
    case noUserId
    case noUserToken
    case noFullFillProfile
    case noLogout
    case failedInsertToBD
    case failedGetFromBD
    
    var errorText: String {
        switch self {
        case .noUserId:
            return "Device ID not obtained"
        case .noUserToken:
            return "User token not obtained"
        case .noFullFillProfile:
            return "Please fill all field"
        case .noLogout:
            return "Failed to logout"
        case .failedInsertToBD:
            return "Failed insert User to BD"
        case .failedGetFromBD:
            return "Failed Get From BD"
        }
    }
}
