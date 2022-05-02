//
//  Errors.swift
//  ScalioTest
//
//  Created by Helia Fathi on 4/17/22.
//


import Foundation

enum Errors: Error {
    case limitedness, invalidData, connectivity
    
    var message: String {
        switch self {
        case .limitedness:
            return "Please count to 45 mississippily then try scrolling. "
        case .connectivity:
            return "Please check internet connection."
        case .invalidData:
            return "Try again later."
        }
    }
}
