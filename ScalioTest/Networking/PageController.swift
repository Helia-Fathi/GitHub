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
    
    init(pageNumber: Int = 1, pageSize: Int = 9, isLastPage: Bool = false) {
        self.pageSize = pageSize
        self.pageNumber = pageNumber
        self.isLastPage = isLastPage
    }
    
    func reset() {
        pageNumber = 1
        isLastPage = false
    }
    
    func nextPage() -> Int? {
        if isLastPage {return nil}
        pageNumber += 1
        return pageNumber
    }
}
