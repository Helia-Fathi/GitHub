//
//  GitData.swift
//  ScalioTest
//
//  Created by Helia Fathi on 4/17/22.
//

import Foundation
import Moya
import RxSwift


protocol GitData {
    func fetchUsers(search: String, pageNumber: Int, pageSize: Int) -> Single<[UserModel]>
}


class GitDatas: GitData {
    let provider: MoyaProvider<GitHub>
    init(provider: MoyaProvider<GitHub>) {
        self.provider = provider
    }
    
    func fetchUsers(search: String, pageNumber: Int, pageSize: Int) -> Single<[UserModel]> {
        return provider.rx.request(.searchUsers(query: search, page: pageNumber, pageSize: pageSize))
            .connectivityError()
            .flatMap { response in
                return try GitProfileParser.map(response)
            }
    }
}
