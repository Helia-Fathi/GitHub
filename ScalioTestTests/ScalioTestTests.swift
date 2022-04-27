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

    
    
    
    //MARK: - View Model Test Cases
    
    func testExampleVM1() throws {
        let data = GitHubDataStore()
        let _ = makeSUT(dataStore: data)
        XCTAssertTrue(data.messages.count == 0)

    }
    
    func testExampleVM2() {
        let data = GitHubDataStore()
        var viewModel = makeSUT(dataStore: data)
        viewModel.searchString = "helia.fathi"
        XCTAssertTrue(data.messages.count == 1)
    }
    
    
    func testExampleVM3() {
        let data = GitHubDataStore()
        let searchString = "Search String"
        var viewModel = makeSUT(dataStore: data)
        viewModel.searchString = searchString

        XCTAssertEqual(data.messages[0].search, searchString)
    }
    
    
    func testExampleVM4() {
//pagination
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
    
    
    func testExampleVM5() {
        
//last req
        let data = GitHubDataStore()
        let paginationController = PagingController()
        
        // Called search first time
        let searchString = "Search String"
        var viewModel = makeSUT(dataStore: data, pagingController: paginationController)
        XCTAssertFalse(paginationController.isLastPage)
        viewModel.searchString = searchString
        XCTAssertTrue(data.messages.count == 1)
        
        //Calling Again
        XCTAssertTrue(paginationController.isLastPage)
        
        //Doesnot fetched search again
        XCTAssertTrue(data.messages.count == 1)
    }
    
    
    
    func testExampleVM6() {
//next page
        let data = GitHubDataStore()
        data.stubbed = [
        UserModel(login: "A name", type: "A type", imageURL: URL(string: "http://www.anyURL.com")!),
        UserModel(login: "A name", type: "A type", imageURL: URL(string: "http://www.anyURL.com")!)
        ]
        let paginationController = PagingController(pageNumber: 1, pageSize: 1)
        
        
        // Called search first time
        let searchString = "Search String"
        var viewModel = makeSUT(dataStore: data, pagingController: paginationController)
        XCTAssertEqual(paginationController.pageNumber, 1)
        viewModel.searchString = searchString
        XCTAssertTrue(data.messages.count == 1)
        XCTAssertFalse(paginationController.isLastPage)
        
        
        // Calling Next Page
        viewModel.nextPage()
        XCTAssertTrue(data.messages.count == 2)
        XCTAssertEqual(paginationController.pageNumber, 2)
        XCTAssertFalse(paginationController.isLastPage)
    
        // Calling third time should now paging controller be false
        viewModel.nextPage()
        
        //Doesnot fetched search again
        XCTAssertTrue(data.messages.count == 3)
        XCTAssertEqual(paginationController.pageNumber, 3)
        XCTAssertTrue(paginationController.isLastPage)
    }
    
    
    func testExampleVM7() {
//connection error
        let data = GitHubDataStore()
        data.stubbedError = Errors.connectivity
        
        let errorSubject = PublishSubject<String>()
        
        let expectation = expectation(description: "Wait for async code tofinish.")
        
        errorSubject.asObservable()
            .subscribe { message in
                XCTAssertEqual(message, Errors.connectivity.message)
                expectation.fulfill()
            } onError: { _ in}
            .disposed(by: disposeBag)

        // Called search first time
        let searchString = "Search String"
        var viewModel = makeSUT(dataStore: data, errorSubject: errorSubject)
        viewModel.searchString = searchString
        XCTAssertTrue(data.messages.count == 1)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    
    func testExampleVM8() {
//invalid data error
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

        // Called search first time
        let searchString = "Search String"
        var viewModel = makeSUT(dataStore: data, errorSubject: errorSubject)
        viewModel.searchString = searchString
        XCTAssertTrue(data.messages.count == 1)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    
    
    func testExampleVM9() {
//dismiss request when in loading
        let data = GitHubDataStore()
        let searchString = "Search String"
        var viewModel = makeSUT(dataStore: data)
        viewModel.loaderSubject.onNext(true)
        viewModel.searchString = searchString
        XCTAssertTrue(data.messages.count == 0)
        
        
    }
    
    func testExampleVM10() {
//empty string
        let data = GitHubDataStore()
        let emptySearchString = ""
        var viewModel = makeSUT(dataStore: data)
        viewModel.searchString = emptySearchString
        XCTAssertTrue(data.messages.count == 0)
    }
    
    func testExampleVM11() {
//new str reset pagination
        let data = GitHubDataStore()
        let searchString = "search string"

        let paginationController = PagingControllerSubClass()
        var viewModel = makeSUT(dataStore: data, pagingController: paginationController)
        viewModel.searchString = searchString
        XCTAssertTrue(paginationController.resetCallBackCount == 1)
        XCTAssertTrue(data.messages.count == 1)
    }
    
    
    
    func testExampleVM12() {
//when on pull send the second req
        let data = GitHubDataStore()
        let searchString = "search string"

        let paginationController = PagingControllerSubClass()
        var viewModel = makeSUT(dataStore: data, pagingController: paginationController)
        viewModel.searchString = searchString
        
        XCTAssertTrue(data.messages.count == 1)
        XCTAssertTrue(paginationController.isLastPage)
        
        viewModel.pullToRefresh()
        
        //Search Called Second time
        XCTAssertTrue(paginationController.resetCallBackCount == 2)
        XCTAssertTrue(data.messages.count == 2)
        XCTAssertTrue(paginationController.isLastPage)
    }
    
    
    
    
    //MARK: - Network Test Cases
    
    
    func testExampleN1() {
        var expectations = [XCTestExpectation]()
        [199, 300, 400, 500].enumerated().forEach { index, code in
            let sut = makeSUT(for: code, data: anyData())
            let expectation = expectation(description: "Wait for async Code")
            sut.fetchUsers(search: "23", pageNumber: 1, pageSize: 12)
                .subscribe { _ in
                    XCTFail("Expected to fail with connectivity error")
                } onFailure: { error in
                    guard let error = error as? Errors else {
                        XCTFail("Expected to fail with API Error connectivity error")
                        return
                    }
                    XCTAssertEqual(Errors.connectivity, error)
                    expectation.fulfill()
                }
                .disposed(by: disposeBag)
            expectations.append(expectation)
            
        }
        wait(for: expectations, timeout: 1)
    }
    
    
    
    
    func testExampleN2() {
//invalid data error on invalid data res
        let invalidData = Data("Any invalid Data".utf8)
        let sut = makeSUT(for: 200, data: invalidData)
        let expectation = expectation(description: "Wait for async Code")
        sut.fetchUsers(search: "23", pageNumber: 1, pageSize: 12)
            .subscribe { _ in
                XCTFail("Expected to fail with connectivity error")
            } onFailure: { error in
                guard let error = error as? Errors else {
                    XCTFail("Expected to fail with API Error invalidData error")
                    return
                }
                XCTAssertEqual(Errors.invalidData, error)
                expectation.fulfill()
            }
            .disposed(by: disposeBag)
        wait(for: [expectation], timeout: 1)
    }
    
    
    
    
    
    func testExampleN3() {
//        empty res = empty model
        let sut = makeSUT(for: 200, data: makeProfileModelsData(from: []))
        let expectation = expectation(description: "Wait for async Code")
        sut.fetchUsers(search: "23", pageNumber: 1, pageSize: 12)
            .subscribe { profiles in
               XCTAssertEqual(profiles, [], "Expected to Complete with Empty empty profiles response")
                expectation.fulfill()
            } onFailure: { error in
                XCTFail("Expected to succeed with empty Profiles Response")
            }
            .disposed(by: disposeBag)
        wait(for: [expectation], timeout: 1)
    }
    
    
    
    
    func testExampleN4() {
//        valid res = valid model
        let item1 = makeProfileModel(name: "Profile1", type: "User", imageURL: URL(string: "http://www.anyurl.com")!)
        let item2 = makeProfileModel(name: "Profile2", type: "Admin", imageURL: URL(string: "http://www.another-url.com")!)
        let sut = makeSUT(for: 200, data: makeProfileModelsData(from: [item1.json, item2.json]))
        
        
        let expectation = expectation(description: "Wait for async Code")
        sut.fetchUsers(search: "23", pageNumber: 1, pageSize: 12)
            .subscribe { profiles in
                XCTAssertEqual(profiles, [item1.model, item2.model], "Expected to Complete with \([item1.model, item2.model])")
                expectation.fulfill()
            } onFailure: { error in
                XCTFail("Expected to succeed with Profiles in Response")
            }
            .disposed(by: disposeBag)
        wait(for: [expectation], timeout: 1)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    


    
    
   
    
    //MARK: - For view models
    
    private func makeSUT(dataStore: GitData,
                         loaderSubject: PublishSubject<Bool> = PublishSubject<Bool>(),
                         errorSubject: PublishSubject<String> = PublishSubject<String>(),
                         modelsBehaviour: BehaviorRelay<[CellVM]> = BehaviorRelay<[CellVM]>(value: []),
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
                }
                else {
                    let observable: Observable<[UserModel]> = Observable.just(stubbed)
                    self.stubbed = nil
                    return observable.asSingle()
                }
                
            }
            else{
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
    
    
    
    
    
    
    
    
    //MARK: - For Networking
    
    private func makeSUT(for code: Int, data: Data) -> GitData {
        let endPointStatusClosure = endPointClosureWithCode(statusCode: code, data: data)
        let provider = MoyaProvider<GitHub>(endpointClosure: endPointStatusClosure, stubClosure: MoyaProvider.immediatelyStub)
        
        let store = GitDatas(provider: provider)
        return store
    }
    
    private func endPointClosureWithCode(statusCode: Int, data: Data) -> (GitHub) -> Endpoint {
        return { (target: GitHub) -> Endpoint in
            return Endpoint(url: URL(target: target).absoluteString,
                            sampleResponseClosure: { .networkResponse(statusCode, data) },
                            method: target.method,
                            task: target.task,
                            httpHeaderFields: target.headers)
        }
    }
    
    private func anyData() -> Data {
        return Data()
    }
    
    private func makeProfileModel(name: String, type: String, imageURL: URL) -> (model: UserModel, json: [String: Any]) {
        let model = UserModel(login: name, type: type, imageURL: imageURL)
        let json: [String: Any] = [
            "login": name,
            "avatar_url": imageURL.absoluteString,
            "type": type
        ]
        return (model, json)
    }
    
    private func makeProfileModelsData(from profiles: [[String: Any]]) -> Data {
        let items = ["items": profiles]
        return try! JSONSerialization.data(withJSONObject: items)
    }
    

    

}
