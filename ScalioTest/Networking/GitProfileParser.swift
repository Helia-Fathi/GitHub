//
//  GitProfileParser.swift
//  ScalioTest
//
//  Created by Helia Fathi on 4/16/22.
//

import Foundation
import RxSwift
import Moya

final class GitProfileParser {

    private init(){}
    
    static func map(_ response: Response) throws -> Single<[UserModel]> {
        if response.statusCode == 200, let root = try? JSONDecoder().decode(GitHubProfileRoot.self, from: response.data) {
            return Single.create { single in
                single(.success(root.sortedProfileModel))
                return Disposables.create()
            }
        }
        throw Errors.invalidData
    }
    
    private struct GitHubProfileRoot: Decodable {
        private let items: [GitProfile]
        
        var profileModels: [UserModel] {

            items.map {
                return $0.profileModel
             }
        }
        
        var sortedProfileModel: [UserModel] {
            
            profileModels.sorted {
                return $0.login.lowercased() < $1.login.lowercased()
            }
        }
        
        
        private struct GitProfile: Decodable {
            let login: String
            let type: String
            let image: URL

            private enum CodingKeys: String, CodingKey {
                case login = "login"
                case type = "type"
                case image = "avatar_url"
            }
            
            var profileModel: UserModel {
                
                return UserModel(login: self.login, type: self.type, imageURL: self.image)
            }
        }
    }
    
}
