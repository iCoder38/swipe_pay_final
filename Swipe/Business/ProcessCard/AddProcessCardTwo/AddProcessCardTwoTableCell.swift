//
//  AddProcessCardTwoTableCell.swift
//  Swipe
//
//  Created by evs_SSD on 1/23/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit

class AddProcessCardTwoTableCell: UITableViewCell,UITextFieldDelegate {

    let BG_COLOR_TEXTFIELDS = UIColor.init(red: 243.0/255.0, green: 245.0/255.0, blue: 248.0/255.0, alpha: 1)
    
    let UNDERLINE_COLOR = UIColor.init(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1)
    // 226 , 230 , 235
    @IBOutlet weak var txtSale:UITextField! {
        didSet {
            txtSale.isUserInteractionEnabled = false
            txtSale.text = "SALE"
            txtSale.textAlignment = .center
            txtSale.layer.cornerRadius = 2
            txtSale.clipsToBounds = true
            txtSale.backgroundColor = BG_COLOR_TEXTFIELDS
            txtSale.layer.borderColor = UIColor.init(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1).cgColor
            txtSale.layer.borderWidth = 0.7
        }
    }
    
    // 11 ,12 ,13
    @IBOutlet weak var txtEnterEmount:UITextField! {
        didSet {
            txtEnterEmount.placeholder = "Enter Amount"
            txtEnterEmount.textAlignment = .center
            txtEnterEmount.layer.cornerRadius = 2
            txtEnterEmount.clipsToBounds = true
            txtEnterEmount.backgroundColor = UIColor.init(red: 211.0/255.0, green: 212.0/255.0, blue: 213.0/255.0, alpha: 1)
            txtEnterEmount.layer.borderColor = UIColor.init(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1).cgColor
            txtEnterEmount.layer.borderWidth = 0.7
            txtEnterEmount.keyboardType = .numberPad
        }
    }
    
    @IBOutlet weak var txtNameOnCard:UITextField! {
        didSet {
            txtNameOnCard.delegate = self
            txtNameOnCard.placeholder = "Name on Card"
            // txtNameOnCard.textAlignment = .center
            txtNameOnCard.layer.cornerRadius = 2
            txtNameOnCard.clipsToBounds = true
            txtNameOnCard.backgroundColor = BG_COLOR_TEXTFIELDS
            txtNameOnCard.layer.borderColor = UIColor.clear.cgColor
            txtNameOnCard.layer.borderWidth = 0.0
        }
    }
    
    @IBOutlet weak var lblUnderLineNameOnCard:UILabel! {
        didSet {
            lblUnderLineNameOnCard.text = ""
            lblUnderLineNameOnCard.backgroundColor = UNDERLINE_COLOR
        }
    }
    
    // email address text field
    @IBOutlet weak var txtEmailAddress:UITextField! {
        didSet {
            txtEmailAddress.delegate = self
            txtEmailAddress.placeholder = "Email Address"
            // txtNameOnCard.textAlignment = .center
            txtEmailAddress.layer.cornerRadius = 2
            txtEmailAddress.clipsToBounds = true
            txtEmailAddress.backgroundColor = BG_COLOR_TEXTFIELDS
            txtEmailAddress.layer.borderColor = UIColor.clear.cgColor
            txtEmailAddress.layer.borderWidth = 0.0
        }
    }
    
    @IBOutlet weak var lblUnderLineEmailAddress:UILabel! {
        didSet {
            lblUnderLineEmailAddress.text = ""
            lblUnderLineEmailAddress.backgroundColor = UNDERLINE_COLOR
        }
    }
    
    
    // CREDIT CARD
    @IBOutlet weak var txtCreditCardNumber:UITextField! {
        didSet {
            txtCreditCardNumber.delegate = self
            txtCreditCardNumber.placeholder = "Credit Card Number"
            // txtNameOnCard.textAlignment = .center
            txtCreditCardNumber.layer.cornerRadius = 2
            txtCreditCardNumber.clipsToBounds = true
            txtCreditCardNumber.backgroundColor = BG_COLOR_TEXTFIELDS
            txtCreditCardNumber.layer.borderColor = UIColor.clear.cgColor
            txtCreditCardNumber.layer.borderWidth = 0.0
        }
    }
    
