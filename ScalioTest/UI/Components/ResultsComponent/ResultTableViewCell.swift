//
//  SearchTableViewCell.swift
//  ScalioTest
//
//  Created by Helia Fathi on 4/17/22.
//

import UIKit
import SDWebImage

// FIXME: constraints for row elements

class ResultTableViewCell: UITableViewCell {
    
    let screenSize: CGRect = UIScreen.main.bounds

    let labelName: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont(name: "Dongle-Bold", size: 30)
        return label
    }()

    let labelType: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        label.font = UIFont(name: "Dongle-Regular", size: 25)
        return label
    }()

    let userImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = true
        image.layer.cornerRadius = K.Dimentions.imageCornerRadius
        image.layer.borderColor = UIColor.black.cgColor
        image.clipsToBounds = true
        return image
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(labelName)
        addSubview(labelType)
        addSubview(userImage)

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

        userImage.widthAnchor.constraint(equalToConstant: screenSize.height/K.Dimentions.pageSize - 20 ).isActive = true
        userImage.heightAnchor.constraint(equalToConstant: screenSize.height/K.Dimentions.pageSize ).isActive = true
        userImage.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        userImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        userImage.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError(K.Strings.fatalErr)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(viewModel: UserCellViewModel) {
        labelName.text = viewModel.name
        labelType.text = viewModel.type
        userImage.sd_setImage(with: viewModel.avatar, placeholderImage: UIImage(named: K.Strings.empty),options: [
            .forceTransition
        ])
    }
}
