//
//  OrderedCardListTableCell.swift
//  Swipe
//
//  Created by evs_SSD on 1/17/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit

class OrderedCardListTableCell: UITableViewCell {

    @IBOutlet weak var imgCard:UIImageView! {
        didSet {
            imgCard.layer.cornerRadius = 30
            imgCard.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lblBankName:UILabel!
    @IBOutlet weak var lblAccountNumber:UILabel!
    @IBOutlet weak var lblProcessing:UILabel!
    @IBOutlet weak var lblCreated:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
