//
//  Constants.swift
//  ScalioTest
//
//  Created by Helia Fathi on 5/2/22.
//

import UIKit

struct K {
    
    
    
    static let lastPageDefault = false
    
    struct Dimentions {
        
        static let minPixcelToReq: CGFloat = 50
        static let imageCornerRadius: CGFloat = 5
        static let textFieldCornerRadius: CGFloat = 10
        static let buttonCornerRadius: CGFloat = 10
        static let stackViewSpacing: CGFloat = 10
        static let pageSize: CGFloat = 9
        static let pageNumber = 1
        static let rightMargin: CGFloat = 16
        static let leftMargin: CGFloat = 16
        static let buttonEdge = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
        
        struct responseCode {
            static let statusCodeSuccess = 200
            static let statusCodeFailRangeResponse = 210
        }
    }
    
    struct Strings {
        
        static let navTitle = "Search in Github Users Names"
        static let empty = ""
        static let fatalErr = "init has not been implemented"
        static let customCell = "userCell"
        
        struct Alert {
            static let limmitRequestMessage = "Please count to 45 mississippily then try scrolling."
            static let connectivityMessage = "Please check internet connection."
            static let invalidDataMessage = "Try again later."
            static let positiveMessage = "Okay"
            static let gitConnectivityTitle = "OoOpS!"
            
        }
        
        struct remote {
            static let login = "login"
            static let type = "type"
            static let image = "avatar_url"
        }
    }
    
}
