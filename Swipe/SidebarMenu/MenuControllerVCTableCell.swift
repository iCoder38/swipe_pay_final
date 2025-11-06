//
//  MenuControllerVCTableCell.swift
//  KREASE
//
//  Created by Apple  on 18/10/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit

class MenuControllerVCTableCell: UITableViewCell {

    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblDistance:UILabel! {
        didSet {
            lblDistance.textColor = .black
        }
    }
    
    @IBOutlet weak var imgProfile:UIImageView! {
        didSet
        {
            // imgProfile.layer.cornerRadius = 15
            // imgProfile.clipsToBounds = true
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
