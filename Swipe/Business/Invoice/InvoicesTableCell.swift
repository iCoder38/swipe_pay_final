//
//  InvoicesTableCell.swift
//  Swipe
//
//  Created by Apple on 04/11/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit

class InvoicesTableCell: UITableViewCell {

    @IBOutlet weak var imgProfilePicture:UIImageView! {
        didSet {
            imgProfilePicture.layer.cornerRadius = 30
            imgProfilePicture.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lblUserName:UILabel!
    @IBOutlet weak var lblDate:UILabel!
    @IBOutlet weak var lblPrice:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
