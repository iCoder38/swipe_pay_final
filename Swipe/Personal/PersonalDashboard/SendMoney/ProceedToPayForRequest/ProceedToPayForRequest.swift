//
//  ProceedToPayForRequest.swift
//  Swipe
//
//  Created by Apple on 17/03/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import CRNotifications

class ProceedToPayForRequest: UIViewController, UITextFieldDelegate {
    
    var dictGetSendMoneyUserDetails:NSDictionary!
    
    var myCurrentBalance:String!
    var balanceTypedIs:String!
    
    var changeNavigationTitle:String!
    
    var strRequestOrPay:String!
    
    var checkSendRequestValue:String!
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
        }
    }
    // @IBOutlet weak var lblWhatIsThisFor:UILabel!
    @IBOutlet weak var txtWhatIsThisFor:UITextField! {
        didSet {
            txtWhatIsThisFor.placeholder = "what is this for"
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var lblCurrentWalletBalance:UILabel! {
        didSet {
            // lblCurrentWalletBalance.text = "      Current Wallet Balance          "
            lblCurrentWalletBalance.textColor = .white
            // lblCurrentWalletBalance.backgroundColor = UIColor.init(red: 100.0/255.0, green: 206.0/255.0, blue: 225.0/255.0, alpha: 1)
        }
    }
    
    @IBOutlet weak var lblTotalAmountInWallet:UILabel! {
        didSet {
            // lblTotalAmountInWallet.text = "$600     "
            lblTotalAmountInWallet.textColor = .white
            // lblTotalAmountInWallet.backgroundColor = UIColor.init(red: 100.0/255.0, green: 206.0/255.0, blue: 225.0/255.0, alpha: 1)
        }
    }
    
    @IBOutlet weak var btnPleaseEnterAmount:UIButton!
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var imgSenderProfilePicture:UIImageView! {
        didSet {
            imgSenderProfilePicture.layer.cornerRadius = 60
            imgSenderProfilePicture.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var imgReceiverProfilePicture:UIImageView! {
        didSet {
            imgReceiverProfilePicture.layer.cornerRadius = 60
            imgReceiverProfilePicture.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lblPaymentTo:UILabel! {
        didSet {
            lblPaymentTo.textColor = .black
        }
    }
    
    @IBOutlet weak var lblBigAmount:UILabel! {
        didSet {
            lblBigAmount.textColor = BUTTON_BACKGROUND_COLOR_BLUE
        }
    }
    
    @IBOutlet weak var btnProceedToPay:UIButton! {
        didSet {
            
            btnProceedToPay.setTitleColor(.white, for: .normal)
            btnProceedToPay.addTarget(self, action: #selector(proceedToPayClick), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var txtSendMoney:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        balanceTypedIs = ""
        checkSendRequestValue = ""
        
        
        
        // print(dictGetSendMoneyUserDetails as Any)
        
        /*
         contactNumber = 1111111111;
         deviceToken = "";
         userId = 31;
         userImage = "http://demo2.evirtualservices.com/swiipe/site/img/uploads/users/1573199961images(24).jpeg";
         userN = "";
         userName = "Pradeep Bamola";
         */
        txtWhatIsThisFor.delegate = self
        
        if strRequestOrPay == "req" {
            print("i am req")
            txtWhatIsThisFor.isHidden = false
        } else {
            strRequestOrPay = "send"
            txtWhatIsThisFor.isHidden = true
        }
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            // let x : NSNumber = person["wallet"] as! NSNumber
            // self.lblTotalAmountInWallet.text = "$ "+"\(x)"
            // myCurrentBalance = "\(x)"
            
            let x : Double = person["wallet"] as! Double
            let foo = x.rounded(digits: 2) // 3.142
            self.lblTotalAmountInWallet.text = "$ "+"\(foo)"
            self.myCurrentBalance = "\(foo)"
            
            /*
             let livingArea = person["wallet"] as? Int ?? 0
             if livingArea == 0 {
             let stringValue = String(livingArea)
             self.lblTotalAmountInWallet.text = "$ "+stringValue+"     "
             myCurrentBalance = stringValue
             }
             else
             {
             let stringValue = String(livingArea)
             self.lblTotalAmountInWallet.text = "$ "+stringValue+"     "
             myCurrentBalance = stringValue
             }
             */
            
            // business image
            imgSenderProfilePicture.sd_setImage(with: URL(string: (person["image"] as! String)), placeholderImage: UIImage(named: "avatar")) // my profile image
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            imgSenderProfilePicture.isUserInteractionEnabled = true
            imgSenderProfilePicture.addGestureRecognizer(tapGestureRecognizer)
            
        }
        else {
            // session expired. Please logout.
        }
        
        let defaults = UserDefaults.standard
        let userName = defaults.string(forKey: "KeyLoginPersonal")
        if userName == "loginViaPersonal" {
            // personal user
            lblNavigationTitle.text = "REQUEST MONEY"
            btnProceedToPay.setTitle("Proceed to Request", for: .normal)
            // print(dictGetSendMoneyUserDetails as Any)
            // receiver name
            self.lblPaymentTo.text = "Request to "+(dictGetSendMoneyUserDetails["userName"] as! String)
            
            navigationBar.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
            // self.view.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
            btnProceedToPay.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
        }
        else {
            lblNavigationTitle.text = "SEND MONEY"
            btnProceedToPay.setTitle("Proceed to Pay", for: .normal)
            
            // receiver name
            self.lblPaymentTo.text = "Payment to "+(dictGetSendMoneyUserDetails["userName"] as! String)
            
            navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
            // self.view.backgroundColor = BUTTON_BACKGROUND_COLOR_BLUE
            btnProceedToPay.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
        }
        
        // receiver image
        imgReceiverProfilePicture.sd_setImage(with: URL(string: (dictGetSendMoneyUserDetails["userImage"] as! String)), placeholderImage: UIImage(named: "avatar")) // my profile image
        
        
        
        
        // txtSendMoney.delegate = self
        btnPleaseEnterAmount.addTarget(self, action: #selector(pleaseEnterAmountClickMethod), for: .touchUpInside)
        
        // keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @objc func backClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func proceedToPayClick() {
        
        if balanceTypedIs == "" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Please Enter Some Amount.", dismissDelay: 1.5, completion:{})
        }
        else {
            checkWalletBalance()
            
        }
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let present = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OpenImageInFullViewId") as? OpenImageInFullView
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            // send business image ,
            present!.imgString = (person["image"] as! String)
        }
        self.present(present!, animated: true, completion: nil)
    }
    
    @objc func pleaseEnterAmountClickMethod() {
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Enter Amount", message: "\n"+"Your Balance is : $ "+myCurrentBalance, preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Please Enter Amount"
            textField.keyboardAppearance = .dark
            textField.keyboardType = .decimalPad
            textField.delegate = self
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            self.lblBigAmount.text = "$ "+textField!.text!
            self.balanceTypedIs = textField!.text!
            
            
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {
            (_) in
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @objc func requestPopUp() {
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "What's is thid for", message: nil, preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Please Enter Amount"
            textField.keyboardAppearance = .dark
            textField.keyboardType = .decimalPad
            textField.delegate = self
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            // self.lblBigAmount.text = "$ "+textField!.text!
            // self.balanceTypedIs = textField!.text!
            
            // self.requestMoneyWB(strMessageIs: textField!.text!)
            self.txtWhatIsThisFor.isHidden = false
            self.checkSendRequestValue = textField!.text!
            self.txtWhatIsThisFor.text = textField!.text!
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {
            (_) in
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtWhatIsThisFor {
            
        } else {
            
            
            
            guard let oldText = textField.text, let r = Range(range, in: oldText) else {
                return true
            }
            
            let newText = oldText.replacingCharacters(in: r, with: string)
            let isNumeric = newText.isEmpty || (Double(newText) != nil)
            let numberOfDots = newText.components(separatedBy: ".").count - 1
            
            let numberOfDecimalDigits: Int
            if let dotIndex = newText.firstIndex(of: ".") {
                numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
            } else {
                numberOfDecimalDigits = 0
            }
            
            
            
            return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
            
        }
        return true
    }
    
    /*
     [action] => sendmoney
     [userId] => 74
     [receiverId] => 61
     [amount] => 1
     */
    
    @objc func checkWalletBalance() {
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            
            // let x : NSNumber = person["wallet"] as! NSNumber
            // self.lblTotalAmountInWallet.text = "$ "+"\(x)"
            
            let x : Double = person["wallet"] as! Double
            let foo = x.rounded(digits: 2) // 3.142
            self.lblTotalAmountInWallet.text = "$ "+"\(foo)"
            
            if self.lblTotalAmountInWallet.text == "0" {
                print("balance is zero")
            }
            else {
                
                if strRequestOrPay == "req" {
                    requestMoneyWB()
                } else {
                    sendMoneyWB()
                }
                //
            }
            
            
            
            /*
             
             
             let livingArea = person["wallet"] as? Int ?? 0
             if livingArea == 0 {
             let stringValue = String(livingArea)
             self.lblTotalAmountInWallet.text = "$ "+stringValue+"     "
             
             if stringValue == "0" {
             print(" i am equal ")
             CRNotifications.showNotification(type: CRNotifications.error, title: "Message!", message:"Your Balance is 0. Please add some money from Add Money section.", dismissDelay: 3, completion:{})
             }
             }
             else {
             let stringValue = String(livingArea)
             self.lblTotalAmountInWallet.text = "$ "+stringValue+"     "
             
             // print(txtEnterAmount.text!)
             
             
             let a:Int? = Int(balanceTypedIs)
             let b:Int? = Int(stringValue)
             
             if a! > b ?? 0 {
             CRNotifications.showNotification(type: CRNotifications.error, title: "Message!", message:"You don't have enough Balance.", dismissDelay: 3, completion:{})
             }
             else {
             // cashoutWB()
             
             }
             
             }
             
             */
        }
    }
    
    //MARK:- SEND MONEY
    @objc func sendMoneyWB() {
        //ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
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
             @Field("requestTo") String userId,
             @Field("requestFrom") String receiverId,
             @Field("amount") String amount,
             @Field("message") String message
             @Field("message") String message add one more editText
             ha
             */
            
            
            parameters = [
                "action"         : "sendmoney",
                "userId"         : String(myString),
                "receiverId"     : (dictGetSendMoneyUserDetails["userId"] as! Int),
                "amount"         : String(balanceTypedIs)
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
                        //ERProgressHud.sharedInstance.hide()
                        
                        self.profileWB()
                        
                        CRNotifications.showNotification(type: CRNotifications.success, title: "Success!", message:strSuccessAlert, dismissDelay: 1.5, completion:{})
                        
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
    
    @objc func requestMoneyWB() {
        //ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        // if checkSendRequestValue == "" {
        // self.requestPopUp()
        // } else {
        
        
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
             @Field("requestTo") String userId,
             @Field("requestFrom") String receiverId,
             @Field("amount") String amount,
             @Field("message") String message
             @Field("message") String message add one more editText
             ha
             */
            
            parameters = [
                "action"         : "paymentrequest",
                "requestTo"      : (dictGetSendMoneyUserDetails["userId"] as! Int),
                "requestFrom"    : String(myString),
                "amount"         : String(balanceTypedIs),
                "message"        : String(txtWhatIsThisFor.text!)
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
                    self.txtWhatIsThisFor.text = ""
                    
                    var strSuccess : String!
                    strSuccess = JSON["status"]as Any as? String
                    
                    var strSuccessAlert : String!
                    strSuccessAlert = JSON["msg"]as Any as? String
                    
                    if strSuccess == "success" //true
                    {
                        //ERProgressHud.sharedInstance.hide()
                        
                        self.profileWB()
                        
                        CRNotifications.showNotification(type: CRNotifications.success, title: "Success!", message:strSuccessAlert, dismissDelay: 1.5, completion:{})
                        
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
        
        // }
    }
    
    @objc func profileWB() {
        //  ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let urlString = BASE_URL_SWIIPE
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            parameters = [
                "action"         : "profile",
                "userId"         : String(myString)
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
                        
                        self.lblBigAmount.text = "$ 0"
                        
                        var dict: Dictionary<AnyHashable, Any>
                        dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                        
                        let defaults = UserDefaults.standard
                        defaults.setValue(dict, forKey: "keyLoginFullData")
                        
                        
                        
                        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
                        {
                            
                            
                            // let x : NSNumber = person["wallet"] as! NSNumber
                            // self.lblTotalAmountInWallet.text = "$ "+"\(x)"
                            // self.myCurrentBalance = "\(x)"
                            
                            let x : Double = person["wallet"] as! Double
                            let foo = x.rounded(digits: 2) // 3.142
                            self.lblTotalAmountInWallet.text = "$ "+"\(foo)"
                            self.myCurrentBalance = "\(foo)"
                            
                            /*
                             let livingArea = person["wallet"] as? Int ?? 0
                             if livingArea == 0 {
                             let stringValue = String(livingArea)
                             self.lblTotalAmountInWallet.text = "$ "+stringValue+"     "
                             
                             self.myCurrentBalance = stringValue
                             }
                             else
                             {
                             let stringValue = String(livingArea)
                             self.lblTotalAmountInWallet.text = "$ "+stringValue+"     "
                             
                             self.myCurrentBalance = stringValue
                             }
                             */
                            
                            
                            
                            
                            
                            
                        }
                        else
                        {
                            self.lblTotalAmountInWallet.text = "$0"
                        }
                        
                        // let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BusinessDashbaordId") as? BusinessDashbaord
                        // self.navigationController?.pushViewController(push!, animated: true)
                        
                        
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
