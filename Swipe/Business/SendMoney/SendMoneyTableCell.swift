//
//  SendMoneyTableCell.swift
//  Swipe
//
//  Created by Apple on 27/10/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit

class SendMoneyTableCell: UITableViewCell {

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
    
    /*
    @IBOutlet weak var lblUserName:UILabel!
    @IBOutlet weak var lblUserPhoneNumber:UILabel!
    
    @IBOutlet weak var imgUserProfilePicture:UIImageView! {
        didSet {
            imgUserProfilePicture.layer.cornerRadius = 30
        }
    }
    
    @IBOutlet weak var imgLogoRight:UIImageView! 
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
