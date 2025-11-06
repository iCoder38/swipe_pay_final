//
//  OrderedCardList.swift
//  Swipe
//
//  Created by evs_SSD on 1/17/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import CRNotifications

class OrderedCardList: UIViewController {
    
    let cellReuseIdentifier = "orderedCardListTableCell"
       
    // var arrListOfOrderedCard:Array<Any>!
    
    var arr_list_of_all_ordered_cards:NSMutableArray! = []
    
    var page : Int! = 1
    var loadMore : Int! = 1;
    
    @IBOutlet weak var navigationBar:UIView! {
           didSet {
               // navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
           }
       }
       
       @IBOutlet weak var lblNavigationTitle:UILabel! {
           didSet {
               lblNavigationTitle.text = "ORDERED CARD"
               lblNavigationTitle.textColor = .white
           }
       }
       
    @IBOutlet weak var btnBack:UIButton!
    
    @IBOutlet weak var tbleView: UITableView! {
            didSet
            {
                // tbleView.delegate = self
                // tbleView.dataSource = self
                self.tbleView.backgroundColor = .white
                self.tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))

            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBack.setImage(UIImage(named: "menuWhite"), for: .normal)
        sideBarMenu()
        
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
        self.orderedCardList(pageNumber: 1)
    }
    @objc func sideBarMenu() {
        if revealViewController() != nil {
        btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
        revealViewController().rearViewRevealWidth = 300
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
                    
                    
                        self.orderedCardList(pageNumber: page)
                    
                    
                }
            }
        }
    }
    
    // MARK:- ORDERED CARD LIST
    @objc func orderedCardList(pageNumber:Int) {
           
           
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
         [action] => requestcardlist
         [userId] => 74
         [pageNo] => 0
         [type] => DEBIT
         */
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
                   parameters = [
                       "action"     : "requestcardlist",
                        "userId"    : String(myString),
                        
                        "type"      : "DEBIT",
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
                                   var ar : NSArray!
                                   ar = (JSON["data"] as! Array<Any>) as NSArray
                                   // self.arrListOfOrderedCard = (ar as! Array<Any>)
                                   self.arr_list_of_all_ordered_cards.addObjects(from: ar as! [Any])
                                   
                                self.tbleView.delegate = self
                                self.tbleView.dataSource = self
                                
                                self.tbleView.reloadData()
                                   self.loadMore = 1
                                   
                                ERProgressHud.sharedInstance.hide()
                               }
                               else
                               {
                               
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


extension OrderedCardList: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_list_of_all_ordered_cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:OrderedCardListTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! OrderedCardListTableCell
        
        cell.backgroundColor = .white
        
        let item = self.arr_list_of_all_ordered_cards[indexPath.row] as? [String:Any]
        
        /*
         accountName = "";
         accountNo = 123456789;
         address = "";
         amount = "";
         cardId = 40;
         created = "Jan 17th, 2020, 4:37 pm";
         email = "a@gmail.com";
         giftForImage = "";
         giftForName = "";
         imageOnCard = "";
         nameOnCard = "";
         occasion = "";
         phoneNo = 675437678;
         postalcode = "";
         state = "";
         status = 0;
         type = DEBIT;
         userImage = "http://demo2.evirtualservices.com/swiipe/site/img/uploads/users/1576134757images(8).jpeg";
         userName = purnima2;
         */
        
        /*
         @IBOutlet weak var imgCard:UIImageView!
         
         @IBOutlet weak var lblBankName:UILabel!
         @IBOutlet weak var lblAccountNumber:UILabel!
         @IBOutlet weak var lblProcessing:UILabel!
         @IBOutlet weak var lblCreated:UILabel!
         */
        
        // (item!["created"] as! String)
        
        cell.lblBankName.text = (item!["nameOnCard"] as! String)
        
        cell.lblAccountNumber.text = (item!["accountNo"] as! String)
        
        cell.lblProcessing.text = "Processing"
        cell.lblProcessing.textColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
        
        cell.lblCreated.text = (item!["created"] as! String)
        
        cell.imgCard.sd_setImage(with: URL(string: (item!["userImage"] as! String)), placeholderImage: UIImage(named: "card")) // my profile image
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
    }
    @objc func deleteCard(_ sender:UIButton) {
        // print(sender.tag)
        
        // let item = arrListOfOrderedCard[sender.tag] as? [String:Any]
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // MARK:- DELETE CARDS
    @objc func deleteCardsWB(cardId:Int) {
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
         [action] => deletcard
         [userId] => 74
         [cardId] => 77
         */
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
                   parameters = [
                       "action"     : "deletcard",
                        "userId"    : String(myString),
                        "cardId"    : cardId
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

                                CRNotifications.showNotification(type: CRNotifications.success, title: "Success!", message:strSuccessAlert, dismissDelay: 1.5, completion:{})
                                
                                // ERProgressHud.sharedInstance.hide()
 
                               }
                               else
                               {
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

extension OrderedCardList: UITableViewDelegate {
    
}

