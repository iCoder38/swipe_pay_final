//
//  ProcessingCardListTableCell.swift
//  Swipe
//
//  Created by evs_SSD on 1/15/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit

class ProcessingCardListTableCell: UITableViewCell {

    @IBOutlet weak var imgCardImage:UIImageView!
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblCardNumber:UILabel!
    @IBOutlet weak var lblCreatedAt:UILabel!
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
