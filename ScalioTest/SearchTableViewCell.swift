//
//  SearchTableViewCell.swift
//  ScalioTest
//
//  Created by Helia Fathi on 4/17/22.
//

import UIKit
import SDWebImage

class SearchTableViewCell: UITableViewCell {
    
//    @IBOutlet weak var avatarURL: UIImageView!
//    @IBOutlet weak var login: UILabel!
//    @IBOutlet weak var type: UILabel!
    
    
    let screenSize: CGRect = UIScreen.main.bounds

    let shit = UIScreen.main.bounds.height
//    let stackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.spacing = 10
//        stackView.distribution = .fillEqually
//        return stackView
//    }()
    
    
    
    let labelName: UILabel = {
     let n = UILabel()
         n.textColor = UIColor.black
         n.textAlignment = .center
         n.text = "Testing 123"
         n.font = UIFont(name: "Dongle-Bold", size: 30)
     return n
    }()
    
    let labelType: UILabel = {
     let n = UILabel()
         n.textColor = UIColor.darkGray
         n.textAlignment = .center
//        n.backgroundColor = .systemPink
         n.text = "Testing 123"
         n.font = UIFont(name: "Dongle-Regular", size: 25)
     return n
    }()
    
//    var corner:Int {
//        CGFloat(((Int(UIScreen.main.bounds.height) / 9) - 10) / 2)
//
//        let screen = UIScreen.main.bounds.height
//        var test = screen / 9
//        test = test - 10
//        return test/2
//    }

    
    let userImage: UIImageView = {
           let n = UIImageView()

           n.translatesAutoresizingMaskIntoConstraints = false
           n.layer.masksToBounds = true
//        n.layer.cornerRadius = CGFloat((Int(UIScreen.main.bounds.height)/9 - 20 )/2)
//        n.layer.cornerRadius = CGFloat((((Int(UIScreen.main.bounds.height)) - 85) / 9) / 2)
           n.layer.cornerRadius = 5
        
//        n.draw(CGRect(x: 0, y: 0, width: 55, height: 55))
//                n.layer.masksToBounds = true
        n.layer.borderColor = UIColor.black.cgColor
        n.clipsToBounds = true
           return n
        }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
       super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        addSubview(stackView)
        addSubview(labelName)
        addSubview(labelType)
        addSubview(userImage)

//        stackView.addArrangedSubview(userImage)
//        stackView.addArrangedSubview(labelName)
//        stackView.addArrangedSubview(labelType)

//
//        stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
//        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
//        stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
//        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
            

        labelName.translatesAutoresizingMaskIntoConstraints = false
        labelName.leftAnchor.constraint(equalTo: userImage.rightAnchor).isActive = true
        labelName.rightAnchor.constraint(equalTo: labelType.leftAnchor).isActive = true
        labelName.topAnchor.constraint(equalTo: topAnchor).isActive = true
        labelName.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true


        labelType.translatesAutoresizingMaskIntoConstraints = false
        labelType.leftAnchor.constraint(equalTo: labelName.rightAnchor).isActive = true
        labelType.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        labelType.topAnchor.constraint(equalTo: topAnchor).isActive = true
        labelType.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        labelType.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 10).isActive = true
        labelType.widthAnchor.constraint(equalToConstant: screenSize.width/4).isActive = true


        userImage.widthAnchor.constraint(equalToConstant: screenSize.height/9 - 20 ).isActive = true
        userImage.heightAnchor.constraint(equalToConstant: screenSize.height/9 ).isActive = true
        userImage.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        userImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
//        userImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true

        userImage.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true

   }

   required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")

   }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(viewModel: CellVM) {

        labelName.text = viewModel.name
        labelType.text = viewModel.type
        userImage.sd_setImage(with: viewModel.avatar, placeholderImage: UIImage(named: ""),options: [
            .forceTransition
       ])
        
    }
    
}
