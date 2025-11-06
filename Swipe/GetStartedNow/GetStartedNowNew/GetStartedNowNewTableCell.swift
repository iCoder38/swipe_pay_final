//
//  GetStartedNowNewTableCell.swift
//  Swipe
//
//  Created by evs_SSD on 2/7/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit

class GetStartedNowNewTableCell: UITableViewCell {

    let cellReuseIdentifier = "getStartedNowNewTableCell"
    
    @IBOutlet weak var txtEmail:UITextField! {
        didSet {
            txtEmail.layer.borderWidth = 0.8
            txtEmail.layer.borderColor = UIColor.init(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1).cgColor
            txtEmail.backgroundColor = UIColor.init(red: 251.0/255.0, green: 251.0/255.0, blue: 251.0/255.0, alpha: 1)
            
        }
    }
    @IBOutlet weak var txtPassword:UITextField! {
        didSet {
            txtPassword.layer.borderWidth = 0.8
            txtPassword.layer.borderColor = UIColor.init(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1).cgColor
            txtPassword.backgroundColor = UIColor.init(red: 251.0/255.0, green: 251.0/255.0, blue: 251.0/255.0, alpha: 1)
            txtPassword.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var btnForgotPassword:UIButton! {
        didSet {
            btnForgotPassword.setTitleColor(UIColor.init(red: 167.0/255.0, green: 129.0/255.0, blue: 237.0/255.0, alpha: 1), for: .normal)
        }
    }
    @IBOutlet weak var btnSignInSubmit:UIButton! {
        didSet {
            // btnSignInSubmit.addTarget(self, action: #selector(login), for: .touchUpInside)
            // login
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

