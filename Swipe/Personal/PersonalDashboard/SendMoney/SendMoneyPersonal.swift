//
//  SendMoneyPersonal.swift
//  Swipe
//
//  Created by evs_SSD on 1/22/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import CRNotifications

// for fetching contacts from phone
import Foundation
import ContactsUI

// for send message from application
import MessageUI

import Contacts

// 
class SendMoneyPersonal: UIViewController,MFMessageComposeViewControllerDelegate,UITableViewDelegate,UITableViewDataSource, CNContactViewControllerDelegate {
    
    var arr_list_of_all_users:NSMutableArray! = []
    
    var page : Int! = 1
    var loadMore : Int! = 1;
    
    let cellReuseIdentifier = "sendMoneyPersonalTableCell"
    
    // var arrListOfUsers:Array<Any>!
    var list_of_all_users:NSMutableArray! = []
    
    // var arrListOfSendReceiveUsers:Array<Any>!
    var arr_list_of_send_receive:NSMutableArray! = []
    
    var objects  = [CNContact]()
    
    var removePlusFromNavigation:String!
    
    // mutable array
    var ary_mutable = NSMutableArray()
    var addContactArray = NSMutableArray()
    
    var addAllArray = NSMutableArray()
    
    var thirdArray = NSMutableArray()
    
    var searchArrayStr:String!
    
    var strCheckSearchArray:String!
    
    var noDataLbl : UILabel?
    
