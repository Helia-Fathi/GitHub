//
//  CellVM.swift
//  ScalioTest
//
//  Created by Helia Fathi on 4/17/22.
//

import Foundation


struct UserCellViewModel {
    private let profile: UserModel
    
    init(_ profile: UserModel){
        self.profile = profile
    }
    
    var name: String {
        profile.login
    }
    
    var type: String {
        profile.type
    }
    
    var avatar: URL {
        profile.imageURL
    }
}

