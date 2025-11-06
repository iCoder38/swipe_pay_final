//
//  AllTransactionTableCell.swift
//  Swipe
//
//  Created by Apple  on 26/10/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit

class AllTransactionTableCell: UITableViewCell {

    @IBOutlet weak var imgProfilePicture:UIImageView! {
        didSet {
            imgProfilePicture.layer.cornerRadius = 30
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
