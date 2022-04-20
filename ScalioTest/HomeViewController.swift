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

    
    var activityIndivator: UIActivityIndicatorView!
    var refreshControl: UIRefreshControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "userCell")

//        tableView.dataSource = self
        tableView.delegate = self
        configureSV()
        
//        setupSearchBar()
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
        logInText.rx.text.orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: {[weak self] searchString in
                guard let self = self else {return}
                self.viewModel.searchString = searchString+" in:login"
            })
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel(){
        viewModel.loaderSubject.bind(to: activityIndivator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        
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
        verticalStackView.spacing = 20

        setHorizontalSVConstraints()
        setVerticalSVConstraints()
    }
    
    func setHorizontalSVConstraints() {
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.topAnchor.constraint(equalTo: verticalStackView.topAnchor, constant: 0).isActive = true
        horizontalStackView.leadingAnchor.constraint(equalTo: verticalStackView.leadingAnchor, constant: 0).isActive = true
        horizontalStackView.trailingAnchor.constraint(equalTo: verticalStackView.trailingAnchor, constant: 0).isActive = true
        horizontalStackView.heightAnchor.constraint(equalToConstant: 70)
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
        horizontalStackView.addArrangedSubview(submitButton())
    }
    
    func addTableView() {
        verticalStackView.addArrangedSubview(horizontalStackView)
        verticalStackView.addArrangedSubview(tableView)
    }
    
   
    
    @objc func submitTapped() {
        setupSearchBar()
        configureTableView()
        setupNavBar()
    }
    
    lazy var logInText: UITextField = {
        let login = UITextField()
        login.placeholder = "Search"
        login.textColor = .secondaryLabel
        login.backgroundColor = .purple
        return login
    }()
    
    
    @objc func submitButton()-> UIButton {
        let submit = UIButton()
        submit.setTitle("Submit", for: .normal)
        submit.backgroundColor = .yellow
        submit.addTarget(self, action: #selector(HomeViewController.submitTapped), for: .touchUpInside)
        return submit
    }
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
