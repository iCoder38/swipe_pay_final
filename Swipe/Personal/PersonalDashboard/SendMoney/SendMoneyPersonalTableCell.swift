//
//  SendMoneyPersonalTableCell.swift
//  Swipe
//
//  Created by evs_SSD on 1/22/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit

class SendMoneyPersonalTableCell: UITableViewCell {
    

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var PersonNameLabel: UILabel!

    @IBOutlet weak var PersonMobileNOLabel: UILabel!

    @IBOutlet weak var PersonImage: UIImageView!

    @IBOutlet weak var PersonEmailLabel: UILabel!
    
    @IBOutlet weak var lblUserName:UILabel!
    @IBOutlet weak var lblUserPhoneNumber:UILabel!
    
    @IBOutlet weak var imgUserProfilePicture:UIImageView! {
        didSet {
            imgUserProfilePicture.layer.cornerRadius = 30
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
