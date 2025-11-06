//
//  ManageCardsTableCell.swift
//  Swipe
//
//  Created by evs_SSD on 1/10/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit

class ManageCardsTableCell: UITableViewCell {

    @IBOutlet weak var img:UIImageView! {
        didSet {
            img.layer.cornerRadius = 30
            img.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblCard:UILabel!
    
    @IBOutlet weak var btnDelete:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
