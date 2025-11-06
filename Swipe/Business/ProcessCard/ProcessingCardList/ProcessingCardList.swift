//
//  ProcessingCardList.swift
//  Swipe
//
//  Created by evs_SSD on 1/15/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import CRNotifications

class ProcessingCardList: UIViewController {
    
    let cellReuseIdentifier = "processingCardListTableCell"
    
    // array list
    var arrListOfProcessingCards:Array<Any>!
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "PROCESSING CARD"
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
        
        self.sideBarMenuClick()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.processingCardListWB()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @objc func sideBarMenuClick() {
        if revealViewController() != nil {
            btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addAccountClickMethod() {
        /*
         let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddProcessCardTwoId") as? AddProcessCardTwo
         self.navigationController?.pushViewController(settingsVCId!, animated: true)
         */
        
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProcessCardPageTwoId") as? ProcessCardPageTwo
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
        
        
        
        
        
        //
    }
    
    //MARK:- PROCESSING CARD LIST
    @objc func processingCardListWB() {
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
                "action"        : "cardprocessinglist",
                "userId"        : String(myString)
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
                        
                        // var strPercentage : String!
                        // strPercentage = JSON["percentage"]as Any as? String
                        // print(strPercentage as Any)
                        // self.strSavePercentage = strPercentage
                        
                        var ar : NSArray!
                        ar = (JSON["data"] as! Array<Any>) as NSArray
                        self.arrListOfProcessingCards = (ar as! Array<Any>)
                        
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

extension ProcessingCardList: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrListOfProcessingCards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:ProcessingCardListTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ProcessingCardListTableCell
        
        cell.backgroundColor = .white
        
        cell.imgCardImage.backgroundColor = .clear
        cell.imgCardImage.layer.cornerRadius = 35
        cell.imgCardImage.clipsToBounds = true
        
        /*
         Amount = 500;
         Phone = 8929963020;
         Total = "";
         TransactionID = "tok_1G1XHHBnk7ygV50quGKzmEDp";
         cardNo = 4242;
         cardprocessingId = 9;
         created = "Jan 16th, 2020, 5:46 pm";
         email = "dishantrajput38@gmail.com";
         expiryMon = "";
         expiryYear = "";
         nameOnCard = "Mobile Gaming iPhone X";
         processingCharge = 3;
         vendorId = 74;
         */
        
        /*
         let last4 = (item!["cardNumber"] as! String).suffix(4)
         cell.lblCardNumber.text = "xxxx xxxx xxxx - "+String(last4)
         */
        
        let item = arrListOfProcessingCards[indexPath.row] as? [String:Any]
        cell.lblTitle.text = (item!["nameOnCard"] as! String)
        cell.lblCreatedAt.text = (item!["created"] as! String)
        cell.lblCardNumber.text = (item!["cardNo"] as! String)
        // print((item!["amount"] as! String))
        
        let string = (item!["nameOnCard"] as! String)
        let first4 = string.prefix(1)
        let value = String(first4.uppercased())
        cell.lblMyFirstLetterIs.text = value
        cell.lblMyFirstLetterIs.backgroundColor = .clear
        cell.lblMyFirstLetterIs.layer.cornerRadius = 35
        cell.lblMyFirstLetterIs.clipsToBounds = true
        cell.lblMyFirstLetterIs.textAlignment = .center
        cell.lblMyFirstLetterIs.backgroundColor = .systemTeal
        
        cell.lblAmount.text = "$ "+(item!["Total"] as! String)
        cell.lblAmount.textColor = .systemGreen
        
        /*
         let livingArea = item!["Total"] as? Int ?? 0
         if livingArea == 0 {
         let stringValue = String(livingArea)
         cell.lblAmount.text = "$ "+stringValue
         cell.lblAmount.textColor = .systemGreen
         }
         else
         {
         let stringValue = String(livingArea)
         cell.lblAmount.text = " $ "+stringValue
         cell.lblAmount.textColor = .systemGreen
         }
         */
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        let item = arrListOfProcessingCards[indexPath.row] as? [String:Any]
        
        let alertController = UIAlertController(title: nil, message: "Settings", preferredStyle: .actionSheet)
        
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
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to delete this card"+"\n\n "+"Name : "+(getSelectedCardDictionary["nameOnCard"] as! String)+" "+"\n "+"Number : "+(getSelectedCardDictionary["cardNo"] as! String), preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive) {
            UIAlertAction in
            /*
             [action] => deleteprocesstransation
             [userId] => 74
             [cardprocessId] => 9
             */
            self.deleteProcessingCard(cardProcessingId: (getSelectedCardDictionary["cardprocessingId"] as! Int))
        }
        let CancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.default) {
            UIAlertAction in
        }
        
        alertController.addAction(deleteAction)
        alertController.addAction(CancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK:- DELETE PROCESSING CARD
    @objc func deleteProcessingCard(cardProcessingId:Int) {
        
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
             [action] => deleteprocesstransation
             [userId] => 74
             [cardprocessId] => 9
             */
            parameters = [
                "action"        : "deleteprocesstransation",
                "userId"        : String(myString),
                "cardprocessId"  : Int(cardProcessingId)
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
                    
                    if strSuccess == "success" //true
                    {
                        ERProgressHud.sharedInstance.hide()
                        CRNotifications.showNotification(type: CRNotifications.success, title: "Success!", message:strSuccessAlert, dismissDelay: 1.5, completion:{})
                        
                        var ar : NSArray!
                        ar = (JSON["data"] as! Array<Any>) as NSArray
                        self.arrListOfProcessingCards = (ar as! Array<Any>)
                        
                        self.tbleView.delegate = self
                        self.tbleView.dataSource = self
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
    
}

extension ProcessingCardList: UITableViewDelegate
{
            
}
