//
//  HomeViewModel.swift
//  ScalioTest
//
//  Created by Helia Fathi on 4/18/22.
//

import Foundation
import RxSwift
import RxCocoa

protocol VCViewModel {
    var navTitle: String {get}
    var loaderSubject: PublishSubject<Bool> {get}
    var errorSubject: PublishSubject<String> {get}
    var cellModelObservalble: Observable<[UserCellViewModel]> {get}
    var searchString: String {get set}
    func pullToRefresh()
    func nextPage()
}


class VCViewModelImpl: VCViewModel {
    let loaderSubject: PublishSubject<Bool>
    let errorSubject: PublishSubject<String>
    var cellModelObservalble: Observable<[UserCellViewModel]> {
    modelsBehaviourRelay.asObservable()
    }
    var searchString: String {
        didSet {
            reset()
            search()
        }
    }

    let navTitle: String

    private let pagingController: PagingController
    private var loadingRelay = BehaviorRelay<Bool>(value:false)
    private let dataStore: GitData
    private let disposeBag = DisposeBag()
    private let modelsBehaviourRelay: BehaviorRelay<[UserCellViewModel]>

    var isLoading: Bool {
        loadingRelay.value
    }

    init(
        dataStore: GitData,
        loaderSubject: PublishSubject<Bool> = PublishSubject<Bool>(),
        errorSubject: PublishSubject<String> = PublishSubject<String>(),
        modelsBehaviour: BehaviorRelay<[UserCellViewModel]> = BehaviorRelay<[UserCellViewModel]>(value: []),
        pagingController: PagingController =  PagingController(),
        navTitle: String = K.Strings.navTitle
    ){
        self.dataStore = dataStore
        self.loaderSubject = loaderSubject
        self.errorSubject = errorSubject
        self.modelsBehaviourRelay = modelsBehaviour
        self.searchString = K.Strings.empty
        self.pagingController = pagingController
        self.navTitle = navTitle

        loaderSubject.bind(to: loadingRelay).disposed(by: disposeBag)
    }



    func search() {
        if (isLoading || searchString.isEmpty) {
            return
        }

        loaderSubject.onNext(true)
        dataStore.fetchUsers(search: searchString, pageNumber: pagingController.pageNumber, pageSize: pagingController.pageSize)
            .observe(on: MainScheduler.instance)
            .subscribe {[weak self] profiles in
                guard let self = self else {return}
                self.loaderSubject.onNext(false)
                self.manageFetchedProfiles(profiles: profiles)
            } onFailure: {[weak self]  error in
                guard let self = self else {return}
                self.loaderSubject.onNext(false)
                guard let error = error as? Errors else {
                    self.errorSubject.onNext(error.localizedDescription)
                    return
                }
                self.errorSubject.onNext(error.message)
            }
            .disposed(by: disposeBag)
    }

    func manageFetchedProfiles(profiles: [UserModel]){
        if profiles.count < self.pagingController.pageSize {
            self.pagingController.isLastPage = true
        }
        modelsBehaviourRelay.accept(modelsBehaviourRelay.value + profiles.map{.init($0)})
    }

    func pullToRefresh() {
        reset()
        search()
    }

    func reset() {
        pagingController.reset()
        modelsBehaviourRelay.accept([])
    }

    func nextPage() {
        if pagingController.nextPage() != nil {
            search()
        }
    }
}
