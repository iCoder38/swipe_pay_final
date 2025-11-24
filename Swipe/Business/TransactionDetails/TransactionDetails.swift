//
//  TransactionDetails.swift
//  Swipe
//
//  Created by Apple on 27/10/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import CRNotifications

class TransactionDetails: UIViewController {
    
    // get tranasaction click data list
    var dictGetClickedTransaction:NSDictionary!
    
    let cellReuseIdentifier = "transactionTableCell"
    
    var dictServerValue:NSDictionary!
    
    var str_select_profile:String!
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            // lblNavigationTitle.text = "TRANSACTION DETAILS"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var btnBack:UIButton!
    
    @IBOutlet weak var lblAmountLeftInAccoun:UILabel! {
        didSet {
            // lblAmountLeftInAccoun.text = "500$"
            lblAmountLeftInAccoun.textColor = .white
        }
    }
    
    @IBOutlet weak var imgBusinessUserProfileImage:UIImageView! {
        didSet {
            imgBusinessUserProfileImage.layer.cornerRadius = 70
            imgBusinessUserProfileImage.clipsToBounds = true
            imgBusinessUserProfileImage.layer.borderColor = UIColor.init(red: 121.0/255.0, green: 128.0/255.0, blue: 181.0/255.0, alpha: 1).cgColor
            imgBusinessUserProfileImage.layer.borderWidth = 10.0
        }
    }
    
    @IBOutlet weak var lblBusinessUserName:UILabel! {
        didSet {
            // lblBusinessUserName.text = "Allen Chandler"
            lblBusinessUserName.textColor = .white
        }
    }
    
    @IBOutlet weak var view_bottom:UIView! {
        didSet {
            view_bottom.isHidden = true
        }
    }
    
    @IBOutlet weak var lblPaymentWillReflect:UILabel! {
        didSet {
            lblPaymentWillReflect.textColor = .white
        }
    }
    
