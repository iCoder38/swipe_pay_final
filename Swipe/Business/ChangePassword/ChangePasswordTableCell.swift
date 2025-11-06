//
//  ChangePasswordTableCell.swift
//  Swipe
//
//  Created by evs_SSD on 1/16/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit

class ChangePasswordTableCell: UITableViewCell {

    @IBOutlet weak var txtCurrentPassword:UITextField!
    @IBOutlet weak var txtNewPassword:UITextField!
    @IBOutlet weak var txtConfirmPassword:UITextField!
    
    @IBOutlet weak var btnUpdatePassword:UIButton!
    
    @IBOutlet weak var viewUpperBG:UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
