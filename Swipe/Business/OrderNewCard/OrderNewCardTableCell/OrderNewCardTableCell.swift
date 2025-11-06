//
//  OrderNewCardTableCell.swift
//  Swipe
//
//  Created by evs_SSD on 1/17/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit

class OrderNewCardTableCell: UITableViewCell {

    
    
    
    /* ****************************************** */
    
    @IBOutlet weak var txtSelectBank:UITextField!
    @IBOutlet weak var txtYourName:UITextField!
    @IBOutlet weak var txtAccountNumber:UITextField!
    @IBOutlet weak var txtPhoneNumber:UITextField!
    @IBOutlet weak var txtEmailAddress:UITextField!
    @IBOutlet weak var txtUploadImage:UITextField!
    
    /* ****************************************** */
    
    @IBOutlet weak var btnOpenBankList:UIButton!
    
    @IBOutlet weak var btnUpload:UIButton!
    
    @IBOutlet weak var btnSubmitRequest:UIButton! {
        didSet {
            btnSubmitRequest.layer.cornerRadius = 4
            btnSubmitRequest.clipsToBounds = true
            btnSubmitRequest.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
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
