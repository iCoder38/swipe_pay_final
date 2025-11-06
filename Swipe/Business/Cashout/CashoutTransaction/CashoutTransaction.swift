//
//  CashoutTransaction.swift
//  Swipe
//
//  Created by evs_SSD on 1/16/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import CRNotifications

class CashoutTransaction: UIViewController {

    let cellReuseIdentifier = "cashoutTransactionTableCell"
    
    // var arrListOfAllTransaction:Array<Any>!
    
    var arr_list_of_all_cashout_transaction:NSMutableArray! = []
    
    var page : Int! = 1
    var loadMore : Int! = 1;
    
    @IBOutlet weak var navigationBar:UIView! {
           didSet {
               navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
           }
       }
    
       @IBOutlet weak var lblNavigationTitle:UILabel! {
           didSet {
               lblNavigationTitle.text = "CASHOUT TRANSACTION"
               lblNavigationTitle.textColor = .white
           }
       }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            //btnBack.setTitleColor(BUTTON_BACKGROUND_COLOR_BLUE, for: .normal)
            // btnBack.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var tbleView: UITableView! {
            didSet
            {
                // tbleView.delegate = self
                // tbleView.dataSource = self
                self.tbleView.backgroundColor = .clear
                self.tbleView.separatorStyle = UITableViewCell.SeparatorStyle.none
            }
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
         self.view.backgroundColor = .white
         
         self.sideBarMenuClick()
         
        self.cashoutTransactionWB(pageNumber: 1)
        
         if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
         {
             let livingArea = person["wallet"] as? Int ?? 0
             if livingArea == 0 {
                let stringValue = String(livingArea)
                print(stringValue)
             }
             else
             {
                let stringValue = String(livingArea)
                print(stringValue)
             }
         }
         else
         {
             // 0
         }
         
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
        
         // btnOpenBankList
         
     }
     
     @objc func backClick() {
         self.navigationController?.popViewController(animated: true)
     }
     
     override var preferredStatusBarStyle: UIStatusBarStyle {
         return .lightContent
     }
     
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(true)
         self.navigationController?.setNavigationBarHidden(true, animated: true)
     }
     
    @objc func sideBarMenuClick() {
           
           self.view.endEditing(true)
           
           if revealViewController() != nil {
           btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
           
               revealViewController().rearViewRevealWidth = 300
               view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
             }
       }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
                
        if scrollView == self.tbleView {
            let isReachingEnd = scrollView.contentOffset.y >= 0
                && scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)
            if(isReachingEnd) {
                if(loadMore == 1) {
                    loadMore = 0
                    page += 1
                    print(page as Any)
                    
                    
                        self.cashoutTransactionWB(pageNumber: page)
                    
                    
                }
            }
        }
    }
    
    
    //MARK:- CASH OUT TRANSACTION
    @objc func cashoutTransactionWB(pageNumber:Int) {
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
                    "action"         : "cashoutlist",
                    "userId"         : String(myString),
                    "pageNo"    : pageNumber,
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
                                
                                
                                var ar : NSArray!
                                ar = (JSON["data"] as! Array<Any>) as NSArray
                                // self.arrListOfAllTransaction = (ar as! Array<Any>)
                                   self.arr_list_of_all_cashout_transaction.addObjects(from: ar as! [Any])
                                   
                                ERProgressHud.sharedInstance.hide()
                                
                                self.tbleView.delegate = self
                                self.tbleView.dataSource = self
                                   self.loadMore = 1
                                   
                                self.tbleView.reloadData()
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

extension CashoutTransaction: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
         return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_list_of_all_cashout_transaction.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CashoutTransactionTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! CashoutTransactionTableCell
        
        cell.backgroundColor = .clear
        
        /*
         /*
         amount = 1;
         balanceReceiver = 155;
         balanceSender = 155;
         created = "Jan 16th, 2020, 2:29 pm";
         receiverId = 74;
         receiverImage = "http://demo2.evirtualservices.com/swiipe/site/img/uploads/users/1576134757images(8).jpeg";
         receiverName = purnima;
         senderId = 74;
         senderImage = "http://demo2.evirtualservices.com/swiipe/site/img/uploads/users/1576134757images(8).jpeg";
         senderName = purnima;
         transactionsId = 252;
         type = CASHOUT;
         */
         
         */
        let item = self.arr_list_of_all_cashout_transaction[indexPath.row] as? [String:Any]
        
        cell.lblTitle.text  = "Cashout"//(item!["senderName"] as! String)
        cell.lblSubTitle.text = (item!["created"] as! String)
        
        let str:String = (item!["amount"] as! String)
        if str == "" {
            cell.lblAmount.text = "-$ 0"
        }
        else {
            cell.lblAmount.text = "-$ "+str
        }
        
        
        cell.lblAmount.textColor = .systemRed
        cell.img.backgroundColor = .clear
        
        /*
        let livingArea = item?["amount"] as? Int ?? 0
        if livingArea == 0 {
            let stringValue = String(livingArea)
            cell.lblAmount.text = "- $ "+stringValue
            cell.lblAmount.textColor = .systemRed
            
            
           let string = "Cashout"
           let first4 = string.prefix(1)
           let value = String(first4.uppercased())
           cell.lblMyFirstLetterIs.text = value
           cell.lblMyFirstLetterIs.backgroundColor = .clear
           cell.lblMyFirstLetterIs.layer.cornerRadius = 30
           cell.lblMyFirstLetterIs.clipsToBounds = true
           cell.lblMyFirstLetterIs.textAlignment = .center
           cell.lblMyFirstLetterIs.backgroundColor = .systemTeal
           
           cell.img.backgroundColor = .clear
            
        }
        else {
            let stringValue = String(livingArea)
            cell.lblAmount.text = "- $ "+stringValue
            cell.lblAmount.textColor = .systemRed
            
          let string = "Cashout"
          let first4 = string.prefix(1)
          let value = String(first4.uppercased())
          cell.lblMyFirstLetterIs.text = value
          cell.lblMyFirstLetterIs.backgroundColor = .clear
          cell.lblMyFirstLetterIs.layer.cornerRadius = 30
          cell.lblMyFirstLetterIs.clipsToBounds = true
          cell.lblMyFirstLetterIs.textAlignment = .center
          cell.lblMyFirstLetterIs.backgroundColor = .systemTeal
          
          cell.img.backgroundColor = .clear
            
        }
        */
         cell.img.sd_setImage(with: URL(string: (item!["senderImage"] as! String)), placeholderImage: UIImage(named: "avatar"))
        
        return cell
           
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        let item = self.arr_list_of_all_cashout_transaction[indexPath.row] as? [String:Any]
        
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TransactionDetailsId") as? TransactionDetails
        settingsVCId!.dictGetClickedTransaction = item as NSDictionary?
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
    
}


extension CashoutTransaction: UITableViewDelegate
{
    
}
