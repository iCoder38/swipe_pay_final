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

    var page : Int! = 1
    var loadMore : Int! = 1;
    
    let cellReuseIdentifier = "allTransactionTableCell"
    
    // array list
    // var arrListOfAllTransaction:Array<Any>!
    
    var arr_list_of_all_transactions:NSMutableArray! = []
    
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
        
        self.allTransactionWB(pageNumber: 1)
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
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
                
        if scrollView == self.tbleView {
            let isReachingEnd = scrollView.contentOffset.y >= 0
                && scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)
            if(isReachingEnd) {
                if(loadMore == 1) {
                    loadMore = 0
                    page += 1
                    print(page as Any)
                    
                    
                        self.allTransactionWB(pageNumber: page)
                    
                    
                }
            }
        }
    }
    
    //MARK:- ALL TRANSACTION
    @objc func allTransactionWB(pageNumber:Int) {
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
                       "userId"        : String(myString),
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
                                    print(JSON)
                               
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
                                   self.arr_list_of_all_transactions.addObjects(from: ar as! [Any])
                                   
                                // self.arrListOfAllTransaction = (ar as! Array<Any>)
                                   // arr_list_of_all_transactions
                                   
                                   
                                   
                                self.tbleView.delegate = self
                                self.tbleView.dataSource = self
                                self.tbleView.reloadData()
                                   self.loadMore = 1
                                   
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
        return self.arr_list_of_all_transactions.count
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
        
        
        
        
        
        let item = arr_list_of_all_transactions[indexPath.row] as? [String:Any]
        print(item as Any)
        
        cell.lblAccountNumber.text = (item!["created"] as! String)
        
        cell.lblMyFirstLetterIs.isHidden = true
        
        if (item!["type"] as! String) == "ADD" {
            cell.lblAmount.text = "+ $ "+((item?["amount"] as? String)!)
            cell.lblAmount.textColor = .systemGreen
            
            // bank name
            cell.lblBankName.text = "My Wallet"
            
            // my image
            // image
             cell.imgProfilePicture.sd_setImage(with: URL(string: (item!["senderImage"] as! String)), placeholderImage: UIImage(named: "avatar"))
            
            cell.imgProfilePicture.backgroundColor = .clear
            
            
            
        } else if (item!["type"] as! String) == "SEND" {
            cell.lblAmount.text = "- $ "+((item?["amount"] as? String)!)
            cell.lblAmount.textColor = .systemRed
            
            // bank name
            cell.lblBankName.text = (item!["receiverName"] as! String)
            
            // image
             cell.imgProfilePicture.sd_setImage(with: URL(string: (item!["receiverImage"] as! String)), placeholderImage: UIImage(named: "avatar"))
            
            cell.imgProfilePicture.backgroundColor = .clear
            
        } else if (item!["type"] as! String) == "CardProcess" {
            
            cell.lblAmount.text = "+ $ "+((item?["amount"] as? String)!)
            cell.lblAmount.textColor = .systemTeal
            
            // bank name
            cell.lblBankName.text = ((item?["nameOnCard"] as? String)!)
            // cell.lblBankName.textColor = .systemTeal
            
            // image
             cell.imgProfilePicture.sd_setImage(with: URL(string: (item!["senderImage"] as! String)), placeholderImage: UIImage(named: "avatar"))
            
            cell.imgProfilePicture.backgroundColor = .clear
        } else if (item!["type"] as! String) == "CASHOUT" {
            
            cell.lblAmount.text = "- $ "+((item?["amount"] as? String)!)
            cell.lblAmount.textColor = .red
            
            // bank name
            cell.lblBankName.text = ((item?["type"] as? String)!)
            // cell.lblBankName.textColor = .systemTeal
            
            // image
             cell.imgProfilePicture.sd_setImage(with: URL(string: (item!["senderImage"] as! String)), placeholderImage: UIImage(named: "avatar"))
            
            cell.imgProfilePicture.backgroundColor = .clear
        }
        
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
        
        let item = self.arr_list_of_all_transactions[indexPath.row] as? [String:Any]
        print(item as Any)
        
//        if (item!["type"] as! String) != "CASHOUT" {
            let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TransactionDetailsId") as? TransactionDetails
            settingsVCId!.dictGetClickedTransaction = item as NSDictionary?
            
            if (item!["type"] as! String) == "CardProcess" {
                settingsVCId!.str_select_profile = "yes"
            }
            
            self.navigationController?.pushViewController(settingsVCId!, animated: true)
//        }
        
        
    }
    
    @objc func pushToPageTransactionDetails() {
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TransactionDetailsId") as? TransactionDetails
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
    }
    
}


extension AllTransaction: UITableViewDelegate
{
    
}
