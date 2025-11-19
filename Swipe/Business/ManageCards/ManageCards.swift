//
//  ManageCards.swift
//  Swipe
//
//  Created by evs_SSD on 1/10/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import CRNotifications

class ManageCards: UIViewController {
    
    let cellReuseIdentifier = "manageCardsTableCell"
    
    // var arrListOfCards:Array<Any>!
    
    var arr_list_of_all_cards:NSMutableArray! = []
    
    var page : Int! = 1
    var loadMore : Int! = 1;
    
    var noDataLabel: UILabel!
    
    @IBOutlet weak var navigationBar:UIView! {
           didSet {
               // navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
           }
       }
       
       @IBOutlet weak var lblNavigationTitle:UILabel! {
           didSet {
               lblNavigationTitle.text = "Manage Cards"
               lblNavigationTitle.textColor = .white
           }
       }
       
    @IBOutlet weak var btnBack:UIButton!
    
    @IBOutlet weak var btnAdd:UIButton!
    
    @IBOutlet weak var btnEditName:UIButton! {
        didSet {
            btnEditName.setTitleColor(.white, for: .normal)
            btnEditName.layer.cornerRadius = 4
            btnEditName.clipsToBounds = true
            // btnEditName.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
        }
    }
    
    @IBOutlet weak var btnDone:UIButton! {
        didSet {
            btnDone.setTitleColor(.white, for: .normal)
            btnDone.layer.cornerRadius = 4
            btnDone.clipsToBounds = true
            // btnDone.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
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

        btnAdd.addTarget(self, action: #selector(addClickMethod), for: .touchUpInside)
         // btnBack.setImage(UIImage(named: "menuWhite"), for: .normal)
         // sideBarMenu()
        
        let defaults = UserDefaults.standard
        if let name = defaults.string(forKey: "keySideBarMenu") {
            // print(name)
            if name == "dSideBar" {
                btnBack.setImage(UIImage(named: "menuWhite"), for: .normal)
                sideBarMenu()
            }
            else {
                btnBack.setImage(UIImage(named: "backs"), for: .normal)
                btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
            }
        }
        else {
            btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
        
        noDataLabel  = UILabel(frame: CGRect(x: 0, y: 0, width: self.tbleView.bounds.size.width, height: self.tbleView.bounds.size.height))

        
        
        
        // let defaults = UserDefaults.standard
        let userName = defaults.string(forKey: "KeyLoginPersonal")
        if userName == "loginViaPersonal" {
            // personal user
            navigationBar.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
            
            // btnDone.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
            // btnEditName.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
        }
        else {
            navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
            
            // btnDone.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
            // btnEditName.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
        }
        
        
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
        
        self.arr_list_of_all_cards.removeAllObjects()
        
        //MARK:- LIST OF CARDS WEBSERVICE CALLS FROM HERE
        self.manageCardList(pageNumber: 1)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @objc func addClickMethod() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddCardId") as? AddCard
        self.navigationController?.pushViewController(push!, animated: true)
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
                    
                    
                        self.manageCardList(pageNumber: page)
                    
                    
                }
            }
        }
    }
    
