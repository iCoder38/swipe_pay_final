//
//  GetStartedRegistrationTableCell.swift
//  Swipe
//
//  Created by evs_SSD on 1/28/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit

class GetStartedRegistrationTableCell: UITableViewCell {

    @IBOutlet weak var txtEmail:UITextField! {
        didSet {
            txtEmail.layer.borderWidth = 0.8
            txtEmail.layer.borderColor = UIColor.init(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1).cgColor
            txtEmail.backgroundColor = UIColor.init(red: 251.0/255.0, green: 251.0/255.0, blue: 251.0/255.0, alpha: 1)
            txtEmail.keyboardType = .emailAddress
        }
    }
    @IBOutlet weak var txtName:UITextField! {
        didSet {
            txtName.layer.borderWidth = 0.8
            txtName.layer.borderColor = UIColor.init(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1).cgColor
            txtName.backgroundColor = UIColor.init(red: 251.0/255.0, green: 251.0/255.0, blue: 251.0/255.0, alpha: 1)
        }
    }
    @IBOutlet weak var txtPhone:UITextField! {
        didSet {
            txtPhone.layer.borderWidth = 0.8
            txtPhone.layer.borderColor = UIColor.init(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1).cgColor
            txtPhone.backgroundColor = UIColor.init(red: 251.0/255.0, green: 251.0/255.0, blue: 251.0/255.0, alpha: 1)
            txtPhone.keyboardType = .phonePad
        }
    }
    @IBOutlet weak var txtPassword:UITextField! {
        didSet {
            txtPassword.layer.borderWidth = 0.8
            txtPassword.layer.borderColor = UIColor.init(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1).cgColor
            txtPassword.backgroundColor = UIColor.init(red: 251.0/255.0, green: 251.0/255.0, blue: 251.0/255.0, alpha: 1)
        }
    }
    
    @IBOutlet weak var btnSignInSubmit:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