    @IBOutlet weak var lblUnderLineCreditCardNumber:UILabel! {
        didSet {
            lblUnderLineCreditCardNumber.text = ""
            lblUnderLineCreditCardNumber.backgroundColor = UNDERLINE_COLOR
        }
    }
    
    @IBOutlet weak var lblCardScanAutoFill:UILabel! {
        didSet {
            lblCardScanAutoFill.layer.cornerRadius = 4
            lblCardScanAutoFill.clipsToBounds = true
            lblCardScanAutoFill.text = "CARD SCAN AUTO FILL"
             lblCardScanAutoFill.backgroundColor = UIColor.init(red: 253.0/255.0, green: 223.0/255.0, blue: 173.0/255.0, alpha: 1)
            lblCardScanAutoFill.layer.borderColor = UIColor.init(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1).cgColor
            lblCardScanAutoFill.layer.borderWidth = 1
        }
    }
    
    // EXP DATE , CVV ,  ZIPCODE
    @IBOutlet weak var txtExpDate:UITextField! {
        didSet {
            txtExpDate.delegate = self
            txtExpDate.placeholder = "EXP. DATE"
            // txtNameOnCard.textAlignment = .center
            txtExpDate.layer.cornerRadius = 2
            txtExpDate.clipsToBounds = true
            txtExpDate.backgroundColor = BG_COLOR_TEXTFIELDS
            txtExpDate.layer.borderColor = UIColor.clear.cgColor
            txtExpDate.layer.borderWidth = 0.0
            txtExpDate.keyboardType = .numberPad
        }
    }
    
    @IBOutlet weak var txtCVV:UITextField! {
        didSet {
            txtCVV.keyboardType = .numberPad
            txtCVV.delegate = self
            txtCVV.placeholder = "CVV"
            // txtNameOnCard.textAlignment = .center
            txtCVV.layer.cornerRadius = 2
            txtCVV.clipsToBounds = true
            txtCVV.backgroundColor = BG_COLOR_TEXTFIELDS
            txtCVV.layer.borderColor = UIColor.clear.cgColor
            txtCVV.layer.borderWidth = 0.0
        }
    }
    
    @IBOutlet weak var txtZipCode:UITextField! {
        didSet {
            txtZipCode.keyboardType = .numberPad
            txtZipCode.delegate = self
            txtZipCode.placeholder = "Zip Code"
            // txtNameOnCard.textAlignment = .center
            txtZipCode.layer.cornerRadius = 2
            txtZipCode.clipsToBounds = true
            txtZipCode.backgroundColor = BG_COLOR_TEXTFIELDS
            txtZipCode.layer.borderColor = UIColor.clear.cgColor
            txtZipCode.layer.borderWidth = 0.0
        }
    }
    
    // PHONE NUMBER
    @IBOutlet weak var txtPhoneNumber:UITextField! {
        didSet {
            txtPhoneNumber.delegate = self
            txtPhoneNumber.placeholder = "Phone Number"
            // txtNameOnCard.textAlignment = .center
            txtPhoneNumber.layer.cornerRadius = 2
            txtPhoneNumber.clipsToBounds = true
            txtPhoneNumber.backgroundColor = BG_COLOR_TEXTFIELDS
            txtPhoneNumber.layer.borderColor = UIColor.clear.cgColor
            txtPhoneNumber.layer.borderWidth = 0.0
            txtPhoneNumber.keyboardType = .numberPad
        }
    }
    
    @IBOutlet weak var lblUnderLinePhoneNumber:UILabel! {
        didSet {
            lblUnderLinePhoneNumber.text = ""
            lblUnderLinePhoneNumber.backgroundColor = UNDERLINE_COLOR
        }
    }
    
    @IBOutlet weak var btnChargeAmount:UIButton! {
        didSet {
            btnChargeAmount.layer.cornerRadius = 4
            btnChargeAmount.clipsToBounds = true
            btnChargeAmount.backgroundColor = UIColor.init(red: 18.0/255.0, green: 198.0/255.0, blue: 250.0/255.0, alpha: 1)
        }
    }
    
    @IBOutlet weak var btnVisaPay:UIButton! {
        didSet {
            btnVisaPay.layer.cornerRadius = 8
            btnVisaPay.clipsToBounds = true
            btnVisaPay.backgroundColor = .white
            btnVisaPay.layer.borderColor = UIColor.lightGray.cgColor
            btnVisaPay.layer.borderWidth = 1
        }
    }
    
    @IBOutlet weak var btnScanCard:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