    @IBOutlet weak var btnCall:UIButton! {
        didSet {
            btnCall.setTitleColor(.white, for: .normal)
            btnCall.setTitle("Paid To", for: .normal)
            btnCall.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var btnMail:UIButton! {
        didSet {
            btnMail.setTitleColor(BUTTON_BACKGROUND_COLOR_YELLOW, for: .normal)
            // btnMail.setTitle("Bobmarley Marley", for: .normal)
            btnCall.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            // tbleView.delegate = self
            // tbleView.dataSource = self
            self.tbleView.backgroundColor = .white
            self.tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.view.backgroundColor = BUTTON_BACKGROUND_COLOR_BLUE
        
        btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        // print(dictGetClickedTransaction as Any)
        
        /*
         amount = 5;
         balanceReceiver = 49;
         balanceSender = 46;
         created = "Jan 10th, 2020, 1:17 pm";
         receiverId = 61;
         receiverImage = "http://demo2.evirtualservices.com/swiipe/site/img/uploads/users/157541740520191027_160818.jpg";
         receiverName = "Benny Leahu";
         senderId = 74;
         senderImage = "http://demo2.evirtualservices.com/swiipe/site/img/uploads/users/1576134757images(8).jpeg";
         senderName = purnima;
         transactionsId = 237;
         type = SEND;
         */
        
        // (dictGetClickedTransaction!["type"] as! String)
        allTransactionsDetailsWB()
        
        let defaults = UserDefaults.standard
        let userName = defaults.string(forKey: "KeyLoginPersonal")
        if userName == "loginViaPersonal" {
            // personal user
            navigationBar.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
            self.view.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
        }
        else {
            navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
            self.view.backgroundColor = BUTTON_BACKGROUND_COLOR_BLUE
        }
        
        if self.str_select_profile == "yes" {
            self.btnBack.setImage(UIImage(systemName: "arrow.left"), for: .normal)
            self.btnBack.tintColor = .white
        }
        
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- ALL TRANSACTION DETAILS
    @objc func allTransactionsDetailsWB() {
        
        let defaults = UserDefaults.standard
        let userName = defaults.string(forKey: "KeyLoginPersonal")
        if userName == "loginViaPersonal" {
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            
        }
        else {
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        }
        
        let urlString = BASE_URL_SWIIPE
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        parameters = [
            "action"        : "transactiondetails",
            "transactionsId" : (dictGetClickedTransaction!["transactionsId"] as! Int)
        ]
        
        print("parameters-------\(String(describing: parameters))")
        
        Alamofire.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON {
            response in
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value {
                    
                    let JSON = data as! NSDictionary
                    print(JSON)
                    
                    var strSuccess : String!
                    strSuccess = JSON["status"]as Any as? String
                    
                    var strSuccessAlert : String!
                    strSuccessAlert = JSON["msg"]as Any as? String
                    
                    if strSuccess == "success" {
                        
                        self.dictServerValue = (JSON["data"] as! NSDictionary)
                        
                         /*
                          amount = 1;
                          bankName = "";
                          cardNumber = 4242424242424242;
                          created = "Jan 2nd, 2020, 10:48 am";
                          receiverContactNumber = 9638521230;
                          receiverEmail = "purnimaevs@gmail.com";
                          receiverId = 74;
                          receiverImage = "http://demo2.evirtualservices.com/swiipe/site/img/uploads/users/1576134757images(8).jpeg";
                          receiverName = purnima;
                          senderContactNumber = 9638521230;
                          senderEmail = "purnimaevs@gmail.com";
                          senderId = 74;
                          senderImage = "http://demo2.evirtualservices.com/swiipe/site/img/uploads/users/1576134757images(8).jpeg";
                          senderName = purnima;
                          transactionID = "tok_1FwM4SBnk7ygV50qJnDcfREo";
                          transactionsId = 00226;
                          type = ADD;
                          */
                        
                        if (self.dictServerValue!["type"] as! String) == "ADD" {
                            
                            self.imgBusinessUserProfileImage.sd_setImage(with: URL(string: (self.dictServerValue["senderImage"] as! String)), placeholderImage: UIImage(named: "plainBack")) // my profile image
                            
                            
                            // let amountIs:String = (self.dictServerValue?["amount"] as? String)!
                            
                            let strAmou:String = (self.dictServerValue?["amount"] as? String)!
                            self.lblBusinessUserName.text = "$ "+strAmou
                            
                            
                            
                            if (self.dictServerValue!["bankName"] as! String) == "" {
                                self.btnCall.setTitle("Wallet [CARD]", for: .normal)
                                self.btnMail.setTitle((self.dictServerValue["receiverName"] as! String), for: .normal)
                            } else{
                                self.btnCall.setTitle("Wallet [BANK]", for: .normal)
                                self.btnMail.setTitle((self.dictServerValue["bankName"] as! String), for: .normal)
                            }
                            
                             
                            
                            
                            self.lblNavigationTitle.text = "Transaction Details"
                        }
                        else if (self.dictServerValue!["type"] as! String) == "SEND" {
                            self.imgBusinessUserProfileImage.sd_setImage(with: URL(string: (self.dictServerValue["receiverImage"] as! String)), placeholderImage: UIImage(named: "plainBack")) // my profile image
                            
                            let strAmou:String = (self.dictServerValue?["amount"] as? String)!
                            
                            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                                
                                let x : Int = (person["userId"] as! Int)
                                let myString = String(x)
                                
                                let y : Int = (self.dictServerValue["receiverId"] as! Int)
                                let myString2 = String(y)
                                
                                if (myString2 == myString) {
                                    // +
                                    self.lblBusinessUserName.text = "$ "+strAmou
                                }
                                else {
                                    // -
                                    self.lblBusinessUserName.text = "- $ "+strAmou
                                }
                                
                            }
                            
                            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                                let x : Int = (person["userId"] as! Int)
                                let myString = String(x)
                                
                                if ("\(self.dictServerValue!["senderId"]!)" != String(myString)) {
                                    self.btnCall.setTitle("Received by", for: .normal)
                                    self.btnMail.setTitle((self.dictServerValue["senderName"] as! String), for: .normal)
                                } else {
                                    self.btnCall.setTitle("Paid to", for: .normal)
                                    self.btnMail.setTitle((self.dictServerValue["receiverName"] as! String), for: .normal)
                                }
                                
                            }
                            
                            
                            
                             
                            
                            
                            self.lblNavigationTitle.text = "Transaction Details"
                        }
                        
                        else if (self.dictServerValue!["type"] as! String) == "CASHOUT" {
                            
                            self.imgBusinessUserProfileImage.sd_setImage(with: URL(string: (self.dictServerValue["receiverImage"] as! String)), placeholderImage: UIImage(named: "plainBack"))
                            self.lblBusinessUserName.text = "-$ \(self.dictServerValue["amount"]!)"
                            self.btnCall.setTitle("CASHOUT", for: .normal)
                            self.btnMail.setTitle((self.dictServerValue["senderEmail"] as! String), for: .normal)
                            
                        }
                        
                        else if (self.dictServerValue!["type"] as! String) == "CardProcess" {
                            
                            self.btnCall.setTitle((self.dictServerValue["type"] as! String), for: .normal)
                            
                            self.imgBusinessUserProfileImage.sd_setImage(with: URL(string: (self.dictServerValue["receiverImage"] as! String)), placeholderImage: UIImage(named: "plainBack")) // my profile image
                            
                            let strAmou:String = (self.dictServerValue?["amount"] as? String)!
                            self.lblBusinessUserName.text = "+ $ "+strAmou
                            
                            // business email
                            self.btnMail.setTitle((self.dictServerValue["receiverName"] as! String), for: .normal)
                            
                             
                        }
                        self.lblNavigationTitle.text = "Transaction Details"
                        
                        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(tapGestureRecognizer:)))
                        self.imgBusinessUserProfileImage.isUserInteractionEnabled = true
                        self.imgBusinessUserProfileImage.addGestureRecognizer(tapGestureRecognizer)
                        
                        
                        
                        
                        self.tbleView.delegate = self
                        self.tbleView.dataSource = self
                        self.tbleView.reloadData()
                        
                        ERProgressHud.sharedInstance.hide()
                    }
                    else
                    {
                        // self.indicator.stopAnimating()
                        // self.enableService()
                        CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:strSuccessAlert, dismissDelay: 1.5, completion:{})
                        ERProgressHud.sharedInstance.hide()
                    }
                    
                }
                
            case .failure(_):
                print("Error message:\(String(describing: response.result.error))")
                // self.indicator.stopAnimating()
                // self.enableService()
                ERProgressHud.sharedInstance.hide()
                
                let alertController = UIAlertController(title: nil, message: SERVER_ISSUE_MESSAGE_ONE+"\n"+SERVER_ISSUE_MESSAGE_TWO, preferredStyle: .actionSheet)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                }
                
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
                
