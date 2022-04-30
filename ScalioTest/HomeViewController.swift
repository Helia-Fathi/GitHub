//
//  ViewController.swift
//  ScalioTest
//
//  Created by Helia Fathi on 4/13/22.
//

import UIKit
import RxSwift


class HomeViewController: UIViewController {
    
    var horizontalStackView = UIStackView()
    var verticalStackView = UIStackView()

    let tableView = UITableView()

    var viewModel: VCViewModel!
    let disposeBag = DisposeBag()

    let screenSize: CGRect = UIScreen.main.bounds

    var activityIndivator: UIActivityIndicatorView!
    var refreshControl: UIRefreshControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.secondarySystemBackground
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "userCell")
//        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.rowHeight = CGFloat(Int(view.frame.size.height / 9))
        tableView.keyboardDismissMode = .onDrag

        configureSV()
        setupNavBar()
//        setupSearchBar()
        bindViewModel()

        self.navigationItem.title = "Search in Git Users Names"
        
    }

    private func setupNavBar() {
        navigationItem.title = viewModel.navTitle
        activityIndivator = UIActivityIndicatorView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndivator)
    }
    
    private func configureTableView() {
        tableView.refreshControl = UIRefreshControl()
        tableView.delegate = self
        bindTableView()
    }
    
    private func bindTableView() {
        tableView.dataSource = nil
        tableView.refreshControl?.rx.controlEvent(.valueChanged).subscribe(onNext: {[weak self] _ in
            if self?.tableView.refreshControl?.isRefreshing ?? false {
                self?.viewModel.pullToRefresh()
                self?.tableView.refreshControl?.endRefreshing()
            }
        }).disposed(by: disposeBag)
        
        viewModel.cellModelObservalble
            .bind(to: tableView.rx.items) { (tableView: UITableView, index: Int, cellVM: CellVM) in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: IndexPath(row: index, section: 0)) as? SearchTableViewCell else { return UITableViewCell()}
                cell.configure(viewModel: cellVM)
                return cell
            }.disposed(by: disposeBag)
    }
  
    
    
    private func setupSearchBar() {
        
        
        
//        print("this is when you change the string")
//        submitButton.rx.tap.bind { [weak self] in
//
//            guard let self = self else {return}
//            self.viewModel.searchString = searchString +" in:login"
//            print("this is when you change the strings")
            
            
//                .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
//                .subscribe(onNext: {[weak self] searchString in
//                    guard let self = self else {return}
//                    self.viewModel.searchString = searchString +" in:login"
//                    print("this is when you change the strings")
                
//        .disposed(by: disposeBag)
        
//        logInText.rx.text.orEmpty
//            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
//            .subscribe(onNext: {[weak self] searchString in
//                guard let self = self else {return}
//                self.viewModel.searchString = searchString+" in:login"
//                print("this is when you change the string")
//            })
//            .disposed(by: disposeBag)
    }
    
    
    
    private func bindViewModel(){
//        viewModel.loaderSubject.bind(to: activityIndivator.rx.isAnimating)
//            .disposed(by: disposeBag)
        
        
        viewModel.errorSubject.subscribe(onNext: {[weak self] error in
            guard let self = self else {return}
            
            let alertController = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: .default))
            self.present(alertController, animated: true)
        }).disposed(by: disposeBag)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func configureSV() {
        view.addSubview(verticalStackView)

        addTextFieldandButton()
        addTableView()
        
        horizontalStackView.axis = .horizontal
        verticalStackView.axis = .vertical
        horizontalStackView.spacing = 10
        verticalStackView.spacing = 10

        setHorizontalSVConstraints()
        setVerticalSVConstraints()
    }
    
    func setHorizontalSVConstraints() {
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.topAnchor.constraint(equalTo: verticalStackView.topAnchor, constant: 0).isActive = true
        horizontalStackView.leadingAnchor.constraint(equalTo: verticalStackView.leadingAnchor, constant: 0).isActive = true
        horizontalStackView.trailingAnchor.constraint(equalTo: verticalStackView.trailingAnchor, constant: 0).isActive = true
        
//        horizontalStackView.heightAnchor.constraint(equalToConstant: screenSize.height/5)
    }
    
    func setVerticalSVConstraints() {
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        verticalStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    }

    func addTextFieldandButton() {
        horizontalStackView.addArrangedSubview(logInText)
        horizontalStackView.addArrangedSubview(submitButton)
    }
    
    func addTableView() {
        verticalStackView.addArrangedSubview(horizontalStackView)
        verticalStackView.addArrangedSubview(tableView)
    }
    
   
  //MARK: - this is the button
    @objc func submitTapped() {
//        setupSearchBar()
//        logInText.rx.text.orEmpty
//            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
//                    .subscribe(onNext: {[weak self] searchString in
//                        guard let self = self else {return}
//
//                        self.viewModel.searchString = searchString+" in:login"
//                        print("this is when you change the string")
//
//                    }).disposed(by: disposeBag)
        
        
        
        self.viewModel.searchString = logInText.text! + " in:login"

        logInText.resignFirstResponder()
        configureTableView()
//        setupNavBar()
    }
    
    lazy var logInText: UITextField = {
        let login = UITextField()
        login.placeholder = "  Search"
        login.textColor = .black
        login.backgroundColor = .white
        login.autocorrectionType = .no

//        login.layer.borderColor = UIColor.black.cgColor
//        login.layer.borderWidth = 1
        login.layer.cornerRadius = 10
        return login
    }()
    
    
    lazy var submitButton: UIButton = {
        let submit = UIButton()
        submit.setTitle("Submit", for: .normal)
        submit.backgroundColor = .white
        submit.setTitleColor(.black, for: .normal)
        submit.contentEdgeInsets = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)

//        submit.layer.borderWidth = 1
//        submit.layer.borderColor = UIColor.black.cgColor
        submit.layer.cornerRadius = 10

        
        submit.addTarget(self, action: #selector(HomeViewController.submitTapped), for: .touchUpInside)
        return submit
    }()
}


extension HomeViewController: UITableViewDelegate {
    
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            guard scrollView.isDragging else {return}
            if scrollView.contentOffset.y > 0 && (scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height {
                
  
                viewModel.nextPage()
            }
        }
    
//        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            return 9
//        }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell: SearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! SearchTableViewCell
             return cell
        }
   
    
}

