//
//  SearchTableViewCell.swift
//  ScalioTest
//
//  Created by Helia Fathi on 4/17/22.
//

import UIKit
import SDWebImage

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarURL: UIImageView!
    @IBOutlet weak var login: UILabel!
    @IBOutlet weak var type: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(viewModel: CellVM) {
        login.text = viewModel.name
        type.text = viewModel.type
        avatarURL.sd_setImage(with: viewModel.avatar, placeholderImage: UIImage(named: ""),options: [
            .forceTransition
        ])
        
    }
    
}