                break
            }
        }
        
        
        
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let present = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OpenImageInFullViewId") as? OpenImageInFullView
        
        if (self.dictServerValue!["type"] as! String) == "ADD" {
            present!.imgString = (self.dictServerValue["senderImage"] as! String)
        }
        else if (self.dictServerValue!["type"] as! String) == "SEND" {
            present!.imgString = (self.dictServerValue["receiverImage"] as! String)
        }
        
        
        self.present(present!, animated: true, completion: nil)
    }
}


extension TransactionDetails: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (dictServerValue!["type"] as! String) == "CASHOUT" {
            return 3
        } else if (dictServerValue!["type"] as! String) == "ADD" {
            return 2
        } else if (dictServerValue!["type"] as! String) == "SEND" {
            return 3
        }
        else{
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:TransactionTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! TransactionTableCell
        
        cell.backgroundColor = .white
        
        /*
         /*
          amount = 1;
          bankName = "";
          cardNumber = 4242424242424242;
          created = "Jan 2nd, 2020, 10:48 am";
          receiverContactNumber = 9638521230;
          receiverEmail = "purnimaevs@gmail.com";
          receiverId = 74;
          receiverImage = "http://demo2.evirtualservices.com/swiipe/site/img/uploads/users/1576134757images(8).jpeg";
          receiverName = purnima;
          senderContactNumber = 9638521230;
          senderEmail = "purnimaevs@gmail.com";
          senderId = 74;
          senderImage = "http://demo2.evirtualservices.com/swiipe/site/img/uploads/users/1576134757images(8).jpeg";
          senderName = purnima;
          transactionID = "tok_1FwM4SBnk7ygV50qJnDcfREo";
          transactionsId = 00226;
          type = ADD;
          */
         */
        
        cell.lblHeader.textColor = .black
        cell.lblDynamicText.textColor = .black
        
        if (dictServerValue!["type"] as! String) == "ADD" {
            self.lblPaymentWillReflect.isHidden = false
            
            if indexPath.row == 0 {
                cell.lblHeader.text = "TRANSACTION ID"
                
                cell.lblDynamicText.text = "\(self.dictServerValue?["transactionsId"]! ?? "0")"
            }
            if indexPath.row == 1 {
                if (dictServerValue!["bankName"] as! String) == "" {
                    cell.lblHeader.text = "CARD NUMBER"
                    
                    let cardNumber = (dictServerValue!["cardNumber"] as! String)
                    let last4 = cardNumber.suffix(4)
                    let masked = String(repeating: "* ", count: cardNumber.count - 4) + last4
                    cell.lblDynamicText.text = masked
                    
                } else{
                    cell.lblHeader.text = "ACCOUNT NUMBER"
                    
                    let cardNumber = (dictServerValue!["cardNumber"] as! String)
                    let last4 = cardNumber.suffix(4)
                    let masked = String(repeating: "* ", count: cardNumber.count - 4) + last4
                    cell.lblDynamicText.text = masked
                }
                
            }
            if indexPath.row == 2 {
                cell.lblHeader.text = "CONTACT NUMBER"
                cell.lblDynamicText.text = (dictServerValue!["senderContactNumber"] as! String)
            }
            if indexPath.row == 3 {
                cell.lblHeader.text = "FROM BANK"
            }
        }
        else if (dictServerValue!["type"] as! String) == "SEND" {
            
            self.lblPaymentWillReflect.isHidden = false
            
            
            
            if indexPath.row == 0 {
                cell.lblHeader.text = "TRANSACTION ID"
                cell.lblDynamicText.text = (dictServerValue!["transactionsId"] as! String)
                
            }
            if indexPath.row == 1 {
                if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                    let x : Int = (person["userId"] as! Int)
                    let myString = String(x)
                    
                    if ("\(self.dictServerValue!["senderId"]!)" != String(myString)) {
                        cell.lblHeader.text = "To: \((dictServerValue!["senderName"] as! String))"
                        cell.lblDynamicText.text = (dictServerValue!["senderEmail"] as! String)
                    } else {
                        cell.lblHeader.text = (dictServerValue!["receiverName"] as! String)
                        cell.lblDynamicText.text = (dictServerValue!["receiverEmail"] as! String)
                    }
                    
                }
                
            }
            if indexPath.row == 2 {
                cell.lblHeader.text = "CONTACT NUMBER"
                if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                    let x : Int = (person["userId"] as! Int)
                    let myString = String(x)
                    
                    if ("\(self.dictServerValue!["senderId"]!)" != String(myString)) {                         
                        cell.lblDynamicText.text = (dictServerValue!["senderContactNumber"] as! String)
                    } else {
                        cell.lblDynamicText.text = (dictServerValue!["receiverContactNumber"] as! String)
                    }
                    
                }
            }
            if indexPath.row == 3 {
                cell.lblHeader.text = "FROM BANK"
                cell.lblDynamicText.text = ""
            }
        } else if (dictServerValue!["type"] as! String) == "CASHOUT" {
            
            self.lblPaymentWillReflect.isHidden = false
            
            if indexPath.row == 0 {
                cell.lblHeader.text = "TRANSACTION ID"
                cell.lblDynamicText.text = (dictServerValue!["transactionsId"] as! String)
                
            }
            if indexPath.row == 1 {
                cell.lblHeader.text = "TO:\(dictServerValue!["senderName"] as! String)"
                cell.lblDynamicText.text = (dictServerValue!["senderEmail"] as! String)
            }
            if indexPath.row == 2 {
                cell.lblHeader.text = "PHONE NUMBER"
                cell.lblDynamicText.text = (dictServerValue!["senderContactNumber"] as! String)
            }
//            if indexPath.row == 3 {
//                cell.lblHeader.text = "FROM BANK"
//                cell.lblDynamicText.text = ""
//            }
        } else {
            
            self.lblPaymentWillReflect.isHidden = true
            
            if indexPath.row == 0 {
                cell.lblHeader.text = "TRANSACTION ID"
                // print(dictGetClickedTransaction!["transactionID"])
                // print(type(of: dictGetClickedTransaction!["transactionID"]))
                // cell.lblDynamicText.text = (dictServerValue!["transactionsId"] as! String)
                
                 cell.lblDynamicText.text = (dictServerValue!["transactionsId"] as! String)
                
                
                
            }
            if indexPath.row == 1 {
                
                cell.lblHeader.text = "Name on the card"
                cell.lblDynamicText.text = (dictServerValue!["nameOnCard"] as! String)
            }
            if indexPath.row == 2 {
                cell.lblHeader.text = "CONTACT NUMBER"
                cell.lblDynamicText.text = (dictServerValue!["receiverContactNumber"] as! String)
            }
            if indexPath.row == 3 {
                cell.lblHeader.text = "FROM BANK"
                cell.lblDynamicText.text = ""
            }
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        // let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SendMoneyId") as? SendMoney
        // self.navigationController?.pushViewController(settingsVCId!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (dictServerValue!["type"] as! String) == "ADD" {
            return 80
        } else if (dictServerValue!["type"] as! String) == "SEND" {
            return 80
        } else if (dictServerValue!["type"] as! String) == "CASHOUT" {
            return 80
        } else {
            if indexPath.row == 0 {
                return 80
            } else if indexPath.row == 1 {
                return 80
            } else {
                return 0
            }
            
        }
            
        
    }
    
}


extension TransactionDetails: UITableViewDelegate
{
    
}
