//
//  AddBankAccount.swift
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

import BottomPopup

class AddBankAccount: UIViewController,UITextFieldDelegate {
    
    var arrSelectBank:Array<Any>!// = ["Select Bank", "Bank 1","Bank 2","Bank 3","Bank 4","Bank 5"]
    
    var BankType = ["Current", "Saving"]
    var itemSelected = ""
    
    var pickerView: UIPickerView?
    var pickerViewSection: UIPickerView?
    
    // save ids
    var saveCardId:String!
    var saveBankAccountId:String!
    var saveTransactionId:String!
    
    var saveStripebankAccountNumber:String!
    
    var saveBankAccountIdInInt:Int!
    
    // bottom view popup
    var height: CGFloat = 600 // height
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
            lblNavigationTitle.text = "BANK ACCOUNT"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var btnBottomPopUpSheetOccurs:UIButton!
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
    }
    
    @IBOutlet var txtSelectBank: UITextField! {
        didSet {
            textFieldCustomMethod(textField: txtSelectBank, placeholder: "Select Bank")
        }
    }
    
    @IBOutlet var txtBankAccountNumber: UITextField! {
        didSet {
            txtBankAccountNumber.keyboardType = .numberPad
            textFieldCustomMethod(textField: txtBankAccountNumber, placeholder: "Account Number")
        }
    }
    
    @IBOutlet var txtBranch: UITextField! {
        didSet {
            textFieldCustomMethod(textField: txtBranch, placeholder: "Account Holder Name")
        }
    }
    
    @IBOutlet var txtBranchCode: UITextField! {
        didSet {
            txtBranchCode.keyboardType = .numberPad
            textFieldCustomMethod(textField: txtBranchCode, placeholder: "Branch Code ( Routing Number )")
        }
    }
    
    /*
     @IBOutlet var txtAccountType: UITextField! {
     didSet {
     textFieldCustomMethod(textField: txtAccountType, placeholder: "Accout Type")
     }
     }
     */
    
    @IBOutlet weak var btnAddAccount:UIButton! {
        didSet {
            btnAddAccount.setTitleColor(.white, for: .normal)
            btnAddAccount.setTitle("Add Account", for: .normal)
            btnAddAccount.addTarget(self, action: #selector(addAccountClickMethod), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        
        btnBottomPopUpSheetOccurs.addTarget(self, action: #selector(openBottomSheetClickMethod), for: .touchUpInside)
        
        let defaults = UserDefaults.standard
        let userName = defaults.string(forKey: "KeyLoginPersonal")
        if userName == "loginViaPersonal" {
            // personal user
            navigationBar.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
            btnAddAccount.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
        }
        else {
            navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
            btnAddAccount.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(AddBankAccount.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        txtBranch.delegate = self
        
        self.listOfBankWB()
    }
    
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func openBottomSheetClickMethod() {
        guard let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "secondVC") as? ExamplePopupViewController else { return }
        popupVC.height = self.height
        popupVC.topCornerRadius = self.topCornerRadius
        popupVC.presentDuration = self.presentDuration
        popupVC.dismissDuration = self.dismissDuration
        //popupVC.shouldDismissInteractivelty = dismissInteractivelySwitch.isOn
        popupVC.popupDelegate = self
        popupVC.strGetDetails = "savedBankListOrderCard"
        //popupVC.getArrListOfCategory =
        popupVC.arrListOfBanks = self.arrSelectBank as NSArray?
        self.present(popupVC, animated: true, completion: nil)
    }
    
    @objc func addAccountClickMethod() {
        self.register_this_bank_in_stripe_wb()
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    func textFieldCustomMethod(textField: UITextField,placeholder:String){
        textField.delegate = self
        textField.backgroundColor = .clear
        textField.placeholder = placeholder
        textField.keyboardAppearance = .dark
        textField.layer.cornerRadius = 4
        textField.clipsToBounds = true
        textField.layer.borderColor  = UIColor.darkGray.cgColor
        textField.layer.borderWidth = 0.80
        textField.textAlignment = .left
        textField.textColor = .black
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.font : UIFont(name: "OpenSans-Bold", size: 12)!
        ]
        
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes:attributes)
        
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 2.0))
        textField.leftView = leftView
        textField.leftViewMode = .always
        
    }
    
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
         [action] => banklist
         */
        
        parameters = [
            "action" : "banklist"
        ]
        
        print("parameters-------\(String(describing: parameters))")
        
        Alamofire.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON {
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
                    
                    if strSuccess == "success" {
                        var ar : NSArray!
                        ar = (JSON["data"] as! Array<Any>) as NSArray
                        self.arrSelectBank = (ar as! Array<Any>)
                        ERProgressHud.sharedInstance.hide()
                    }
                    else {
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
    
    
    // MARK:- ADD BANK ACCOUNT
    @objc func addBankAccountWB() {
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
         [action] => addbankaccount
         [userId] => 74
         [accountNumber] => 1452639845421
         [accountName] => Second bank
         [routingNo] => 123
         [bankId] => 3
         */
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            parameters = [
                "action"         : "addbankaccount",
                "userId"         : String(myString),
                "accountNumber"  : String(txtBankAccountNumber.text!),
                "accountName"    : String(txtBranch.text!),
                "routingNo"      : String(txtBranchCode.text!),
                "bankId"         : Int(saveBankAccountIdInInt),
                "stripeBankAccountNo" : String(saveStripebankAccountNumber)
            ]
        }
        print("parameters-------\(String(describing: parameters))")
        
        Alamofire.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON {
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
                    
                    if strSuccess == "success" {
                        ERProgressHud.sharedInstance.hide()
                        
                        CRNotifications.showNotification(type: CRNotifications.success, title: "Success!", message:strSuccessAlert, dismissDelay: 1.5, completion:{})
                        
                        self.navigationController?.popViewController(animated: true)
                        
                    }
                    else {
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
    
    @objc func register_this_bank_in_stripe_wb() {
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let urlString = base_url_create_Stripe_customer
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            parameters = [
                "action"            : "bankaccount",
                "StripeCustomerId"  : (person["stripeCustomerNo"] as! String),
                "accountNumber"     : String(txtBankAccountNumber.text!),
                "accountHolderName" : String(txtBranch.text!),
                "roughtingNo"       : String(txtBranchCode.text!)
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
                    strSuccess = JSON["status"] as Any as? String
                    
                    // var strSuccessAlert : String!
                    // strSuccessAlert = JSON["msg"]as Any as? String
                    
                    if strSuccess == "success" {
                        
                        var strSuccessAlert : String!
                        strSuccessAlert = JSON["stripeBankAccountNo"]as Any as? String
                        self.saveStripebankAccountNumber = strSuccessAlert
                        self.save_bank_Stripe_Details_to_our_server_wb(strStripeBankAccountNumber: strSuccessAlert)
                        
                        // 110000000
                    }
                    else {
                        
                         var strSuccessAlert : String!
                         strSuccessAlert = JSON["msg"]as Any as? String
                        
                        var strSuccessAlert2 : String!
                        strSuccessAlert2 = JSON["status"]as Any as? String
                        
                        CRNotifications.showNotification(type: CRNotifications.error, title: String(strSuccessAlert2), message:String(strSuccessAlert), dismissDelay: 1.5, completion:{})
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
    
    
    @objc func save_bank_Stripe_Details_to_our_server_wb(strStripeBankAccountNumber:String) {
        
        self.addBankAccountWB()
        return
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let urlString = BASE_URL_SWIIPE
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            parameters = [
                "action"            : "editbankaccount",
                "userId"            : String(myString),
                "bankaccountId"     : Int(saveBankAccountIdInInt),
                "stripeBankAccountNo" : String(strStripeBankAccountNumber)
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
                    
                    // var strSuccessAlert : String!
                    // strSuccessAlert = JSON["msg"]as Any as? String
                    
                    if strSuccess == "success" {
                        
                        /*
                         status = success;
                         stripeBankAccountNo = "ba_1JmcmYBnk7ygV50qZJgEonKx";
                         stripeCustomerNo = "ba_1JmcmYBnk7ygV50qZJgEonKx";
                         */
                        
                        self.addBankAccountWB()
                        
                        
                        // 110000000
                    }
                    else {
                        // self.indicator.stopAnimating()
                        // self.enableService()
                        CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Something went wrong. Please try again after sometime.", dismissDelay: 1.5, completion:{})
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

extension AddBankAccount: BottomPopupDelegate {
    
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
        
        // let indexPath = IndexPath.init(row: 0, section: 0)
        // let cell = self.tbleView.cellForRow(at: indexPath) as! OrderNewCardTableCell
        
        // bank details default
        if let person = UserDefaults.standard.value(forKey: "keyDoneSelectingBankDetails") as? [String:Any]
        {
            // print(person as Any)
            
            /*
            Optional(["image": http://demo2.evirtualservices.com/swiipe/site/img/uploads/bank/Wells_Fargo_Bank.svg.png, "created": Oct 30th, 2019, 6:54 am, "bankName": WELLS FARGO, "bankId": 4])
            */
            
            let x : Int = (person["bankId"] as! Int)
            let myString = String(x)
            // print(myString as Any)
            
            saveBankAccountId = myString
            
            saveBankAccountIdInInt = (person["bankId"] as! Int)
            
            // strGetBankOrCard = "BANK"
            saveTransactionId = "tok_1G1TJqBnk7ygV50qStTUp7x3"
            
            txtSelectBank.text = (person["bankName"] as! String)
            
            // self.lblBankName.text = (person["bankName"] as! String)
            // cell.txtSelectBank.text = (person["bankName"] as! String)
            
            // bank image
            // imgBankImage.sd_setImage(with: URL(string: (person["image"] as! String)), placeholderImage: UIImage(named: "bankPlaceholderBlack")) // my profile image
            
            let defaults = UserDefaults.standard
            defaults.set("", forKey: "keyDoneSelectingBankDetails")
            defaults.set(nil, forKey: "keyDoneSelectingBankDetails")
            
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
