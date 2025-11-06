//
//  AddNewGiftCardTableCell.swift
//  Swipe
//
//  Created by evs_SSD on 2/19/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit

class AddNewGiftCardTableCell: UITableViewCell {

    @IBOutlet weak var txtSelectUser:UITextField! {
        didSet {
            txtSelectUser.layer.borderWidth = 0.8
            txtSelectUser.layer.borderColor = UIColor.init(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1).cgColor
            txtSelectUser.backgroundColor = UIColor.init(red: 251.0/255.0, green: 251.0/255.0, blue: 251.0/255.0, alpha: 1)
            
        }
    }
    @IBOutlet weak var txtOccasion:UITextField! {
        didSet {
            txtOccasion.layer.borderWidth = 0.8
            txtOccasion.layer.borderColor = UIColor.init(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1).cgColor
            txtOccasion.backgroundColor = UIColor.init(red: 251.0/255.0, green: 251.0/255.0, blue: 251.0/255.0, alpha: 1)
            
        }
    }
    @IBOutlet weak var txtGiftAmount:UITextField! {
        didSet {
            txtGiftAmount.layer.borderWidth = 0.8
            txtGiftAmount.layer.borderColor = UIColor.init(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1).cgColor
            txtGiftAmount.backgroundColor = UIColor.init(red: 251.0/255.0, green: 251.0/255.0, blue: 251.0/255.0, alpha: 1)
            
        }
    }
    @IBOutlet weak var txtAddress:UITextField! {
        didSet {
            txtAddress.layer.borderWidth = 0.8
            txtAddress.layer.borderColor = UIColor.init(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1).cgColor
            txtAddress.backgroundColor = UIColor.init(red: 251.0/255.0, green: 251.0/255.0, blue: 251.0/255.0, alpha: 1)
            
        }
    }
    @IBOutlet weak var txtState:UITextField! {
        didSet {
            txtState.layer.borderWidth = 0.8
            txtState.layer.borderColor = UIColor.init(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1).cgColor
            txtState.backgroundColor = UIColor.init(red: 251.0/255.0, green: 251.0/255.0, blue: 251.0/255.0, alpha: 1)
            
        }
    }
    @IBOutlet weak var txtPostalCode:UITextField! {
        didSet {
            txtPostalCode.layer.borderWidth = 0.8
            txtPostalCode.layer.borderColor = UIColor.init(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1).cgColor
            txtPostalCode.backgroundColor = UIColor.init(red: 251.0/255.0, green: 251.0/255.0, blue: 251.0/255.0, alpha: 1)
            
        }
    }
    @IBOutlet weak var btnGiftCard:UIButton! {
        didSet {
            btnGiftCard.layer.cornerRadius = 4
            btnGiftCard.clipsToBounds = true
            btnGiftCard.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
            btnGiftCard.setTitle("Submit", for: .normal)
        }
    }
    
    @IBOutlet weak var btnSelectUser:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
