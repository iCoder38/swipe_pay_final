//
//  AddInvoiceTableCell.swift
//  Swipe
//
//  Created by evs_SSD on 2/20/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit

class AddInvoiceTableCell: UITableViewCell {

    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lbPrice:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
