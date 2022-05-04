//
//  ScalioTestTests.swift
//  ScalioTestTests
//
//  Created by Helia Fathi on 4/13/22.
//

import XCTest
import RxCocoa
import RxSwift
import Moya

@testable import ScalioTest

class ScalioTestTests: XCTestCase {
    var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        try super.setUpWithError()
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        disposeBag = nil
        try super.tearDownWithError()
    }



    func test_viewModel_changingSearchTriggersSearchRequest() {
        let data = GitHubDataStore()
        var viewModel = makeSUT(dataStore: data)
        viewModel.searchString = "heliafathi"
        XCTAssertTrue(data.messages.count == 1)
    }


    func test_viewModel_changingSearchTriggerRequestWithCorrectQuery() {
        let data = GitHubDataStore()
        let searchString = "Search String"
        var viewModel = makeSUT(dataStore: data)
        viewModel.searchString = searchString
        XCTAssertEqual(data.messages[0].search, searchString)
    }


    func test_viewModel_changingSearchRequestsWithCorrectPagination() {
        let data = GitHubDataStore()

        let pageNumber: Int = 1
        let pageSize: Int = 9
        let isLastPage: Bool = false
        let pagination = PagingController(pageNumber: pageNumber, pageSize: pageSize, isLastPage: isLastPage)

        let searchString = "Search String"
        var viewModel = makeSUT(dataStore: data, pagingController: pagination)
        viewModel.searchString = searchString

        XCTAssertFalse(data.messages.isEmpty)
        XCTAssertEqual(data.messages[0].search, searchString)
        XCTAssertEqual(data.messages[0].pageNumber, pageNumber)
        XCTAssertEqual(data.messages[0].pageSize, pageSize)

    }


    func test_viewModel_OnLastPageDoestNotRequestSearch() {
       
        //  Calling search first time
        let data = GitHubDataStore()
        let paginationController = PagingController()
        let searchString = "String"
        var viewModel = makeSUT(dataStore: data, pagingController: paginationController)
        XCTAssertFalse(paginationController.isLastPage)
        viewModel.searchString = searchString
        XCTAssertTrue(data.messages.count == 1)

        //  Calling Again
        XCTAssertTrue(paginationController.isLastPage)

        //  Doesnot fetched search again
        XCTAssertTrue(data.messages.count == 1)
    }



    func test_viewModel_NextPageOnSearch() {
        //  next page
        let data = GitHubDataStore()
        data.stubbed = [
            UserModel(login: "A name", type: "A type", imageURL: URL(string: "http://www.anyURL.com")!),
            UserModel(login: "A name", type: "A type", imageURL: URL(string: "http://www.anyURL.com")!)
        ]
        let paginationController = PagingController(pageNumber: 1, pageSize: 1)


        //  Calling search for the first time
        let searchString = "String"
        var viewModel = makeSUT(dataStore: data, pagingController: paginationController)
        XCTAssertEqual(paginationController.pageNumber, 1)
        viewModel.searchString = searchString
        XCTAssertTrue(data.messages.count == 1)
        XCTAssertFalse(paginationController.isLastPage)


        //  Calling the Next Page
        viewModel.nextPage()
        XCTAssertTrue(data.messages.count == 2)
        XCTAssertEqual(paginationController.pageNumber, 2)
        XCTAssertFalse(paginationController.isLastPage)

        //  Calling for the third time should change the paging controller false
        viewModel.nextPage()

        //  Doesn't fetch search again
        XCTAssertTrue(data.messages.count == 3)
        XCTAssertEqual(paginationController.pageNumber, 3)
        XCTAssertTrue(paginationController.isLastPage)
    }


    func test_viewModel_OnConnectivityErrorThrowsConnectivityErrorMessage() {
        
        //  Connection error
        let data = GitHubDataStore()
        data.stubbedError = Errors.limitedness

        let errorSubject = PublishSubject<String>()

        let expectation = expectation(description: "Wait for async code tofinish.")

        errorSubject.asObservable()
            .subscribe { message in
                XCTAssertEqual(message, Errors.limitedness.message)
                expectation.fulfill()
            } onError: { _ in}
            .disposed(by: disposeBag)

        // Calling search for the first time
        let searchString = "String"
        var viewModel = makeSUT(dataStore: data, errorSubject: errorSubject)
        viewModel.searchString = searchString
        XCTAssertTrue(data.messages.count == 1)

        wait(for: [expectation], timeout: 1.0)
    }


    func test_viewModel_OnInValidDataErrorThrowsInvalidDataErrorMessage() {
        
        //  Invalid data error
        let data = GitHubDataStore()
        data.stubbedError = Errors.invalidData

        let errorSubject = PublishSubject<String>()

        let expectation = expectation(description: "Wait for async code tofinish.")

        errorSubject.asObservable()
            .subscribe { message in
                XCTAssertEqual(message, Errors.invalidData.message)
                expectation.fulfill()
            } onError: { _ in}
            .disposed(by: disposeBag)

        // Calling search for the first time
        let searchString = "Search String"
        var viewModel = makeSUT(dataStore: data, errorSubject: errorSubject)
        viewModel.searchString = searchString
        XCTAssertTrue(data.messages.count == 1)

        wait(for: [expectation], timeout: 1.0)
    }



    func test_viewModel_OnLoadingDoesNotCallSearch() {
        
        //  Dismiss request when in loading
        let data = GitHubDataStore()
        let searchString = "Search String"
        var viewModel = makeSUT(dataStore: data)
        viewModel.loaderSubject.onNext(true)
        viewModel.searchString = searchString
        XCTAssertTrue(data.messages.count == 0)
    }

    func test_viewModel_SearchNewStringResetsPagination() {
        //  New stirng reset pagination
        let data = GitHubDataStore()
        let searchString = "string"

        let paginationController = PagingControllerSubClass()
        var viewModel = makeSUT(dataStore: data, pagingController: paginationController)
        viewModel.searchString = searchString
        XCTAssertTrue(paginationController.resetCallBackCount == 1)
        XCTAssertTrue(data.messages.count == 1)
    }



    func test_viewModel_OnPullToRefeshResetsSearch() {
        //  When on pull send the second req
        let data = GitHubDataStore()
        let searchString = "String"

        let paginationController = PagingControllerSubClass()
        var viewModel = makeSUT(dataStore: data, pagingController: paginationController)
        viewModel.searchString = searchString

        XCTAssertTrue(data.messages.count == 1)
        XCTAssertTrue(paginationController.isLastPage)

        viewModel.pullToRefresh()

        // Calling search for the second time
        XCTAssertTrue(paginationController.resetCallBackCount == 2)
        XCTAssertTrue(data.messages.count == 2)
        XCTAssertTrue(paginationController.isLastPage)
    }


    private func makeSUT(dataStore: GitData,
                         loaderSubject: PublishSubject<Bool> = PublishSubject<Bool>(),
                         errorSubject: PublishSubject<String> = PublishSubject<String>(),
                         modelsBehaviour: BehaviorRelay<[UserCellViewModel]> = BehaviorRelay<[UserCellViewModel]>(value: []),
                         pagingController: PagingController =  PagingController()) -> VCViewModel {
        return VCViewModelImpl(dataStore: dataStore, loaderSubject: loaderSubject, errorSubject: errorSubject, modelsBehaviour: modelsBehaviour, pagingController: pagingController)
    }

    private class GitHubDataStore: GitData {
        var messages: [(search: String, pageNumber: Int, pageSize: Int)] = []

        var stubbed: [UserModel]?
        var stubbedError: Errors?

        func fetchUsers(search: String, pageNumber: Int, pageSize: Int) -> Single<[UserModel]> {
            messages.append((search, pageNumber, pageSize))

            if let stubbedError = stubbedError {
                return Single.create { single in
                    single(.failure(stubbedError))
                    return Disposables.create()
                }
            }


            if let stubbed = stubbed{
                if stubbed.count >= pageSize {
                    let first = Array(stubbed.prefix(pageSize))
                    self.stubbed = stubbed.dropLast(pageSize)
                    return Observable.just(first).asSingle()
                } else {
                    let observable: Observable<[UserModel]> = Observable.just(stubbed)
                    self.stubbed = nil
                    return observable.asSingle()
                }

            } else{
                return Observable.just([]).asSingle()
            }
        }
    }

    private class PagingControllerSubClass: PagingController {
        var resetCallBackCount: Int = 0

        override func reset() {
            super.reset()
            resetCallBackCount += 1
        }
    }
}
