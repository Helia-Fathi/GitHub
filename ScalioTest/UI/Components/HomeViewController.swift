//
//  ViewController.swift
//  ScalioTest
//
//  Created by Helia Fathi on 4/13/22.
//

import UIKit
import RxSwift

//  TODO: set "user not found!" alert

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
        tableView.register(ResultTableViewCell.self, forCellReuseIdentifier: K.Strings.customCell)
        tableView.delegate = self
        let top = view.safeAreaInsets.top
        let bottom = view.safeAreaInsets.bottom

        self.tableView.rowHeight = CGFloat(Int((view.frame.size.height) - (top + bottom + 30) ) / 11)
        tableView.backgroundColor = .clear
        tableView.keyboardDismissMode = .onDrag

        configureSV()
        setupNavBar()
        bindViewModel()

    }

    private func setupNavBar() {
        navigationItem.title = viewModel.navTitle
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Dongle-Regular", size: 30)!]
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
            .bind(to: tableView.rx.items) { (tableView: UITableView, index: Int, cellVM: UserCellViewModel) in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: K.Strings.customCell, for: IndexPath(row: index, section: 0)) as? ResultTableViewCell else { return UITableViewCell()}
                cell.configure(viewModel: cellVM)
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                return cell
            }.disposed(by: disposeBag)
    }

    private func bindViewModel(){   
        viewModel.loaderSubject.bind(to: activityIndivator.rx.isAnimating)
            .disposed(by: disposeBag)

        viewModel.errorSubject.subscribe(onNext: {[weak self] error in
            guard let self = self else {return}
            let alertController = UIAlertController(title: K.Strings.Alert.gitConnectivityTitle, message: error, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: K.Strings.Alert.positiveMessage, style: .default))
            self.present(alertController, animated: true)
        }).disposed(by: disposeBag)
    }

    func configureSV() {
        view.addSubview(verticalStackView)

        addTextFieldandButton()
        addTableView()

        horizontalStackView.axis = .horizontal
        verticalStackView.axis = .vertical
        horizontalStackView.spacing = K.Dimentions.stackViewSpacing
        verticalStackView.spacing = K.Dimentions.stackViewSpacing

        setHorizontalSVConstraints()
        setVerticalSVConstraints()
    }

    func setHorizontalSVConstraints() {
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.topAnchor.constraint(equalTo: verticalStackView.topAnchor, constant: 0).isActive = true
        horizontalStackView.leadingAnchor.constraint(equalTo: verticalStackView.leadingAnchor, constant: 0).isActive = true
        horizontalStackView.trailingAnchor.constraint(equalTo: verticalStackView.trailingAnchor, constant: 0).isActive = true
    }

    func setVerticalSVConstraints() {
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        verticalStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: K.Dimentions.leftMargin).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -K.Dimentions.rightMargin).isActive = true
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

    @objc func submitTapped() {
        self.viewModel.searchString = logInText.text! + " in:login"
        logInText.resignFirstResponder()
        configureTableView()
    }

    lazy var logInText: UITextField = {
        let login = UITextField()
        login.placeholder = "Search without space"
        login.textColor = .black
        login.backgroundColor = .white
        login.autocorrectionType = .no
        login.font = UIFont(name: "Dongle-Regular", size: 30)
        login.layer.cornerRadius = K.Dimentions.textFieldCornerRadius
        login.setPadding(left: 15, right: 5)
        
        return login
    }()

    lazy var submitButton: UIButton = {
        let submit = UIButton()
        submit.setTitle("Submit", for: .normal)
        submit.titleLabel?.font = UIFont(name: "Dongle-Bold", size: 20)
        submit.backgroundColor = .white
        submit.setTitleColor(.black, for: .normal)
        submit.contentEdgeInsets = K.Dimentions.buttonEdge
        submit.layer.cornerRadius = K.Dimentions.buttonCornerRadius
        submit.addTarget(self, action: #selector(HomeViewController.submitTapped), for: .touchUpInside)
        
        return submit
    }()
}



extension HomeViewController: UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.isDragging else {return}
        if scrollView.contentOffset.y > 0 && (scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height + K.Dimentions.minPixcelToReq {

            if activityIndivator.isAnimating {
                return
            } else {
                viewModel.nextPage()
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ResultTableViewCell = tableView.dequeueReusableCell(withIdentifier: K.Strings.customCell, for: indexPath) as! ResultTableViewCell
        return cell
    }
}



extension UITextField {

    func setPadding(left: CGFloat? = nil, right: CGFloat? = nil, top: CGFloat? = nil, bottom: CGFloat? = nil){
        if let left = left {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
        }

        if let right = right {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: self.frame.size.height))
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }
}