    // MARK:- MANAGE CARDS LIST WEBSERVICE
    @objc func manageCardList(pageNumber:Int) {
           //
        
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
                       "action"     : "listcard",
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
                                 // print(JSON)
                               
                               var strSuccess : String!
                               strSuccess = JSON["status"]as Any as? String
                               
                               var strSuccessAlert : String!
                               strSuccessAlert = JSON["msg"]as Any as? String
                               
                               if strSuccess == "success" //true
                               {
                                /*
                                 data =     {
                                     
                                 };
                                 msg = "Data save successfully.";
                                 status = success;
                                 */
                                   var ar : NSArray!
                                   ar = (JSON["data"] as! Array<Any>) as NSArray
                                   // self.arrListOfCards = (ar as! Array<Any>)
                                   self.arr_list_of_all_cards.addObjects(from: ar as! [Any])
                                   
                                 //CRNotifications.showNotification(type: CRNotifications.success, title: "Message!", message:strSuccessAlert, dismissDelay: 1.5, completion:{})
                                
                                    // self.loginWBClickMethod()
                                
                                self.noDataLabel.text          = nil
                                self.noDataLabel.textColor     = UIColor.black
                                self.noDataLabel.textAlignment = .center
                                self.tbleView.backgroundView  = self.noDataLabel
                                self.tbleView.separatorStyle  = .none

                                
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
                                
                                self.noDataLabel.text          = "No data available."
                                self.noDataLabel.textColor     = UIColor.black
                                self.noDataLabel.textAlignment = .center
                                self.tbleView.backgroundView  = self.noDataLabel
                                self.tbleView.separatorStyle  = .none
                                
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

extension ManageCards: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arr_list_of_all_cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:ManageCardsTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ManageCardsTableCell
        
        cell.backgroundColor = .white
        
        let item = self.arr_list_of_all_cards[indexPath.row] as? [String:Any]
        /*
         CVV = 245;
         cardId = 32;
         cardNumber = 4242424242424242;
         cardlimit = 1000;
         created = "Dec 4th, 2019, 10:24 am";
         expMon = 7;
         expYear = 24;
         imageOnCard = "";
         modify = "";
         nameOnCard = RAM;
         type = DEBIT;
         userImage = "http://demo2.evirtualservices.com/swiipe/site/img/uploads/users/1576137063Screenshot_2019-11-06-20-05-14.png";
         userName = "Dishant Rajput";
         */
        
        // @IBOutlet weak var img:UIImageView!
        // @IBOutlet weak var lblTitle:UILabel!
        // @IBOutlet weak var lblCard:UILabel!
        
        
        // business image
        cell.img.image = UIImage(named: "cardPlaceholder")
        cell.img.backgroundColor = .clear
        
        // card name
        cell.lblTitle.text = (item!["nameOnCard"] as! String)
        
        // type and last 4 digits of my card
        let myString = String(item!["cardNumber"] as! String)
        let last4 = myString.suffix(4)
        cell.lblCard.text = (item!["type"] as! String)+" - "+last4
        
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(deleteCard), for: .touchUpInside)
        
        return cell
    }
    @objc func deleteCard(_ sender:UIButton) {
        // print(sender.tag)
        
        let item = self.arr_list_of_all_cards[sender.tag] as? [String:Any]
        
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to Delete this card ?"+"\n\n"+"Name: "+(item!["nameOnCard"] as! String)+"\n"+"Number :"+(item!["cardNumber"] as! String), preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            // yes
            self.deleteCardsWB(cardId: (item!["cardId"] as! Int))
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)
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
                                // self.manageCardList()
                                // var ar : NSArray!
                                // ar = (JSON["data"] as! Array<Any>) as NSArray
                                // self.arrListOfCards = (ar as! Array<Any>)
                                
                                self.noDataLabel.text          = nil
                                self.noDataLabel.textColor     = UIColor.black
                                self.noDataLabel.textAlignment = .center
                                self.tbleView.backgroundView  = self.noDataLabel
                                self.tbleView.separatorStyle  = .none

                                CRNotifications.showNotification(type: CRNotifications.success, title: "Success!", message:strSuccessAlert, dismissDelay: 1.5, completion:{})
                                
                                // ERProgressHud.sharedInstance.hide()
                                   self.manageCardList(pageNumber: 1)
                                
                               }
                               else
                               {
                                   // self.indicator.stopAnimating()
                                   // self.enableService()
                                
                                self.noDataLabel.text          = "No data available."
                                self.noDataLabel.textColor     = UIColor.black
                                self.noDataLabel.textAlignment = .center
                                self.tbleView.backgroundView  = self.noDataLabel
                                self.tbleView.separatorStyle  = .none
                                    
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
     
        let item = self.arr_list_of_all_cards[indexPath.row] as? [String:Any]
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditManageCardId") as? EditManageCard
         // push!.strWhoIamEditOrAdd = "editCard"
         push!.dictGetManageCardDetails = item! as NSDictionary
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
}


extension ManageCards: UITableViewDelegate {
    
}

