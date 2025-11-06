//
//  AddNewGiftCard.swift
//  Swipe
//
//  Created by evs_SSD on 2/19/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import CRNotifications

import BottomPopup

class AddNewGiftCard: UIViewController {
    
    let cellReuseIdentifier = "addNewGiftCardTableCell"
    
    var arrListOfOrderedCard:Array<Any>!
    
    var sendToId:String!
    
    // bottom view popup
    var height: CGFloat = 650 // height
    var topCornerRadius: CGFloat = 35 // corner
    var presentDuration: Double = 0.8 // present view time
    var dismissDuration: Double = 0.5 // dismiss view time
    let kHeightMaxValue: CGFloat = 600 // maximum height
    let kTopCornerRadiusMaxValue: CGFloat = 35 //
    let kPresentDurationMaxValue = 3.0
    let kDismissDurationMaxValue = 3.0
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "ADD GIFT CARD"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var btnBack:UIButton!
    
    @IBOutlet weak var btnAdd:UIButton!
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            self.tbleView.delegate = self
            self.tbleView.dataSource = self
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
        // allUsersWB()
        
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
        
        if let person_2 = UserDefaults.standard.value(forKey: "key_save_total_users") as? [String:Any] {
            
            print(person_2 as Any)
            
            let indexPath = IndexPath.init(row: 0, section: 0)
            let cell = self.tbleView.cellForRow(at: indexPath) as! AddNewGiftCardTableCell
            
            cell.txtSelectUser.text = (person_2["userName"] as! String)
            
            
            
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func validationBeforeSubmitCardWB() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! AddNewGiftCardTableCell
        
        if cell.txtSelectUser.text == "" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Please select an User.", dismissDelay: 1.5, completion:{})
            ERProgressHud.sharedInstance.hide()
        }
        else
        if cell.txtOccasion.text == "" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Occasion field should not be empty.", dismissDelay: 1.5, completion:{})
            ERProgressHud.sharedInstance.hide()
        }
        else
        if cell.txtGiftAmount.text == "" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Gift amount should not be empty.", dismissDelay: 1.5, completion:{})
            ERProgressHud.sharedInstance.hide()
        }
        else
        if cell.txtAddress.text == "" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Address should not be empty.", dismissDelay: 1.5, completion:{})
            ERProgressHud.sharedInstance.hide()
        }
        else
        if cell.txtState.text == "" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"State should not be empty.", dismissDelay: 1.5, completion:{})
            ERProgressHud.sharedInstance.hide()
        }
        else
        if cell.txtPostalCode.text == "" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Postal Code should not be empty.", dismissDelay: 1.5, completion:{})
            ERProgressHud.sharedInstance.hide()
        }
        else {
            addGiftCardWB()
        }
    }
    @objc func addGiftCardWB() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! AddNewGiftCardTableCell
        
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
            
            if let person_2 = UserDefaults.standard.value(forKey: "key_save_total_users") as? [String:Any] {
                
                print(person_2 as Any)
                
                
                let x : Int = (person["userId"] as! Int)
                let myString = String(x)
                /*
                 [action] => requestcard
                 [userId] => 38
                 [giftFor] => 5
                 [occasion] => hi
                 [amount] => 100.855
                 [address] => t
                 [state] => rfg
                 [postalcode] => qwr
                 [type] => GIFT
                 */
                
                parameters = [
                    "action"     : "requestcard",
                    "userId"    : String(myString),
                    "giftFor"   : "\(person_2["userId"]!)",
                    "occasion"  : String(cell.txtOccasion.text!),
                    "amount"    : String(cell.txtGiftAmount.text!),
                    "address"   : String(cell.txtAddress.text!),
                    "state"     : String(cell.txtState.text!),
                    "postalcode"    : String(cell.txtPostalCode.text!),
                    "type"      : "GIFT"
                ]
                
                
                
            }
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
                        // var ar : NSArray!
                        // ar = (JSON["data"] as! Array<Any>) as NSArray
                        // self.arrListOfOrderedCard = (ar as! Array<Any>)
                        
                        // self.tbleView.delegate = self
                        // self.tbleView.dataSource = self
                        
                        // self.tbleView.reloadData()
                        self.navigationController?.popViewController(animated: true)
                        ERProgressHud.sharedInstance.hide()
                        
                        let defaults = UserDefaults.standard
                        defaults.set("", forKey: "key_save_total_users")
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
    
    
    @objc func allUsersWB() {
        
        
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
                "action"     : "userlist",
                "userId"    : String(myString),
                "pageNo"     : "",
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
                        self.arrListOfOrderedCard = (ar as! Array<Any>)
                        
                        self.tbleView.delegate = self
                        self.tbleView.dataSource = self
                        
                        self.tbleView.reloadData()
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

extension AddNewGiftCard: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1//arrListOfOrderedCard.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:AddNewGiftCardTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! AddNewGiftCardTableCell
        
        cell.backgroundColor = .white
        
        
        //
        cell.btnSelectUser.addTarget(self, action: #selector(selectUserClick), for: .touchUpInside)
        
        cell.btnGiftCard.addTarget(self, action: #selector(validationBeforeSubmitCardWB), for: .touchUpInside)
        
        return cell
    }
    
    @objc func selectUserClick() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "total_users_list_id") as? total_users_list
        self.navigationController?.pushViewController(push!, animated: true)
        
        /*guard let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "secondVC") as? ExamplePopupViewController else { return }
         popupVC.height = self.height
         popupVC.topCornerRadius = self.topCornerRadius
         popupVC.presentDuration = self.presentDuration
         popupVC.dismissDuration = self.dismissDuration
         //popupVC.shouldDismissInteractivelty = dismissInteractivelySwitch.isOn
         popupVC.popupDelegate = self
         popupVC.strGetDetails = "addNewGiftSelectUsers"
         //popupVC.getArrListOfCategory =
         popupVC.arrTotalUser = self.arrListOfOrderedCard as NSArray?
         self.present(popupVC, animated: true, completion: nil)*/
    }
    
    @objc func deleteCard(_ sender:UIButton) {
        // print(sender.tag)
        
        // let item = arrListOfOrderedCard[sender.tag] as? [String:Any]
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1000
    }
}


