//
//  ReceiveListTableCell.swift
//  Swipe
//
//  Created by evs_SSD on 2/21/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit

class ReceiveListTableCell: UITableViewCell {

    @IBOutlet weak var imgProfilePicture:UIImageView! {
        didSet {
            imgProfilePicture.layer.cornerRadius = 30
            imgProfilePicture.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lblBankName:UILabel!
    @IBOutlet weak var lblAccountNumber:UILabel!
    @IBOutlet weak var lblAmount:UILabel!
    @IBOutlet weak var lblMyFirstLetterIs:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
