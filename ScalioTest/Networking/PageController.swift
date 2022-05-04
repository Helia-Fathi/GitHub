//
//  PageController.swift
//  ScalioTest
//
//  Created by Helia Fathi on 4/17/22.
//

import Foundation

class PagingController {
    
    let pageSize: Int
    var pageNumber: Int
    var isLastPage: Bool

    init(pageNumber: Int = K.Dimentions.pageNumber, pageSize: Int = Int(K.Dimentions.pageSize), isLastPage: Bool = K.lastPageDefault) {
        self.pageSize = pageSize
        self.pageNumber = pageNumber
        self.isLastPage = isLastPage
    }

    func reset() {
        pageNumber = K.Dimentions.pageNumber
        isLastPage = K.lastPageDefault
    }

    func nextPage() -> Int? {
        if isLastPage {return nil}
        pageNumber += K.Dimentions.pageNumber
        return pageNumber
    }
}
