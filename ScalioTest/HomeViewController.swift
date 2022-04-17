//
//  ViewController.swift
//  ScalioTest
//
//  Created by Helia Fathi on 4/13/22.
//

import UIKit

class HomeViewController: UIViewController {

    var horizontalStackView = UIStackView()
    var verticalStackView = UIStackView()
    
    let tableView = UITableView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "userCell")

        tableView.dataSource = self
        tableView.delegate = self
        configureSV()
        
        
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
        horizontalStackView.addArrangedSubview(logInText())
        horizontalStackView.addArrangedSubview(submitButton())
    }
    
    func addTableView() {
        verticalStackView.addArrangedSubview(horizontalStackView)
        verticalStackView.addArrangedSubview(tableView)
    }
    
   
    
    @objc func submitTapped() {
        print("submit tapped")
    }
    
    func logInText()-> UITextField {
        let login = UITextField()
        login.placeholder = "Search"
        login.textColor = .secondaryLabel
        login.backgroundColor = .purple
        return login
    }
    
    
    @objc func submitButton()-> UIButton {
        let submit = UIButton()
        submit.setTitle("Submit", for: .normal)
        submit.backgroundColor = .yellow
        submit.addTarget(self, action: #selector(HomeViewController.submitTapped), for: .touchUpInside)
        return submit
        
    }
    

}


extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! SearchTableViewCell
         return cell
    }
    
    
}
