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
            return K.Strings.Alert.limmitRequestMessage
        case .connectivity:
            return K.Strings.Alert.connectivityMessage
        case .invalidData:
            return K.Strings.Alert.invalidDataMessage
        }
    }
}
