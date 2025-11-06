//
//  SendMoney.swift
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

// for send message from application
import MessageUI

// for fetching contacts from phone
import Foundation
import ContactsUI

import Contacts

class SendMoney: UIViewController, MFMessageComposeViewControllerDelegate,UITableViewDelegate,UITableViewDataSource, CNContactViewControllerDelegate {
    
    
    
    var arr_list_of_all_users:NSMutableArray! = []
    var page : Int! = 1
    var loadMore : Int! = 1;
    
    
    
    let cellReuseIdentifier = "sendMoneyTableCell"
    
    // var arrListOfUsers:Array<Any>!
    
    var objects  = [CNContact]()
    
    var removePlusFromNavigation:String!
    
    // mutable array
    var ary_mutable = NSMutableArray()
    var addContactArray = NSMutableArray()
    
    var addAllArray = NSMutableArray()
    
    var thirdArray = NSMutableArray()
    
    var searchArrayStr:String!
    
    var strCheckSearchArray:String!
    
    @IBOutlet weak var btnContact:UIButton!
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            
            lblNavigationTitle.textColor = .white
            lblNavigationTitle.text = "SEND MONEY"
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        strCheckSearchArray = "0"
        
        
        
        
        if let myLoadedString = UserDefaults.standard.string(forKey: "noPlus") {
            print(myLoadedString) // hidePlus
            if myLoadedString == "hidePlus" {
                btnContact.isHidden = true
            } else {
                btnContact.isHidden = false
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
            // lblNavigationTitle.text = "REQUEST MONEY"
        }
        else {
            navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
            // self.view.backgroundColor = BUTTON_BACKGROUND_COLOR_BLUE
            // lblNavigationTitle.text = "SEND MONEY"
        }
        
        btnSearch.addTarget(self, action: #selector(searchUsers), for: .touchUpInside)
        
        // getContacts()
        
        btnContact.addTarget(self, action: #selector(showNewContactViewController), for: .touchUpInside)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        searchArrayStr = "0"
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            // let x : NSNumber = person["wallet"] as! NSNumber
            // self.lblTotalAmountInWallet.text = "$ "+"\(x)"
            
            let x : Double = person["wallet"] as! Double
            let foo = x.rounded(digits: 2)
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
        else
        {
            // session expired. Please logout.
        }
        
        if removePlusFromNavigation == "1" {
            // personal
            btnContact.isHidden = true
        } else {
            // business
            btnContact.isHidden = false
            
        }
        
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
            else {
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
                self.btnContact.isHidden = true
                self.usersListWBForPesonal()
            } else {
                // business
                self.btnContact.isHidden = false
                self.usersListWB(pageNumber: 1)
            }
            
        })
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK:- USERS LIST
    @objc func searchUsersListWB(strSearchKeyWord:String) {
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
                        // self.arrListOfUsers = (ar as! Array<Any>)
                        self.arr_list_of_all_users.addObjects(from: ar as! [Any])
                        // print(self.arrListOfUsers as Any)
                        
                        
                        
                        
                        
                        /*
                         if let myString = defaults.string(forKey: "keyFirstTime") {
                         if myString == "firstTime" {
                         self.ary_mutable.addObjects(from: self.arrListOfUsers)
                         // print(self.ary_mutable as Any)
                         
                         defaults.set("firstTime2", forKey: "keyFirstTime")
                         
                         self.thirdArray.addObjects(from: self.ary_mutable.addingObjects(from: self.objects) as [AnyObject])
                         
                         // print(self.thirdArray as Any)
                         
                         
                         
                         
                         
                         
                         
                         
                         }
                         else {
                         print("second time")
                         }
                         }
                         
                         
                         
                         
                         
                         
                         
                         
                         */
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
                
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
                        self.arr_list_of_all_users.addObjects(from: ar as! [Any])
                        // print(self.arrListOfUsers as Any)
                        
                        
                        
                        
                        
                        
                        if let myString = defaults.string(forKey: "keyFirstTime") {
                            if myString == "firstTime" {
                                self.ary_mutable.addObjects(from: self.arr_list_of_all_users as! [Any])
                                // print(self.ary_mutable as Any)
                                
                                defaults.set("firstTime2", forKey: "keyFirstTime")
                                
                                self.thirdArray.addObjects(from: self.ary_mutable.addingObjects(from: self.objects) as [AnyObject])
                                
                                // print(self.thirdArray as Any)
                                
                                
                                
                                
                                
                                
                                
                                
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
    @objc func usersListWBForPesonal() {
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
                "requestType"    : "",
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
                        
                        let defaults = UserDefaults.standard
                        
                        var ar : NSArray!
                        ar = (JSON["data"] as! Array<Any>) as NSArray
                        // self.arrListOfUsers = (ar as! Array<Any>)
                        self.arr_list_of_all_users.addObjects(from: ar as! [Any])
                        // print(self.arrListOfUsers as Any)
                        
                        
                        
                        
                        
                        
                        if let myString = defaults.string(forKey: "keyFirstTime") {
                            if myString == "firstTime" {
                                self.ary_mutable.addObjects(from: self.arr_list_of_all_users as! [Any])
                                // print(self.ary_mutable as Any)
                                
                                defaults.set("firstTime2", forKey: "keyFirstTime")
                                
                                self.thirdArray.addObjects(from: self.ary_mutable.addingObjects(from: self.objects) as [AnyObject])
                                
                                // print(self.thirdArray as Any)
                                
                                
                                
                                
                                
                                
                                
                                
                            }
                            else {
                                print("second time")
                            }
                        }
                        
                        
                        
                        
                        
                        
                        
                        
                        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  searchArrayStr == "1" {
            return self.arr_list_of_all_users.count
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
            let contact = self.arr_list_of_all_users[indexPath.row]
            let fbemail = ((contact as AnyObject)["userName"]! as? String ?? "")
            cell.PersonNameLabel.text = fbemail
            
            let imagee = ((contact as AnyObject)["userImage"]! as? String ?? "")
            
            cell.PersonImage.sd_setImage(with: URL(string: imagee), placeholderImage: UIImage(named: "avatar")) // my profile image
            
            let phoneNumberIs = ((contact as AnyObject)["contactNumber"]! as? String ?? "")
            cell.PersonMobileNOLabel.text = phoneNumberIs
            
            
            cell.imgs.image = UIImage(named:"rightArrow")
            
        }
        else {
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
                
            }
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        let defaults = UserDefaults.standard
        let userName = defaults.string(forKey: "KeyLoginPersonal")
        if userName == "loginViaPersonal" {
            if self.strCheckSearchArray == "1" {
                let contact2 = self.arr_list_of_all_users[indexPath.row]
                let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProceedToPayId") as? ProceedToPay
                self.strCheckSearchArray = "0"
                // settingsVCId!.strRequestOrPay = "req"
                settingsVCId!.dictGetSendMoneyUserDetails = (contact2 as! NSDictionary)
                self.navigationController?.pushViewController(settingsVCId!, animated: true)
            }
            else {
                let contact2 = self.thirdArray[indexPath.row]
                
                if contact2 is Dictionary<AnyHashable,Any> {
                    print("Yes, it's a Dictionary")
                    let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProceedToPayId") as? ProceedToPay
                    self.strCheckSearchArray = "0"
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
        else {
            if self.strCheckSearchArray == "1" {
                let contact2 = self.arr_list_of_all_users[indexPath.row]
                let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProceedToPayId") as? ProceedToPay
                self.strCheckSearchArray = "0"
                settingsVCId!.dictGetSendMoneyUserDetails = (contact2 as! NSDictionary)
                self.navigationController?.pushViewController(settingsVCId!, animated: true)
            }
            else {
                let contact2 = self.thirdArray[indexPath.row]
                
                if contact2 is Dictionary<AnyHashable,Any> {
                    print("Yes, it's a Dictionary")
                    let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProceedToPayId") as? ProceedToPay
                    self.strCheckSearchArray = "0"
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
