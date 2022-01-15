//
//  NetworkError.swift
//  Contacts
//
//  Created by Justin Lowry on 1/14/22.
//

import Foundation

enum NetworkError: LocalizedError {
    case ckError(Error)
    case noData
    case unableToDecode
    
    var errorDescription: String? {
        switch self {
        case .ckError(let error):
            return "Error: \(error.localizedDescription) -- \(error)"
        case .noData:
            return "The server returned with no data"
        case .unableToDecode:
            return "There was an error trying to decode the data"
        }
    }
} // End of enum
