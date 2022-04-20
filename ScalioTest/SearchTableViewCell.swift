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
    
    
    let labelName: UILabel = {
     let n = UILabel()
         n.textColor = UIColor.darkGray
        n.textAlignment = .center
         n.text = "Testing 123"
         n.font = UIFont(name: "Montserrat", size: 30)
     return n
    }()
    
    let labelType: UILabel = {
     let n = UILabel()
         n.textColor = UIColor.darkGray
         n.textAlignment = .center
         n.text = "Testing 123"
         n.font = UIFont(name: "Montserrat", size: 30)
     return n
    }()
    
    
    let userImage: UIImageView = {
           let n = UIImageView()
//           n.image = UIImage(named: "yourImage.png")
           n.translatesAutoresizingMaskIntoConstraints = false //You need to call this property so the image is added to your view
           return n
        }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
       super.init(style: style, reuseIdentifier: reuseIdentifier)

       addSubview(labelName)
        addSubview(labelType)
        addSubview(userImage)

        labelName.translatesAutoresizingMaskIntoConstraints = false
        labelName.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        labelName.rightAnchor.constraint(equalTo: labelType.leftAnchor).isActive = true
        labelName.topAnchor.constraint(equalTo: topAnchor).isActive = true
        labelName.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        
        labelType.translatesAutoresizingMaskIntoConstraints = false
        labelType.leftAnchor.constraint(equalTo: labelName.rightAnchor).isActive = true
        labelType.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        labelType.topAnchor.constraint(equalTo: topAnchor).isActive = true
        labelType.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        
        userImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        userImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        userImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        userImage.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 8).isActive = true
           
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
