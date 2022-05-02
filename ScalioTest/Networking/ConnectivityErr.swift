//
//  ConnectivityErr.swift
//  ScalioTest
//
//  Created by Helia Fathi on 4/17/22.
//


import Foundation
import RxSwift
import Moya

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    func connectivityError() -> Single<Element> {
        return flatMap { response in
            guard 200..<300 ~= response.statusCode else {
                throw Errors.limitedness
            }
            return .just(response)
        }
    }
}
