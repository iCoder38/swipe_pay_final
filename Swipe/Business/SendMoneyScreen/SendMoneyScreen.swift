//
//  SendMoneyScreen.swift
//  Swipe
//
//  Created by Apple on 27/10/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit

class SendMoneyScreen: UIViewController {
    
    let cellReuseIdentifier = "sendMoneyScreenTableCell"

    @IBOutlet weak var navigationBar:UIView! {
           didSet {
               navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
           }
       }
       
       @IBOutlet weak var lblNavigationTitle:UILabel! {
           didSet {
               lblNavigationTitle.text = "SEND MONEY"
               lblNavigationTitle.textColor = .white
           }
       }
    
    @IBOutlet weak var lblCurrentWalletBalance:UILabel! {
        didSet {
            lblCurrentWalletBalance.text = "      Current Wallet Balance          "
            lblCurrentWalletBalance.textColor = .white
            lblCurrentWalletBalance.backgroundColor = UIColor.init(red: 100.0/255.0, green: 206.0/255.0, blue: 225.0/255.0, alpha: 1)
        }
    }
    
    @IBOutlet weak var lblTotalAmountInWallet:UILabel! {
        didSet {
            lblTotalAmountInWallet.text = "$600     "
            lblTotalAmountInWallet.textColor = .white
            lblTotalAmountInWallet.backgroundColor = UIColor.init(red: 100.0/255.0, green: 206.0/255.0, blue: 225.0/255.0, alpha: 1)
        }
    }
       
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var btnSendMoney:UIButton! {
        didSet {
            btnSendMoney.backgroundColor = BUTTON_BACKGROUND_COLOR_BLUE
            btnSendMoney.layer.cornerRadius = 4
            btnSendMoney.clipsToBounds = true
            btnSendMoney.setTitle("Send Money", for: .normal)
            btnSendMoney.setTitleColor(.white, for: .normal)
            btnSendMoney.addTarget(self, action: #selector(sendMoneyClickMethod), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var tbleView: UITableView! {
            didSet
            {
                tbleView.delegate = self
                tbleView.dataSource = self
                self.tbleView.backgroundColor = .clear
                self.tbleView.separatorStyle = UITableViewCell.SeparatorStyle.none
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let defaults = UserDefaults.standard
        let userName = defaults.string(forKey: "KeyLoginPersonal")
        if userName == "loginViaPersonal" {
            // personal user
            navigationBar.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
             // self.view.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
        }
        else {
            navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
            // self.view.backgroundColor = BUTTON_BACKGROUND_COLOR_BLUE
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    @objc func backClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func sendMoneyClickMethod() {
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProceedToPayId") as? ProceedToPay
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
    }
}


extension SendMoneyScreen: UITableViewDataSource
    {
        func numberOfSections(in tableView: UITableView) -> Int
        {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            return 20
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        {
            let cell:SendMoneyScreenTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! SendMoneyScreenTableCell
            
            cell.backgroundColor = .clear
            
            if indexPath.row % 2 == 0 {
                cell.viewLeft.isHidden = false
                cell.viewRight.isHidden = true
                cell.lblAmountRight.textColor = .black
                cell.lblReceivedRight.textColor = .black
            }
            else {
                cell.viewLeft.isHidden = true
                cell.viewRight.isHidden = false
                cell.lblAmountLeft.textColor = .black
                cell.lblReceivedLeft.textColor = .black
            }
            
            return cell
               
        }
        
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
        {
            return 160
        }
        
    }


    extension SendMoneyScreen: UITableViewDelegate
    {
        
    }