extension AddNewGiftCard: UITableViewDelegate {
    
}

extension AddNewGiftCard: BottomPopupDelegate {
    
    func bottomPopupViewLoaded() {
        print("bottomPopupViewLoaded")
    }
    
    func bottomPopupWillAppear() {
        print("bottomPopupWillAppear")
    }
    
    func bottomPopupDidAppear() {
        print("bottomPopupDidAppear")
    }
    
    func bottomPopupWillDismiss() {
        print("bottomPopupWillDismiss")
        // one
    }
    
    func bottomPopupDidDismiss() {
        print("bottomPopupDidDismiss")
        
        // let buttonPosition = sender.convert(CGPoint.zero, to: self.tbleView)
        // let indexPath = self.tbleView.indexPathForRow(at:buttonPosition)
        // let cell = self.tbleView.cellForRow(at: indexPath!) as! EditProfileTableCell
        
        // card details
        if let person = UserDefaults.standard.value(forKey: "keyDoneSelectingUser") as? [String:Any]
        {
            // print(person as Any)
            
            /*
             ["contactNumber": 1111111111, "userId": 31, "deviceToken": , "userName": Pradeep Bamola, "userN": , "userImage": http://demo2.evirtualservices.com/swiipe/site/img/uploads/users/1573199961images(24).jpeg, "activeMode": Yes]
             
             */
            
            
            // Create an STPCardParams instance
            let defaults = UserDefaults.standard
            let userName = defaults.string(forKey: "KeyLoginPersonal")
            if userName == "loginViaPersonal" {
                // personal user
                // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
                
            }
            else {
                // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            }
            
            let indexPath = IndexPath.init(row: 0, section: 0)
            let cell = self.tbleView.cellForRow(at: indexPath) as! AddNewGiftCardTableCell
            
            cell.txtSelectUser.text = (person["userName"] as! String)
            
            
            // let x : Int = (person["cardId"] as! Int)
            // let myString = String(x)
            // print(myString as Any)
            
            
            let y : Int = (person["userId"] as! Int)
            let myStringy = String(y)
            // print(myStringy as Any)
            sendToId = String(myStringy)
            
            
            
            
            
            
            // let defaults = UserDefaults.standard
            defaults.set("", forKey: "keyDoneSelectingUser")
            defaults.set(nil, forKey: "keyDoneSelectingUser")
            
        }
        else
        {
            print("Never went to that page.")
        }
        
        
        
        // bank details
        
    }
    
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
        print("bottomPopupDismissInteractionPercentChanged fromValue: \(oldValue) to: \(newValue)")
    }
}
