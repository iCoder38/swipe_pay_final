//
//  SendMoneyScreenTableCell.swift
//  Swipe
//
//  Created by Apple on 27/10/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit

class SendMoneyScreenTableCell: UITableViewCell {

    @IBOutlet weak var viewLeft:UIView! {
        didSet {
            viewLeft.layer.cornerRadius = 4
            viewLeft.clipsToBounds = true
            viewLeft.backgroundColor = UIColor.init(red: 234.0/255.0, green: 234.0/255.0, blue: 234.0/255.0, alpha: 1)
        }
    }
    
    @IBOutlet weak var viewRight:UIView! {
        didSet {
            viewRight.layer.cornerRadius = 4
            viewRight.clipsToBounds = true
            viewRight.layer.borderColor = UIColor.init(red: 234.0/255.0, green: 234.0/255.0, blue: 234.0/255.0, alpha: 1).cgColor
            viewRight.layer.borderWidth = 0.40
            viewRight.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var lblAmountLeft:UILabel!
    @IBOutlet weak var lblAmountRight:UILabel!
    
    @IBOutlet weak var lblReceivedLeft:UILabel!
    @IBOutlet weak var lblReceivedRight:UILabel!
    
    @IBOutlet weak var lblDateLeft:UILabel!
    @IBOutlet weak var lblDateRight:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
