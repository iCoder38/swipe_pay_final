//
//  RequestMoneyUser.swift
//  Swipe
//
//  Created by Apple on 17/03/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import CRNotifications

class RequestMoneyUser: UIViewController {

    let cellReuseIdentifier = "requestMoneyUserTableCell"
    
    var arrListOfAllTransaction:Array<Any>!
    
    var noDataLbl : UILabel?
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "REQUEST MONEY USER"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
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
            lblTotalAmountInWallet.textColor = .white
            lblTotalAmountInWallet.backgroundColor = UIColor.init(red: 100.0/255.0, green: 206.0/255.0, blue: 225.0/255.0, alpha: 1)
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
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        noDataLbl?.isHidden = true
        
        // sidebarMenuClick()
        
        let defaults = UserDefaults.standard
        if let name = defaults.string(forKey: "keySideBarMenu") {
            // print(name)
            if name == "dSideBar" {
                btnBack.setImage(UIImage(named: "menuWhite"), for: .normal)
                sidebarMenuClick()
            }
            else {
                btnBack.setImage(UIImage(named: "backs"), for: .normal)
                btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
            }
        }
        else
        {
            btnBack.setImage(UIImage(named: "backs"), for: .normal)
            btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
        
        // let defaults = UserDefaults.standard
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
        
        // self.allTransactionWB()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // let x : NSNumber = person["wallet"] as! NSNumber
            // self.lblTotalAmountInWallet.text = "$ "+"\(x)"
            
            let x : Double = person["wallet"] as! Double
            let foo = x.rounded(digits: 2)
            self.lblTotalAmountInWallet.text = "$ "+"\(foo)"
            
            
        }
        else {
            // session expired. Please logout.
        }
        