    @IBOutlet weak var btnContact:UIButton!
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            
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
            lblTotalAmountInWallet.textColor = .white
            lblTotalAmountInWallet.backgroundColor = UIColor.init(red: 100.0/255.0, green: 206.0/255.0, blue: 225.0/255.0, alpha: 1)
        }
    }
    
    @IBOutlet weak var btnSearch:UIButton!
    
    @IBOutlet weak var btnPleaseEnterAmount:UIButton! {
        didSet {
            // btnPleaseEnterAmount
        }
    }
    
    @IBOutlet weak var btnBack:UIButton!
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            // tbleView.delegate = self
            // tbleView.dataSource = self
            self.tbleView.backgroundColor = .clear
            self.tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            
        }
    }
    
    @IBOutlet weak var segmentControls:UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        strCheckSearchArray = "0"
        
        
        noDataLbl?.isHidden = true
        
        if let myLoadedString = UserDefaults.standard.string(forKey: "noPlus") {
            print(myLoadedString) // hidePlus
            if myLoadedString == "hidePlus" {
                // btnContact.isHidden = true
            } else {
                // btnContact.isHidden = false
            }
        }
        
        
        UserDefaults.standard.set("", forKey: "noPlus")
        UserDefaults.standard.set(nil, forKey: "noPlus")
        
        
        
        
        
        
        let defaults = UserDefaults.standard
        defaults.set("firstTime", forKey: "keyFirstTime")
        
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
        
        /*
         [action] => contactlist
         [user_id] => 38
         [contact] => [1 234-567-890, 112, 1800-300-1947, 102, 93528 74512, 100, 1977, 198, 139, 199]
         [name] => [test contact, Distress Number, UIDAI, Ambulance, Mona, Police, Jio-Tele-verification Helpline, Jio-Complaint Helpline, Railways, Jio-General Helpline]
         [page] => 0
         */
        
        // let defaults = UserDefaults.standard
        let userName = defaults.string(forKey: "KeyLoginPersonal")
        if userName == "loginViaPersonal" {
            // personal user
            navigationBar.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
            // self.view.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
            lblNavigationTitle.text = "REQUEST MONEY"
        }
        else {
            navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
            // self.view.backgroundColor = BUTTON_BACKGROUND_COLOR_BLUE
            lblNavigationTitle.text = "SEND MONEY"
        }
        
        btnSearch.addTarget(self, action: #selector(searchUsers), for: .touchUpInside)
        
        // getContacts()
        
        // btnContact.addTarget(self, action: #selector(showNewContactViewController), for: .touchUpInside)
        
        self.segmentControls.addTarget(self, action: #selector(segmentControlClickMethod), for: .valueChanged)
    }
    @objc func segmentControlClickMethod() {
        if segmentControls.selectedSegmentIndex == 0 {
            
            self.page = 1
            self.arr_list_of_all_users.removeAllObjects()
            self.usersListWB(pageNumber: 1)
            
        } else if segmentControls.selectedSegmentIndex == 1 {
            
            self.page = 1
            self.arr_list_of_send_receive.removeAllObjects()
            self.usersListWBForSendOrReceive(pageNumber: 1, strSendOrReceive: "SEND", strForCell: "8")
            
        } else if segmentControls.selectedSegmentIndex == 2 {
            
            self.page = 1
            self.arr_list_of_send_receive.removeAllObjects()
            self.usersListWBForSendOrReceive(pageNumber: 1, strSendOrReceive: "RECEIVE", strForCell: "9")
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.segmentControls.selectedSegmentIndex = 0
        
        searchArrayStr = "0"
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Double = person["wallet"] as! Double
            let foo = x.rounded(digits: 2) // 3.142
            self.lblTotalAmountInWallet.text = "$ "+"\(foo)"
            
            /*
             let livingArea = person["wallet"] as? Int ?? 0
             if livingArea == 0 {
             let stringValue = String(livingArea)
             self.lblTotalAmountInWallet.text = "$ "+stringValue+"     "
             }
             else
             {
             let stringValue = String(livingArea)
             self.lblTotalAmountInWallet.text = "$ "+stringValue+"     "
             }
             */
            
        }
        else {
            // session expired. Please logout.
        }
        
        // if removePlusFromNavigation == "1" {
        // personal
        // btnContact.isHidden = true
        // } else {
        // business
        // btnContact.isHidden = false
        
        // }
        
        getContacts()
        
    }
    @objc func showNewContactViewController() {
        let contactViewController: CNContactViewController = CNContactViewController(forNewContact: nil)
        contactViewController.contactStore = CNContactStore()
        contactViewController.delegate = self
        let navigationController: UINavigationController = UINavigationController(rootViewController: contactViewController)
        present(navigationController, animated: true) {
            print("Present")
        }
    }
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        // self.getContacts()
        self.dismiss(animated: true, completion: nil)
        
        self.navigationController?.popViewController(animated: true)
        // self.tbleView.delegate = self
        // self.tbleView.dataSource = self
        // self.tbleView.reloadData()
        // self.getContacts()
        
        
        // self.usersListWB()
    }
    
    @objc func searchUsers() {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Search", message: "", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Search"
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            // self.lblBigAmount.text = "$ "+textField!.text!
            
            if textField!.text! == "" {
                self.usersListWB(pageNumber: 1)
            }
            else
            {
                self.searchUsersListWB(strSearchKeyWord: textField!.text!)
            }
            
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {
            (_) in
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @objc func sideBarMenu() {
        
        if revealViewController() != nil {
            btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    
    
    
    
    
    func getContacts() {
        let store = CNContactStore()
        
        switch CNContactStore.authorizationStatus(for: .contacts){
        case .authorized:
            self.retrieveContactsWithStore(store: store)
            
            // This is the method we will create
        case .notDetermined:
            store.requestAccess(for: .contacts){succeeded, err in
                guard err == nil && succeeded else{
                    return
                }
                self.retrieveContactsWithStore(store: store)
                
            }
        default:
            print("Not handled")
        }
        
    }
    
    @objc func fetchingContactsFromDevice() {
        
        
    }
    
    
    func retrieveContactsWithStore(store: CNContactStore) {
        
        
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey,CNContactImageDataKey, CNContactEmailAddressesKey] as [Any]
        let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
        var cnContacts = [CNContact]()
        do {
            try store.enumerateContacts(with: request){
                (contact, cursor) -> Void in
                if (!contact.phoneNumbers.isEmpty) {
                }
                
                if contact.isKeyAvailable(CNContactImageDataKey) {
                    if let contactImageData = contact.imageData {
                        print(UIImage(data: contactImageData) as Any) // Print the image set on the contact
                    }
                } else {
                    // No Image available
                    
                }
                if (!contact.emailAddresses.isEmpty) {
                    
                }
                
                cnContacts.append(contact)
                self.objects = cnContacts
            }
        } catch let error {
            NSLog("Fetch contact error: \(error)")
        }
        
        NSLog(">>>> Contact list:")
        for contact in cnContacts {
            let fullName = CNContactFormatter.string(from: contact, style: .fullName) ?? "No Name"
            NSLog("\(fullName): \(contact.phoneNumbers.description)")
            
        }
        DispatchQueue.main.async(execute: {
            
            // Handle further UI related operations here....
            //let ad = UIApplication.shared.delegate as! AppDelegate
            //let context = ad.persistentContainer.viewContext
            
            /*
             self.tbleView.delegate = self
             self.tbleView.dataSource = self
             self.tbleView.reloadData()
             */
            
            
            if self.removePlusFromNavigation == "1" {
                // personal
                // self.btnContact.isHidden = true
                self.usersListWB(pageNumber: 1)
            } else {
                // business
                // self.btnContact.isHidden = false
                self.usersListWB(pageNumber: 1)
            }
            
        })
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK:- USERS LIST
    @objc func searchUsersListWB(strSearchKeyWord:String) {
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        self.list_of_all_users.removeAllObjects()
        
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
            
            /*
             [action] => userlist
             [userId] => 74
             [pageNo] => 0action:paymentrequestlist
             */
            parameters = [
                "action"         : "userlist",
                "userId"         : String(myString),
                "pageNo"         : "",
                "keyword"        : String(strSearchKeyWord)
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
                    
                    self.strCheckSearchArray = "1"
                    
                    var strSuccess : String!
                    strSuccess = JSON["status"]as Any as? String
                    
                    var strSuccessAlert : String!
                    strSuccessAlert = JSON["msg"]as Any as? String
                    
                    if strSuccess == "success" //true
                    {
                        ERProgressHud.sharedInstance.hide()
                        
                        self.searchArrayStr = "1"
                        // let defaults = UserDefaults.standard
                        
                        var ar : NSArray!
                        ar = (JSON["data"] as! Array<Any>) as NSArray
                        //self.list_of_all_users = (ar as! Array<Any>)
                        self.list_of_all_users.addObjects(from: ar as! [Any])
                        
                        // print(self.arrListOfUsers as Any)
                        self.searchArrayStr = "1"
                        
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
    
    //MARK:- USERS LIST
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
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            /*
             action: updaterequest
             requestId:
             userId:
             status:  1=Request/ 2=send/ 3=DECLINE
             */
            
            parameters = [
                "action"         : "updaterequest",
                "userId"         : String(myString),
                "requestId"      : String(strRequestId),
                "status"         : String(strStatus)
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
                        
                        
                        // var ar : NSArray!
                        // ar = (JSON["data"] as! Array<Any>) as NSArray
                        // self.arrListOfUsers = (ar as! Array<Any>)
                        
                        // print(self.arrListOfUsers as Any)
                        
                        
                        
                        
                        
                        
                        self.usersListWBForSendOrReceive(pageNumber: 1, strSendOrReceive: "SEND", strForCell: "8")
                        
                        
                        
                        
                        
                        
                        
                        
                        // self.tbleView.delegate = self
                        // self.tbleView.dataSource = self
                        // self.tbleView.reloadData()
                        
                        
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
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(self.searchArrayStr == "1") {
            return
        }
        if self.segmentControls.selectedSegmentIndex == 0 {
            
            if scrollView == self.tbleView {
                let isReachingEnd = scrollView.contentOffset.y >= 0
                    && scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)
                if(isReachingEnd) {
                    if(loadMore == 1) {
                        loadMore = 0
                        page += 1
                        print(page as Any)
                        
                        
                            self.usersListWB(pageNumber: page)
                        
                        
                    }
                }
            }
            
        } else if self.segmentControls.selectedSegmentIndex == 1 {
            
            
            if scrollView == self.tbleView {
                let isReachingEnd = scrollView.contentOffset.y >= 0
                    && scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)
                if(isReachingEnd) {
                    if(loadMore == 1) {
                        loadMore = 0
                        page += 1
                        print(page as Any)
                        
                        
                        self.usersListWBForSendOrReceive(pageNumber: page, strSendOrReceive: "SEND", strForCell: "8")
                        
                        
                    }
                }
            }
            
        } else {
            
            
            if scrollView == self.tbleView {
                let isReachingEnd = scrollView.contentOffset.y >= 0
                    && scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)
                if(isReachingEnd) {
                    if(loadMore == 1) {
                        loadMore = 0
                        page += 1
                        print(page as Any)
                        
                        
                        self.usersListWBForSendOrReceive(pageNumber: page, strSendOrReceive: "RECEIVE", strForCell: "9")
                        
                        
                    }
                }
            }
            
        }
        
    }
    
    //MARK:- USERS LIST
    @objc func usersListWB(pageNumber:Int) {
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
            
            /*
             [action] => userlist
             [userId] => 74
             [pageNo] => 0
             */
            parameters = [
                "action"         : "userlist",
                "userId"         : String(myString),
                "pageNo"         : pageNumber,
                "keyword"        : "" //String(strSearchKeyWord)
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
                        ERProgressHud.sharedInstance.hide()
                        
                        let defaults = UserDefaults.standard
                        
                        var ar : NSArray!
                        ar = (JSON["data"] as! Array<Any>) as NSArray
                        // self.arrListOfUsers = (ar as! Array<Any>)
                        self.list_of_all_users.addObjects(from: ar as! [Any])
                        // print(self.arrListOfUsers as Any)
                        
                        self.searchArrayStr = "1"
                        
                        
                        
                        
                        if let myString = defaults.string(forKey: "keyFirstTime") {
                            if myString == "firstTime" {
                                self.ary_mutable.addObjects(from: self.list_of_all_users as! [Any])
                                
                                defaults.set("firstTime2", forKey: "keyFirstTime")
                                
                                self.thirdArray.addObjects(from: self.ary_mutable.addingObjects(from: self.objects) as [AnyObject])
                                
                            }
                            else {
                                print("second time")
                            }
                        }
                        
                        
                        
                        
                        
                        
                        
                        
                        
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
    
    
    
    
    
    //MARK:- USERS LIST FOR PERSONAL
    @objc func usersListWBForSendOrReceive(pageNumber:Int , strSendOrReceive:String,strForCell:String) {
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
                "pageNo"         : pageNumber
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
                        // self.arrListOfSendReceiveUsers = (ar as! Array<Any>)
                        self.arr_list_of_send_receive.addObjects(from: ar as! [Any])
                        
                        self.searchArrayStr = strForCell
                        
                        // print(self.arrListOfSendReceiveUsers as Any)
                        
                        if self.arr_list_of_send_receive.count > 0 {
                            
                            self.noDataLbl?.isHidden = true
                            self.noDataLbl = UILabel(frame: CGRect(x: 0, y: self.view.center.y, width: 290, height: 70))
                            self.noDataLbl!.removeFromSuperview()
                            self.tbleView.isHidden = false
                            self.tbleView.delegate = self
                            self.tbleView.dataSource = self
                            self.loadMore = 1
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
    
    
    
    
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result) {
        case .cancelled:
            print("Message was cancelled")
            dismiss(animated: true, completion: nil)
        case .failed:
            print("Message failed")
            dismiss(animated: true, completion: nil)
        case .sent:
            print("Message was sent")
            dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    // arrListOfSendReceiveUsers
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  searchArrayStr == "1" {
            return self.list_of_all_users.count
        } else if  searchArrayStr == "8" {
            return self.arr_list_of_send_receive.count
        } else if  searchArrayStr == "9" {
            return self.arr_list_of_send_receive.count
        }
        else {
            return self.thirdArray.count //self.objects.count
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sendMoneyTableCell", for: indexPath as IndexPath) as! SendMoneyTableCell
        
        if searchArrayStr == "1" {
            let contact = self.list_of_all_users[indexPath.row]
            print(contact)
            let fbemail = ((contact as AnyObject)["userName"]! as? String ?? "")
            cell.PersonNameLabel.text = fbemail
            
            let imagee = ((contact as AnyObject)["userImage"]! as? String ?? "")
            
            cell.PersonImage.sd_setImage(with: URL(string: imagee), placeholderImage: UIImage(named: "avatar")) // my profile image
            
            let phoneNumberIs = ((contact as AnyObject)["contactNumber"]! as? String ?? "")
            cell.PersonMobileNOLabel.text = phoneNumberIs
            
            
            cell.imgs.image = UIImage(named:"rightArrow")
            cell.imgs.isHidden = false
            cell.statusLabel.isHidden = true
        }
        else if searchArrayStr == "8" {
            // send
            let contact = self.arr_list_of_send_receive[indexPath.row]
            let fbemail = ((contact as AnyObject)["userName"]! as? String ?? "")+" - $ "+((contact as AnyObject)["amount"]! as? String ?? "")
            cell.PersonNameLabel.text = fbemail
            
            let imagee = ((contact as AnyObject)["userImage"]! as? String ?? "")
            
            cell.PersonImage.sd_setImage(with: URL(string: imagee), placeholderImage: UIImage(named: "avatar")) // my profile image
            
            let phoneNumberIs = ((contact as AnyObject)["contactNumber"]! as? String ?? "")
            cell.PersonMobileNOLabel.text = phoneNumberIs
            
            
            cell.imgs.image = UIImage(named:"rightArrow")
            cell.imgs.isHidden = true
            cell.statusLabel.isHidden = false
            
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
            
        } else if searchArrayStr == "9" {
            // receive
            let contact = self.arr_list_of_send_receive[indexPath.row]
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
            
        } else {
            let contact2 = self.thirdArray[indexPath.row]
            // print(self.thirdArray)
            
            if contact2 is Dictionary<AnyHashable,Any> {
                // print("Yes, it's a Dictionary")
                let fbemail = ((contact2 as AnyObject)["userName"]! as? String ?? "")
                cell.PersonNameLabel.text = fbemail
                
                let imagee = ((contact2 as AnyObject)["userImage"]! as? String ?? "")
                
                cell.PersonImage.sd_setImage(with: URL(string: imagee), placeholderImage: UIImage(named: "avatar")) // my profile image
                
                let phoneNumberIs = ((contact2 as AnyObject)["contactNumber"]! as? String ?? "")
                cell.PersonMobileNOLabel.text = phoneNumberIs
                
                
                cell.imgs.image = UIImage(named:"rightArrow")
                cell.imgs.isHidden = false
                cell.statusLabel.isHidden = true
            }
            else {
                // print("Yes, it's a Contact")
                let formatter = CNContactFormatter()
                cell.PersonNameLabel.text = formatter.string(from: contact2 as! CNContact)
                
                if let actualNumber = (contact2 as AnyObject).phoneNumbers.first?.value {
                    cell.PersonMobileNOLabel.text = actualNumber.stringValue
                }
                else {
                    cell.PersonMobileNOLabel.text = "N.A "
                }
                
                // contact image
                if let imageData = (contact2 as AnyObject).imageData {
                    //If so create the image
                    
                    if imageData == nil {
                        cell.PersonImage.image = UIImage (named: "avatar")
                    }
                    else {
                        let userImage = UIImage(data: imageData!)
                        cell.PersonImage.image = userImage;
                    }
                }
                
                cell.imgs.image = UIImage(named:"normalMessageIcon")
                cell.imgs.isHidden = false
                cell.statusLabel.isHidden = true
            }
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        let defaults = UserDefaults.standard
        let userName = defaults.string(forKey: "KeyLoginPersonal")
        if userName == "loginViaPersonal" {
            print(self.strCheckSearchArray)
            if self.strCheckSearchArray == "1" {
                print(self.list_of_all_users)
                let contact2 = self.list_of_all_users[indexPath.row]
                print(contact2)
                
                let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProceedToPayForRequestId") as? ProceedToPayForRequest
//                self.strCheckSearchArray = "0"
                print(contact2 as Any)
                settingsVCId!.strRequestOrPay = "req"
                settingsVCId!.dictGetSendMoneyUserDetails = (contact2 as! NSDictionary)
                self.navigationController?.pushViewController(settingsVCId!, animated: true)
            }
            else {
                // 7006767992
                if segmentControls.selectedSegmentIndex == 1 {
                    let contact2 = self.arr_list_of_send_receive[indexPath.row]
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
                    if searchArrayStr == "8" {
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
                        
                        
                        
                        alert.addAction(UIAlertAction(title: "Ok",
                                                      style: UIAlertAction.Style.default,
                                                      handler: {(_: UIAlertAction!) in
                            //Sign out action
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                } else if segmentControls.selectedSegmentIndex == 2 {
                    let contact2 = self.arr_list_of_send_receive[indexPath.row]
                    
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
                    
                    if searchArrayStr == "9" {
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
                                self.payOrDeclineWB(strRequestId: REQUESTID, strStatus: "2")
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
                        
                        
                    } // here
                } else {
                    let contact2 = self.thirdArray[indexPath.row]
                    
                    if contact2 is Dictionary<AnyHashable,Any> {
                        print("Yes, it's a Dictionary")
                        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProceedToPayForRequestId") as? ProceedToPayForRequest
                        self.strCheckSearchArray = "0"
                        settingsVCId!.strRequestOrPay = "req"
                        settingsVCId!.dictGetSendMoneyUserDetails = (contact2 as! NSDictionary)
                        self.navigationController?.pushViewController(settingsVCId!, animated: true)
                    }
                    else {
                        // print("Yes, it's a Contact")
                        if let actualNumber = (contact2 as AnyObject).phoneNumbers.first?.value {
                            // cell.PersonMobileNOLabel.text = actualNumber.stringValue
                            
                            let messageVC = MFMessageComposeViewController()
                            messageVC.body = "Custom Message"
                            messageVC.recipients = [actualNumber.stringValue]
                            messageVC.messageComposeDelegate = self
                            self.present(messageVC, animated: true, completion: nil)
                            
                        }
                    }
                    
                }
            }
            
            
            
            
            
            
            
            
            
        }
        else {
            if self.strCheckSearchArray == "1" {
                let contact2 = self.list_of_all_users[indexPath.row]
                let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProceedToPayForRequestId") as? ProceedToPayForRequest
                self.strCheckSearchArray = "0"
                settingsVCId!.strRequestOrPay = "req"
                settingsVCId!.dictGetSendMoneyUserDetails = (contact2 as! NSDictionary)
                self.navigationController?.pushViewController(settingsVCId!, animated: true)
            }
            else {
                let contact2 = self.thirdArray[indexPath.row]
                
                if contact2 is Dictionary<AnyHashable,Any> {
                    print("Yes, it's a Dictionary")
                    let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProceedToPayForRequestId") as? ProceedToPayForRequest
                    self.strCheckSearchArray = "0"
                    settingsVCId!.strRequestOrPay = "req"
                    settingsVCId!.dictGetSendMoneyUserDetails = (contact2 as! NSDictionary)
                    self.navigationController?.pushViewController(settingsVCId!, animated: true)
                }
                else {
                    // print("Yes, it's a Contact")
                    if let actualNumber = (contact2 as AnyObject).phoneNumbers.first?.value {
                        // cell.PersonMobileNOLabel.text = actualNumber.stringValue
                        
                        let messageVC = MFMessageComposeViewController()
                        messageVC.body = "Custom Message"
                        messageVC.recipients = [actualNumber.stringValue]
                        messageVC.messageComposeDelegate = self
                        self.present(messageVC, animated: true, completion: nil)
                        
                    }
                }
                
            }
        }
        
        
        
    }
}
