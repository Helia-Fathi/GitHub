//
//  NetworkTests.swift
//  ScalioTestTests
//
//  Created by Helia Fathi on 5/4/22.
//

import XCTest
import Moya
import RxSwift

@testable import ScalioTest
class NetworkTests: XCTestCase {
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        disposeBag = nil
        super.tearDown()
    }

    func test_OnFetch_returnsConnectivtyErrorOnNon200HTTPResponses() {
        var expectations = [XCTestExpectation]()
        [199, 300, 400, 500].enumerated().forEach { index, code in
            let sut = makeSUT(for: code, data: anyData())
            let expectation = expectation(description: "Wait for async Code")
            sut.fetchUsers(search: "String", pageNumber: 1, pageSize: 9)
                .subscribe { _ in
                    XCTFail("Expected to fail with connectivity error")
                } onFailure: { error in
                    guard let error = error as? Errors else {
                        XCTFail("Expected to fail with API Error connectivity error")
                        return
                    }
                    XCTAssertEqual(Errors.limitedness, error)
                    expectation.fulfill()
                }
                .disposed(by: disposeBag)
            expectations.append(expectation)
        }
        wait(for: expectations, timeout: 1)
    }

    func test_OnFetch_returnsProfileModelArrayOnValidPResponses() {

        let item1 = makeProfileModel(name: "Profile1", type: "User", imageURL: URL(string: "http://www.anyurl.com")!)
        let item2 = makeProfileModel(name: "Profile2", type: "Admin", imageURL: URL(string: "http://www.another-url.com")!)
        let sut = makeSUT(for: 200, data: makeProfileModelsData(from: [item1.json, item2.json]))


        let expectation = expectation(description: "Wait for async Code")
        sut.fetchUsers(search: "String", pageNumber: 1, pageSize: 9)
            .subscribe { profiles in
                XCTAssertEqual(profiles, [item1.model, item2.model], "Expected to Complete with \([item1.model, item2.model])")
                expectation.fulfill()
            } onFailure: { error in
                XCTFail("Expected to succeed with Profiles in Response")
            }
            .disposed(by: disposeBag)
        wait(for: [expectation], timeout: 1)
    }


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