        self.usersListWBForSendOrReceive(strSendOrReceive: "RECEIVE", strForCell: "9")
    }
    
    @objc func sidebarMenuClick() {
        if revealViewController() != nil {
        btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
          }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- USERS LIST FOR PERSONAL -
    @objc func usersListWBForSendOrReceive(strSendOrReceive:String,strForCell:String) {
            // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            
            let defaults = UserDefaults.standard
            let userName = defaults.string(forKey: "KeyLoginPersonal")
            if userName == "loginViaPersonal" {
                // personal user
                 ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
                
            }
            else {
                 ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            }
               
            let urlString = BASE_URL_SWIIPE
                   
            var parameters:Dictionary<AnyHashable, Any>!
               
             if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                 let x : Int = (person["userId"] as! Int)
                 let myString = String(x)
                
                /*
                 [action] => userlist
                 [userId] => 74
                 [pageNo] => 0
                 */
                    parameters = [
                        "action"         : "paymentrequestlist",
                        "userId"         : String(myString),
                        "requestType"    : String(strSendOrReceive),
                        "pageNo"         : ""
                    ]
             }
                    
                       print("parameters-------\(String(describing: parameters))")
                       
                       Alamofire.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON
                           {
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
                                   
                                   if strSuccess == "success" //true
                                   {
                                    ERProgressHud.sharedInstance.hide()
                                    
                                    // let defaults = UserDefaults.standard
                                    
                                     var ar : NSArray!
                                     ar = (JSON["data"] as! Array<Any>) as NSArray
                                     self.arrListOfAllTransaction = (ar as! Array<Any>)
                                    
                                    // self.searchArrayStr = strForCell
                                    
                                    // print(self.arrListOfSendReceiveUsers as Any)
                                    
                                    if self.arrListOfAllTransaction.count > 0 {
                                        self.noDataLbl?.isHidden = true
                                        self.noDataLbl = UILabel(frame: CGRect(x: 0, y: self.view.center.y, width: 290, height: 70))
                                        self.noDataLbl!.removeFromSuperview()
                                        self.tbleView.isHidden = false
                                        self.tbleView.delegate = self
                                        self.tbleView.dataSource = self
                                        self.tbleView.reloadData()
                                    } else {
                                        self.noDataLbl?.isHidden = false
                                        self.noDataLbl = UILabel(frame: CGRect(x: 0, y: self.view.center.y, width: 290, height: 70))
                                        self.noDataLbl?.textAlignment = .center
                                        self.noDataLbl?.font = UIFont(name: "Halvetica", size: 18.0)
                                        self.noDataLbl?.numberOfLines = 0
                                        self.noDataLbl?.text = "No Data Found"
                                        self.noDataLbl?.textColor = .black
                                        self.noDataLbl?.lineBreakMode = .byTruncatingTail
                                        self.noDataLbl?.center = self.view.center
                                        self.view.addSubview(self.noDataLbl!)
                                        self.tbleView.isHidden = true
                                    }
                                    
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
    
}

extension RequestMoneyUser: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrListOfAllTransaction.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:RequestMoneyUserTableCell = tableView.dequeueReusableCell(withIdentifier: "requestMoneyUserTableCell") as! RequestMoneyUserTableCell
        
        cell.backgroundColor = .white
        
        
        let item = arrListOfAllTransaction[indexPath.row] as? [String:Any]
        print(item as Any)
        
        
        // receive
        let contact = self.arrListOfAllTransaction[indexPath.row]
        let fbemail = ((contact as AnyObject)["userName"]! as? String ?? "")+" - $ "+((contact as AnyObject)["amount"]! as? String ?? "")
        cell.PersonNameLabel.text = fbemail
        
        let imagee = ((contact as AnyObject)["userImage"]! as? String ?? "")
        
        cell.PersonImage.sd_setImage(with: URL(string: imagee), placeholderImage: UIImage(named: "avatar")) // my profile image
        
        let phoneNumberIs = ((contact as AnyObject)["contactNumber"]! as? String ?? "")
        cell.PersonMobileNOLabel.text = phoneNumberIs
        
        
        cell.imgs.image = UIImage(named:"rightArrow")
        cell.imgs.isHidden = true
        
        
        // 1 : pending
        // 2 : send
        // 3 : decline
        
        let x : Int = (contact as AnyObject)["status"]! as! Int
        let amountIs = String(x)
        if amountIs == "1" {
            cell.statusLabel.isHidden = false
            cell.statusLabel.text = "pending..."
            cell.statusLabel.textColor = .white
            cell.statusLabel.backgroundColor = .systemGray
            cell.statusLabel.layer.cornerRadius = 2
            cell.statusLabel.clipsToBounds = true
        } else if amountIs == "2" {
            cell.statusLabel.isHidden = false
            cell.statusLabel.text = "accepted"
            cell.statusLabel.textColor = .white
            cell.statusLabel.backgroundColor = .systemGreen
            cell.statusLabel.layer.cornerRadius = 2
            cell.statusLabel.clipsToBounds = true
        } else if amountIs == "3" {
            cell.statusLabel.isHidden = false
            cell.statusLabel.text = "decline"
            cell.statusLabel.textColor = .white
            cell.statusLabel.backgroundColor = .systemRed
            cell.statusLabel.layer.cornerRadius = 2
            cell.statusLabel.clipsToBounds = true
        } else {
            cell.statusLabel.isHidden = true
        }
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        // dictGetClickedTransaction
        // pushToPageTransactionDetails()
        
        // let item = arrListOfAllTransaction[indexPath.row] as? [String:Any]
        
        let contact2 = self.arrListOfAllTransaction[indexPath.row]
        print(contact2 as Any)
        
        /*
         amount = "2.55";
         contactNumber = 6598655894;
         created = "Mar 17th, 2020, 1:26 pm";
         message = t;
         requestFrom = 75;
         requestId = 18;
         requestTo = 208;
         status = 1;
         userId = 208;
         userImage = "";
         userName = gegge;
         */
        
        //if searchArrayStr == "9" {
        let x2 : Int = (contact2 as AnyObject)["status"]! as! Int
        let amountIs2 = String(x2)
        if amountIs2 == "1" {
            let finalAmountIs:String!
            let amountIs = ((contact2 as AnyObject)["amount"]! as? String ?? "")
            if amountIs == "" {
                let x : Int = (contact2 as AnyObject)["amount"]! as! Int
                let amountIs = String(x)
                finalAmountIs = amountIs
            } else {
                finalAmountIs = amountIs
            }
            
            let requestedAt = "Requested: "+((contact2 as AnyObject)["created"]! as? String ?? "")
            let username = "name: "+((contact2 as AnyObject)["userName"]! as? String ?? "")
            let messageAt = ((contact2 as AnyObject)["message"]! as? String ?? "")
            
            var strMessagee:String!
            
            if messageAt == "" {
                strMessagee = ""
            } else {
                strMessagee = "says: "+"'"+messageAt+"'"
            }
            
            let alert = UIAlertController(title: "$ "+finalAmountIs, message: ""+requestedAt+"\n"+username+"\n"+strMessagee,         preferredStyle: UIAlertController.Style.alert)
            
            
            
            alert.addAction(UIAlertAction(title: "Pay",
                                          style: UIAlertAction.Style.default,
                                          handler: {(_: UIAlertAction!) in
                //Sign out action
                
                let x : Int = (contact2 as AnyObject)["requestId"]! as! Int
                let REQUESTID = String(x)
                
                // self.sendMoney(amount: <#T##String#>, receiverId: <#T##String#>)
                
            }))
            alert.addAction(UIAlertAction(title: "Decline",
                                          style: UIAlertAction.Style.destructive,
                                          handler: {(_: UIAlertAction!) in
                //Sign out action
                let x : Int = (contact2 as AnyObject)["requestId"]! as! Int
                let REQUESTID = String(x)
                self.payOrDeclineWB(strRequestId: REQUESTID, strStatus: "3")
            }))
            alert.addAction(UIAlertAction(title: "Dismiss",
                                          style: UIAlertAction.Style.cancel,
                                          handler: {(_: UIAlertAction!) in
                //Sign out action
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        } else if amountIs2 == "2" {
            let finalAmountIs:String!
            let sentMessage = "You already sent money"
            let amountIs = ((contact2 as AnyObject)["amount"]! as? String ?? "")
            if amountIs == "" {
                let x : Int = (contact2 as AnyObject)["amount"]! as! Int
                let amountIs = String(x)
                finalAmountIs = "$ "+amountIs
            } else {
                finalAmountIs = "$ "+amountIs
            }
            
            let requestedAt = "Requested: "+((contact2 as AnyObject)["created"]! as? String ?? "")
            let username = "name: "+((contact2 as AnyObject)["userName"]! as? String ?? "")
            let messageAt = ((contact2 as AnyObject)["message"]! as? String ?? "")
            
            var strMessagee:String!
            
            if messageAt == "" {
                strMessagee = ""
            } else {
                strMessagee = "says: "+"'"+messageAt+"'"
            }
            
            let alert = UIAlertController(title:sentMessage , message: finalAmountIs+"\n"+requestedAt+"\n"+username+"\n"+strMessagee,         preferredStyle: UIAlertController.Style.alert)
            
            
            
            alert.addAction(UIAlertAction(title: "Already accepted",
                                          style: UIAlertAction.Style.default,
                                          handler: {(_: UIAlertAction!) in
                //Sign out action
                
                
            }))
            
            
            self.present(alert, animated: true, completion: nil)
        } else if amountIs2 == "3" {
            let finalAmountIs:String!
            let sentMessage = "You declined the request"
            let amountIs = ((contact2 as AnyObject)["amount"]! as? String ?? "")
            if amountIs == "" {
                let x : Int = (contact2 as AnyObject)["amount"]! as! Int
                let amountIs = String(x)
                finalAmountIs = "$ "+amountIs
            } else {
                finalAmountIs = "$ "+amountIs
            }
            
            let requestedAt = "Requested: "+((contact2 as AnyObject)["created"]! as? String ?? "")
            let username = "name: "+((contact2 as AnyObject)["userName"]! as? String ?? "")
            let messageAt = ((contact2 as AnyObject)["message"]! as? String ?? "")
            
            var strMessagee:String!
            
            if messageAt == "" {
                strMessagee = ""
            } else {
                strMessagee = "says: "+"'"+messageAt+"'"
            }
            
            let alert = UIAlertController(title:sentMessage , message: finalAmountIs+"\n"+requestedAt+"\n"+username+"\n"+strMessagee,         preferredStyle: UIAlertController.Style.alert)
            
            
            
            alert.addAction(UIAlertAction(title: "Declined",
                                          style: UIAlertAction.Style.destructive,
                                          handler: {(_: UIAlertAction!) in
                //Sign out action
                
                
            }))
            
            
            self.present(alert, animated: true, completion: nil)
        } else {
            
        }
       
    }
    
    //MARK:- SEND MONEY
    @objc func sendMoney(amount:String,receiverId:String) {
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        let defaults = UserDefaults.standard
        let userName = defaults.string(forKey: "KeyLoginPersonal")
        if userName == "loginViaPersonal" {
            // personal user
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        }
        else {
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        }
        
        let urlString = BASE_URL_SWIIPE
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            /*
             action=sendmoney&userId=554&receiverId=551&amount=69
             */
            
            parameters = [
                "action"        : "sendmoney",
                "userId"        : String(myString),
                "receiverId"    : String(receiverId),
                "amount"        : String(amount)
            ]
        }
        
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
                        ERProgressHud.sharedInstance.hide()
                        
//                        self.payOrDeclineWB(strRequestId: REQUESTID, strStatus: "2")
                        // self.usersListWBForSendOrReceive(strSendOrReceive: "RECEIVE", strForCell: "9")
                        
                    }
                    else {
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
    
    
    @objc func payOrDeclineWB(strRequestId:String,strStatus:String) {
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let defaults = UserDefaults.standard
        let userName = defaults.string(forKey: "KeyLoginPersonal")
        if userName == "loginViaPersonal" {
            // personal user
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            
        }
        else {
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        }
        
        let urlString = BASE_URL_SWIIPE
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            /*
             action: updaterequest
             requestId:
             userId:
             status:  1=Request/ 2=send/ 3=DECLINE
             */
            
            parameters = [
                "action"        : "updaterequest",
                "userId"        : String(myString),
                "requestId"     : String(strRequestId),
                "status"        : String(strStatus)
            ]
        }
        
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
                        ERProgressHud.sharedInstance.hide()
                        
                        self.usersListWBForSendOrReceive(strSendOrReceive: "RECEIVE", strForCell: "9")
                        
                    }
                    else {
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
    
    
    
    
    
    
}


extension RequestMoneyUser: UITableViewDelegate
{
    
}
