//
//  RequestMoneyUserTableCell.swift
//  Swipe
//
//  Created by Apple on 17/03/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit

class RequestMoneyUserTableCell: UITableViewCell {

    @IBOutlet weak var statusLabel: UILabel!

    @IBOutlet weak var PersonNameLabel: UILabel!

    @IBOutlet weak var PersonMobileNOLabel: UILabel!

    @IBOutlet weak var PersonImage: UIImageView! {
        didSet {
            PersonImage.layer.cornerRadius = 30
            PersonImage.clipsToBounds = true
        }
    }

    @IBOutlet weak var imgs: UIImageView!
    
    @IBOutlet weak var PersonEmailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
