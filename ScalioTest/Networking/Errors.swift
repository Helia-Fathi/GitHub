//
//  Errors.swift
//  ScalioTest
//
//  Created by Helia Fathi on 4/17/22.
//


import Foundation

enum Errors: Error {
    case connectivity, invalidData
    
    var message: String {
        switch self {
        case .connectivity:
            return "Failed to connect. Please check internet connection."
        case .invalidData:
            return "Some error occured. Try again later."
        }
    }
}
