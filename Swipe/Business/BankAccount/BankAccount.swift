//
//  BankAccount.swift
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

class BankAccount: UIViewController {

    let cellReuseIdentifier = "bankAccountTableCell"
    
    // array list
    var arrListOfAllCards:Array<Any>!
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "ADD BANK ACCOUNT"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var btnAddAccount:UIButton! {
        didSet {
            btnAddAccount.addTarget(self, action: #selector(addAccountClickMethod), for: .touchUpInside)
            btnAddAccount.setTitle("Add Bank", for: .normal)
        }
    }
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            self.tbleView.backgroundColor = .white
            self.tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.listOfBankWB()
    }
    
    @objc func addAccountClickMethod() {
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddBankAccountId") as? AddBankAccount
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
    }
    
    /*
     [action] => bankaccountlist
     [userId] => 74
     */
    
    // MARK:- LIST OF BANKS
    @objc func listOfBankWB() {
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
           
        /*
         [action] => listcard
         [userId] => 74
         [type] => DEBIT
         */
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
                   parameters = [
                       "action" : "bankaccountlist",
                    "userId"   : String(myString)
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
                                /*
                                 
                                 */
                               
                               var strSuccess : String!
                               strSuccess = JSON["status"]as Any as? String
                               
                               var strSuccessAlert : String!
                               strSuccessAlert = JSON["msg"]as Any as? String
                               
                               if strSuccess == "success" //true
                               {
                                
                                
                                var ar : NSArray!
                                ar = (JSON["data"] as! Array<Any>) as NSArray
                                self.arrListOfAllCards = (ar as! Array<Any>)
                                
                                self.tbleView.delegate = self
                                self.tbleView.dataSource = self
                                self.tbleView .reloadData()
                                //self.arrListOfAllCards = self.arrListOfSavedCards
                                
    
                                
                                
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

extension BankAccount: UITableViewDataSource
    {
        func numberOfSections(in tableView: UITableView) -> Int
        {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            return arrListOfAllCards.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        {
            let cell:BankAccountTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! BankAccountTableCell
            
            cell.backgroundColor = .white
            
            /*
             accountName = purnima;
             accountNumber = 1236549874563;
             bankImage = "http://demo2.evirtualservices.com/swiipe/site/img/uploads/bank/Wells_Fargo_Bank.svg.png";
             bankName = "WELLS FARGO";
             bankaccountId = 70;
             created = "Dec 12th, 2019, 1:02 pm";
             modify = "";
             routingNo = 9876412343;
             userImage = "http://demo2.evirtualservices.com/swiipe/site/img/uploads/users/1576134757images(8).jpeg";
             userName = purnima;
             */
            
            let item = arrListOfAllCards[indexPath.row] as? [String:Any]
            
            // cell.imgProfilePicture.image = UIImage(named:"avatar")
            
            cell.imgProfilePicture.sd_setImage(with: URL(string: (item!["bankImage"] as! String)), placeholderImage: UIImage(named: "bankPlaceholderBlack"))
            
            let last4 = (item!["accountNumber"] as! String).suffix(4)
            cell.lblAccountNumber.text = "xxxx xxxx xxxx - "+String(last4)
            
            cell.lblBankName.text = (item!["bankName"] as! String)
                            
            cell.lblBankName.textColor = .black
            cell.lblAccountNumber.textColor = .black
            
            // let image = UIImage(named: "rightArrow")
            // let checkmark  = UIImageView(frame:CGRect(x:0, y:0, width:16, height:16))
            // checkmark.image = image
            //cell.accessoryView = checkmark
            
            cell.btnDeleteBank.tag = indexPath.row
            cell.btnDeleteBank.addTarget(self, action: #selector(deleteBankClickMethod), for: .touchUpInside)
            
            return cell
        }
    @objc func deleteBankClickMethod(_ sender:UIButton) {
        // print(sender.tag)
         let item = arrListOfAllCards[sender.tag] as? [String:Any]
        
        let alertController = UIAlertController(title: nil, message: "Delete Bank Account", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive) {
                UIAlertAction in
            self.areYouSureYouWantToDelete(getSelectedCardDictionary: item! as NSDictionary)
            }
        let CancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) {
            UIAlertAction in
        }
        
        alertController.addAction(deleteAction)
        alertController.addAction(CancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func areYouSureYouWantToDelete(getSelectedCardDictionary:NSDictionary) {
        
        let last4 = (getSelectedCardDictionary["accountNumber"] as! String).suffix(4)
        
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to delete this Bank"+"\n\n "+"Name : "+(getSelectedCardDictionary["bankName"] as! String)+" "+"\n "+"Number : "+String(last4), preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive) {
                UIAlertAction in
            /*
             [action] => deleteprocesstransation
                [userId] => 74
                [cardprocessId] => 9
             */
            self.deleteProcessingCard(bankAccountId: (getSelectedCardDictionary["bankaccountId"] as! Int))
            }
        
        let CancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.default) {
            UIAlertAction in
        }
        
        alertController.addAction(deleteAction)
        alertController.addAction(CancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    /*
     [action] => deletaccount
     [userId] => 74
     [accountId] => 70
     */
    
    // MARK:- LIST OF BANKS
    @objc func deleteProcessingCard(bankAccountId:Int) {
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
           
        /*
         [action] => listcard
         [userId] => 74
         [type] => DEBIT
         */
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
                   parameters = [
                       "action" : "deletaccount",
                    "userId"   : String(myString),
                    "accountId"   : bankAccountId
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
                                /*
                                 
                                 */
                               
                               var strSuccess : String!
                               strSuccess = JSON["status"]as Any as? String
                               
                               var strSuccessAlert : String!
                               strSuccessAlert = JSON["msg"]as Any as? String
                               
                               if strSuccess == "success" //true
                               {
                                
                                var ar : NSArray!
                                ar = (JSON["data"] as! Array<Any>) as NSArray
                                self.arrListOfAllCards = (ar as! Array<Any>)
                                
                                self.tbleView.delegate = self
                                self.tbleView.dataSource = self
                                self.tbleView .reloadData()
                                //self.arrListOfAllCards = self.arrListOfSavedCards
                                
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
        
    }
        
    }


    extension BankAccount: UITableViewDelegate
    {
        
    }
