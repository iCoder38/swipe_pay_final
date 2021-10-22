//
//  AllTransaction.swift
//  Swipe
//
//  Created by Apple  on 26/10/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import CRNotifications

class AllTransaction: UIViewController {

    
    let cellReuseIdentifier = "allTransactionTableCell"
    
    // array list
    var arrListOfAllTransaction:Array<Any>!
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "ALL TRANSACTION"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
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
        
        self.allTransactionWB()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
    
    //MARK:- ALL TRANSACTION
    @objc func allTransactionWB() {
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
           
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
                   parameters = [
                       "action"        : "transactionlist",
                       "userId"        : String(myString)
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
                                   // print(JSON)
                               
                               var strSuccess : String!
                               strSuccess = JSON["status"]as Any as? String
                               
                               var strSuccessAlert : String!
                               strSuccessAlert = JSON["msg"]as Any as? String
                               
                               if strSuccess == "success" //true
                               {
                                // var strPercentage : String!
                                // strPercentage = JSON["percentage"]as Any as? String
                                // print(strPercentage as Any)
                                // self.strSavePercentage = strPercentage
                                
                                var ar : NSArray!
                                ar = (JSON["data"] as! Array<Any>) as NSArray
                                self.arrListOfAllTransaction = (ar as! Array<Any>)
                                                             
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
    
}

extension AllTransaction: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrListOfAllTransaction.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:AllTransactionTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! AllTransactionTableCell
        
        cell.backgroundColor = .white
        
        /*
         amount = 1;
         balanceReceiver = 15317;
         balanceSender = "19.99";
         created = "Dec 27th, 2019, 3:39 pm";
         receiverId = 51;
         receiverImage = "http://demo2.evirtualservices.com/swiipe/site/img/uploads/users/1575511525IMG_20191017_135421.jpg";
         receiverName = purnima;
         senderId = 39;
         senderImage = "http://demo2.evirtualservices.com/swiipe/site/img/uploads/users/1576137063Screenshot_2019-11-06-20-05-14.png";
         senderName = "Dishant Rajput";
         transactionsId = 222;
         type = SEND;
         type = ADD;
         */
        
        
        
        
        
        let item = arrListOfAllTransaction[indexPath.row] as? [String:Any]
        print(item as Any)
        
        // account number
        cell.lblAccountNumber.text = (item!["created"] as! String)
        
        cell.lblMyFirstLetterIs.isHidden = true
        
        // print(item?["amount"] as! NSNumber)
        // let temp:NSNumber = item?["amount"] as! NSNumber
        // let tempString = temp.stringValue
        
        
        // account number
       // let livingArea = item?["amount"] as? Int ?? 0 // start
       // if livingArea == 0 {
           // let stringValue = String(livingArea)
           
        
        if (item!["type"] as! String) == "ADD" {
            cell.lblAmount.text = "+ $ "+((item?["amount"] as? String)!)
            cell.lblAmount.textColor = .systemGreen
            
            // bank name
            cell.lblBankName.text = "My Wallet" //(item!["receiverName"] as! String)
            
            // my image
            // image
             cell.imgProfilePicture.sd_setImage(with: URL(string: (item!["senderImage"] as! String)), placeholderImage: UIImage(named: "avatar"))
            
            
            
            
            
            /*
            let string = "My Wallet"//(item!["nameOnCard"] as! String)
            let first4 = string.prefix(1)
            let value = String(first4.uppercased())
            cell.lblMyFirstLetterIs.text = value
            cell.lblMyFirstLetterIs.backgroundColor = .clear
            cell.lblMyFirstLetterIs.layer.cornerRadius = 30
            cell.lblMyFirstLetterIs.clipsToBounds = true
            cell.lblMyFirstLetterIs.textAlignment = .center
            cell.lblMyFirstLetterIs.backgroundColor = .systemTeal
            */
            cell.imgProfilePicture.backgroundColor = .clear
            
            
            
        }
        else if (item!["type"] as! String) == "SEND" {
            cell.lblAmount.text = "- $ "+((item?["amount"] as? String)!)
            cell.lblAmount.textColor = .systemRed
            
            // bank name
            cell.lblBankName.text = (item!["receiverName"] as! String)
            
            // my image
            // image
             cell.imgProfilePicture.sd_setImage(with: URL(string: (item!["receiverImage"] as! String)), placeholderImage: UIImage(named: "avatar"))
            
            
            
            
            /*
            let string = (item!["receiverName"] as! String)
            let first4 = string.prefix(1)
            let value = String(first4.uppercased())
            cell.lblMyFirstLetterIs.text = value
            cell.lblMyFirstLetterIs.backgroundColor = .clear
            cell.lblMyFirstLetterIs.layer.cornerRadius = 30
            cell.lblMyFirstLetterIs.clipsToBounds = true
            cell.lblMyFirstLetterIs.textAlignment = .center
            cell.lblMyFirstLetterIs.backgroundColor = .systemTeal
            */
            
            
            cell.imgProfilePicture.backgroundColor = .clear
            
        }
        else {
            cell.lblAmount.text = "- $ "+((item?["amount"] as? String)!)
            cell.lblAmount.textColor = .systemRed
            
            // bank name
            cell.lblBankName.text = "Cashout" //(item!["receiverName"] as! String)
            
            // my image
            // image
             cell.imgProfilePicture.sd_setImage(with: URL(string: (item!["senderImage"] as! String)), placeholderImage: UIImage(named: "avatar"))
            
            
            
            
            
            /*
            let string = "Cashout"//(item!["nameOnCard"] as! String)
            let first4 = string.prefix(1)
            let value = String(first4.uppercased())
            cell.lblMyFirstLetterIs.text = value
            cell.lblMyFirstLetterIs.backgroundColor = .clear
            cell.lblMyFirstLetterIs.layer.cornerRadius = 30
            cell.lblMyFirstLetterIs.clipsToBounds = true
            cell.lblMyFirstLetterIs.textAlignment = .center
            cell.lblMyFirstLetterIs.backgroundColor = .systemTeal
            */
            
            cell.imgProfilePicture.backgroundColor = .clear
        }
        
        
       // } //
        
        /*
       else
       {
           let stringValue = String(livingArea)
           // cell.lblAmount.text = "$ "+stringValue
        
        if (item!["type"] as! String) == "ADD" {
            cell.lblAmount.text = "+ $ "+stringValue
            cell.lblAmount.textColor = .systemGreen
            
            // bank name
            cell.lblBankName.text = "My Wallet" //(item!["receiverName"] as! String)
            
            // my image
            // image
            cell.imgProfilePicture.sd_setImage(with: URL(string: (item!["senderImage"] as! String)), placeholderImage: UIImage(named: "avatar"))
            
            /*
            let string = "My Wallet"//(item!["nameOnCard"] as! String)
            let first4 = string.prefix(1)
            let value = String(first4.uppercased())
            cell.lblMyFirstLetterIs.text = value
            cell.lblMyFirstLetterIs.backgroundColor = .clear
            cell.lblMyFirstLetterIs.layer.cornerRadius = 30
            cell.lblMyFirstLetterIs.clipsToBounds = true
            cell.lblMyFirstLetterIs.textAlignment = .center
            cell.lblMyFirstLetterIs.backgroundColor = .systemTeal
            */
            
            cell.imgProfilePicture.backgroundColor = .clear
        }
        else if (item!["type"] as! String) == "SEND" {
            cell.lblAmount.text = "- $ "+stringValue
            cell.lblAmount.textColor = .systemRed
            
            // bank name
            cell.lblBankName.text = (item!["receiverName"] as! String)
            
            // my image
            // image
             cell.imgProfilePicture.sd_setImage(with: URL(string: (item!["receiverImage"] as! String)), placeholderImage: UIImage(named: "avatar"))
            
            
            
            /*
            let string = (item!["receiverName"] as! String)
            let first4 = string.prefix(1)
            let value = String(first4.uppercased())
            cell.lblMyFirstLetterIs.text = value
            cell.lblMyFirstLetterIs.backgroundColor = .clear
            cell.lblMyFirstLetterIs.layer.cornerRadius = 30
            cell.lblMyFirstLetterIs.clipsToBounds = true
            cell.lblMyFirstLetterIs.textAlignment = .center
            cell.lblMyFirstLetterIs.backgroundColor = .systemTeal
            */
            
            
            cell.imgProfilePicture.backgroundColor = .clear
            
            
            
            
            
        }
        else {
            cell.lblAmount.text = "- $ "+stringValue
            cell.lblAmount.textColor = .systemRed
            
            // bank name
            cell.lblBankName.text = "Cashout" //(item!["receiverName"] as! String)
            
            // my image
            // image
             cell.imgProfilePicture.sd_setImage(with: URL(string: (item!["senderImage"] as! String)), placeholderImage: UIImage(named: "avatar"))
            
            
            
            
            
            /*
            let string = "Cashout"//(item!["nameOnCard"] as! String)
            let first4 = string.prefix(1)
            let value = String(first4.uppercased())
            cell.lblMyFirstLetterIs.text = value
            cell.lblMyFirstLetterIs.backgroundColor = .clear
            cell.lblMyFirstLetterIs.layer.cornerRadius = 30
            cell.lblMyFirstLetterIs.clipsToBounds = true
            cell.lblMyFirstLetterIs.textAlignment = .center
            cell.lblMyFirstLetterIs.backgroundColor = .systemTeal
            */
            
            cell.imgProfilePicture.backgroundColor = .clear
        }
       } // last
 */
        cell.imgProfilePicture.backgroundColor = .clear
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        // dictGetClickedTransaction
        // pushToPageTransactionDetails()
        
        let item = arrListOfAllTransaction[indexPath.row] as? [String:Any]
        
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TransactionDetailsId") as? TransactionDetails
        settingsVCId!.dictGetClickedTransaction = item as NSDictionary?
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
        
    }
    
    @objc func pushToPageTransactionDetails() {
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TransactionDetailsId") as? TransactionDetails
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
    }
    
}


extension AllTransaction: UITableViewDelegate
{
    
}
