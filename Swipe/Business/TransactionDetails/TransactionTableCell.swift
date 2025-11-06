//
//  TransactionTableCell.swift
//  Swipe
//
//  Created by Apple on 27/10/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit

class TransactionTableCell: UITableViewCell {
    
    @IBOutlet weak var lblHeader:UILabel!
        
    @IBOutlet weak var lblDynamicText:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
