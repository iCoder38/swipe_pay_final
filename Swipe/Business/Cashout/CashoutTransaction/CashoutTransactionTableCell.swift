//
//  CashoutTransactionTableCell.swift
//  Swipe
//
//  Created by evs_SSD on 1/16/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit

class CashoutTransactionTableCell: UITableViewCell {

    @IBOutlet weak var lblSubTitle:UILabel!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblAmount:UILabel!
    @IBOutlet weak var lblMyFirstLetterIs:UILabel!
    
    @IBOutlet weak var img:UIImageView! {
        didSet {
            img.layer.cornerRadius = 30
            img.clipsToBounds = true
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
