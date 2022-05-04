//
//  ConnectivityErr.swift
//  ScalioTest
//
//  Created by Helia Fathi on 4/17/22.
//


import Foundation
import RxSwift
import Moya

//  TODO: add connection check
//  TODO: set custom alerts for each response codes


extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    
    func GitLimmitError() -> Single<Element> {
        return flatMap { response in
            guard K.Dimentions.responseCode.statusCodeSuccess..<K.Dimentions.responseCode.statusCodeFailRangeResponse ~= response.statusCode else {
                throw Errors.limitedness
            }
            return .just(response)
        }
    }
}

