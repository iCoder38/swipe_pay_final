//
//  AddProcessCardTableCell.swift
//  Swipe
//
//  Created by evs_SSD on 1/15/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit

class AddProcessCardTableCell: UITableViewCell {

    @IBOutlet weak var txtCustomerName:UITextField!
    
    @IBOutlet weak var txtCardNumber:UITextField! {
            didSet {
                txtCardNumber.keyboardType = .numberPad
            }
        }
    
    @IBOutlet weak var txtEmail:UITextField!
    
    @IBOutlet weak var txtCardExpDate:UITextField!
    
    @IBOutlet weak var txtCVV:UITextField! {
            didSet {
                txtCVV.keyboardType = .numberPad
            }
        }
    
    @IBOutlet weak var txtPhoneNumber:UITextField! {
            didSet {
                txtPhoneNumber.keyboardType = .phonePad
            }
        }
    
    @IBOutlet weak var txtInvoiceAmount:UITextField! {
            didSet {
                txtInvoiceAmount.keyboardType = .numberPad
            }
        }
    
    @IBOutlet weak var txtFeeOnOff:UITextField!
    @IBOutlet weak var txtTotalPayableAmount:UITextField! {
            didSet {
                
                txtTotalPayableAmount.keyboardType = .numberPad
                txtTotalPayableAmount.isUserInteractionEnabled = false
            }
        }
    
    @IBOutlet weak var lblInvoiceAmount:UILabel! {
        didSet {
            // lblInvoiceAmount.text = "INVOICE AMOUNT : $500"
            lblInvoiceAmount.textColor = .black
        }
    }
    
    @IBOutlet weak var lblProcessingFee:UILabel! {
        didSet {
            // lblProcessingFee.text = "TOTAL PROCESSING FEE : $500"
            lblProcessingFee.textColor = .black
        }
    }
    
    @IBOutlet weak var btnSubmit:UIButton! {
        didSet {
            btnSubmit.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
            btnSubmit.layer.cornerRadius = 4
            btnSubmit.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lblTotalAmount:UILabel! {
        didSet {
            // lblTotalAmount.text = "TOTAL AMOUNT : $500"
            lblTotalAmount.textColor = .black
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
