//
//  GetStartedNowNewRegistraiton.swift
//  Swipe
//
//  Created by evs_SSD on 1/28/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import CRNotifications

class GetStartedNowNewRegistraiton: UIViewController,UITextFieldDelegate {

    let cellReuseIdentifier = "getStartedRegistrationTableCell"
    
    var myDeviceTokenIs:String!
    
    @IBOutlet weak var img_registration_screen:UIImageView!
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            // navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "GET STARTED NOW"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var tbleView: UITableView! {
            didSet
            {
                 tbleView.delegate = self
                 tbleView.dataSource = self
                self.tbleView.backgroundColor = .white
                self.tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))

            }
    }
    
    
    
    
    
    // business or personal
    @IBOutlet weak var imgBGColor:UIImageView!
    
    @IBOutlet weak var lblBusinessOrpersonal:UILabel!
    
    @IBOutlet weak var lblHello:UILabel! {
        didSet {
            lblHello.textColor = UIColor.init(red: 105.0/255.0, green: 39.0/255.0, blue: 224.0/255.0, alpha: 1)
        }
    }
    
    @IBOutlet weak var btnSignInClick:UIButton!
    
    @IBOutlet weak var viewToRound:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        let userName = defaults.string(forKey: "KeyLoginPersonal")
        
        if userName == "loginViaPersonal" {
            
            // navigationBar.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
            lblBusinessOrpersonal.text = "PERSONAL"
            imgBGColor.image = UIImage(named:"PloginBG")
            // self.signInPersonalSubmitGradientColor()
            
            self.img_registration_screen.image = UIImage(named:"new_personal_logo")
            
        } else {
            
            // navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
            lblBusinessOrpersonal.text = "BUSINESS"
            imgBGColor.image = UIImage(named:"bLoginBG")
            // self.signInBusinessSubmitGradientColor()
            
        }
        
        
        
        // keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        btnSignInClick.addTarget(self, action: #selector(pushToSignUpPage), for: .touchUpInside)
        
        // self.signInSubmitGradientColor()
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view .endEditing(true)
        return true
    }
    
   
    @objc func pushToSignUpPage() {
        self.dismiss(animated: true, completion: nil)
//        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "GetStartedNowNewRegistraitonId") as? GetStartedNowNewRegistraiton
//        self.navigationController?.pushViewController(settingsVCId!, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    /*
    //MARK:- SIGN IN SUBMIT GRADIENT COLOR
    @objc func signInSubmitGradientColor() {
        btnSignInSubmit.layer.cornerRadius = 4
        btnSignInSubmit.clipsToBounds = true
        btnSignInSubmit.backgroundColor = .clear
        btnSignInSubmit.setTitleColor(.white, for: .normal)
        
           // Apply Gradient Color
           let gradientLayer:CAGradientLayer = CAGradientLayer()
           gradientLayer.frame.size = btnSignInSubmit.frame.size
           gradientLayer.colors =
            [UIColor.init(red: 18.0/255.0, green: 98.0/255.0, blue: 225.0/255.0, alpha: 1).cgColor,UIColor.init(red: 59.0/255.0, green: 188.0/255.0, blue: 243.0/255.0, alpha: 1).withAlphaComponent(1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        btnSignInSubmit.layer.addSublayer(gradientLayer)
    }
    */
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func registrationBusinessWB() {
        self.view.endEditing(true)
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! GetStartedRegistrationTableCell
        
        if cell.txtName.text == "" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Name field should not be Empty.", dismissDelay: 1.5, completion:{})
        }
        else
            if cell.txtEmail.text == "" {
                CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Email field should not be Empty.", dismissDelay: 1.5, completion:{})
            }
        else
            if cell.txtPassword.text == "" {
                CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Password field should not be Empty.", dismissDelay: 1.5, completion:{})
            }
        else
            if cell.txtPhone.text == "" {
                CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Phone field should not be Empty.", dismissDelay: 1.5, completion:{})
            }
        else {
            
            // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            
            let urlString = BASE_URL_SWIIPE
            
            let indexPath = IndexPath.init(row: 0, section: 0)
            let cell = self.tbleView.cellForRow(at: indexPath) as! GetStartedRegistrationTableCell
            
            // Create UserDefaults
            let defaults = UserDefaults.standard
            if let myString = defaults.string(forKey: "deviceFirebaseToken") {
                myDeviceTokenIs = myString
                
            }
            else {
                myDeviceTokenIs = "111111111111111111111"
            }
            
            var parameters:Dictionary<AnyHashable, Any>!
            
            let userName = defaults.string(forKey: "KeyLoginPersonal")
            
            if userName == "loginViaPersonal" {
                parameters = [
                    "action"        : "registration",
                    "email"         : String(cell.txtEmail.text!),
                    "password"      : String(cell.txtPassword.text!),
                    "fullName"      : String(cell.txtName.text!),
                    "contactNumber" : String(cell.txtPhone.text!),
                    "deviceToken"   : String(myDeviceTokenIs),
                    "device"        : String("iOS"),
                    "role"          : String("Member")
                ]
            }
            else {
                parameters = [
                    "action"            : "registration",
                    "email"             : String(cell.txtEmail.text!),
                    "password"          : String(cell.txtPassword.text!),
                    "fullName"          : String(cell.txtName.text!),
                    "contactNumber"     : String(cell.txtPhone.text!),
                    "deviceToken"       : String(myDeviceTokenIs),
                    "device"            : String("iOS"),
                    "role"              : String("Vendor")
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
                            
                            // ERProgressHud.sharedInstance.hide()
                            
                            var dict: Dictionary<AnyHashable, Any>
                            dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                            
                            let defaults = UserDefaults.standard
                            defaults.setValue(dict, forKey: "keyLoginFullData")
                            
                            var strSuccess2 : String!
                            strSuccess2 = dict["role"] as Any as? String
                            
                            print(strSuccess2 as Any)
                            
                            self.create_Stripe_account_After_evs_register()
                            
                        }
                        else {
                            // self.indicator.stopAnimating()
                            // self.enableService()
                            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:strSuccessAlert, dismissDelay: 1.5, completion:{})
                            ERProgressHud.sharedInstance.hide()
                            // self.dismiss(animated: true, completion: nil)
                        }
                        
                    }
                    
                case .failure(_):
                    print("Error message:\(String(describing: response.result.error))")
                    // self.indicator.stopAnimating()
                    // self.enableService()
                    ERProgressHud.sharedInstance.hide()
                    
                    let alertController = UIAlertController(title: nil, message: SERVER_ISSUE_MESSAGE_ONE+"\n"+SERVER_ISSUE_MESSAGE_TWO, preferredStyle: .actionSheet)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default) {
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
    
    // MARK: - REGISTER STRIPE ACCOUNT AFTER EVS ACCOUNT -
    @objc func create_Stripe_account_After_evs_register() {
        self.view.endEditing(true)
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! GetStartedRegistrationTableCell
        
        let urlString = base_url_create_Stripe_customer
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        parameters = [
            "action"        : "createCustomer",
            "email"         : String(cell.txtEmail.text!)
        ]
        
        print("parameters-------\(String(describing: parameters))")
        
        Alamofire.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON {
            response in
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value {
                    
                    let JSON = data as! NSDictionary
                    print(JSON)
                    
                    /*
                     status = success;
                     stripeCustomerNo = "cus_KRV17ynbdsq3bN";
                     */
                    
                    var strSuccess : String!
                    strSuccess = JSON["status"]as Any as? String
                    
                    /*var strSuccessAlert : String!
                     strSuccessAlert = JSON["msg"]as Any as? String*/
                    
                    if strSuccess == "success" {
                        
                        // ERProgressHud.sharedInstance.hide()
                        
                        var strSuccess2 : String!
                        strSuccess2 = JSON["stripeCustomerNo"]as Any as? String
                        
                        self.edit_profile_after_success_register_stripe_wb(strStripeCustomerNumber: strSuccess2)
                        
                        /*var dict: Dictionary<AnyHashable, Any>
                         dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                         
                         let defaults = UserDefaults.standard
                         defaults.setValue(dict, forKey: "keyLoginFullData")
                         
                         var strSuccess2 : String!
                         strSuccess2 = dict["role"] as Any as? String
                         
                         print(strSuccess2 as Any)
                         */
                        
                        
                    }
                    else {
                        
                        // self.indicator.stopAnimating()
                        // self.enableService()
                        CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Something went wrong. Please try again after some time", dismissDelay: 1.5, completion:{})
                        ERProgressHud.sharedInstance.hide()
                        // self.dismiss(animated: true, completion: nil)
                        
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
    
    @objc func edit_profile_after_success_register_stripe_wb(strStripeCustomerNumber:String) {
        self.view.endEditing(true)
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! GetStartedRegistrationTableCell
        
        let urlString = BASE_URL_SWIIPE
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            parameters = [
                "action"            : "editprofile",
                "userId"            : String(myString),
                "stripeCustomerNo"  : String(strStripeCustomerNumber)
            ]
            
            print("parameters-------\(String(describing: parameters))")
            
            Alamofire.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON {
                response in
                
                switch(response.result) {
                case .success(_):
                    if let data = response.result.value {
                        
                        let JSON = data as! NSDictionary
                        print(JSON)
                        
                        /*
                         status = success;
                         stripeCustomerNo = "cus_KRV17ynbdsq3bN";
                         */
                        var strSuccess : String!
                        strSuccess = JSON["status"]as Any as? String
                        
                        /*var strSuccessAlert : String!
                         strSuccessAlert = JSON["msg"]as Any as? String*/
                        
                        if strSuccess == "success" {
                            
                            ERProgressHud.sharedInstance.hide()
                            
                            // var strSuccess2 : String!
                            // strSuccess2 = JSON["stripeCustomerNo"]as Any as? String
                            
                            self.openOTPscreen(myPhoneNumber: cell.txtPhone.text!, myEmail: cell.txtEmail.text!)
                            
                        }
                        else {
                            // self.indicator.stopAnimating()
                            // self.enableService()
                            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Something went wrong. Please try again after some time", dismissDelay: 1.5, completion:{})
                            ERProgressHud.sharedInstance.hide()
                            // self.dismiss(animated: true, completion: nil)
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
    
    
    
    @objc func openOTPscreen(myPhoneNumber:String,myEmail:String) {
        
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OTPId") as? OTP
        settingsVCId!.getNumber = myPhoneNumber
        settingsVCId!.getEmail = myEmail
        self.present(settingsVCId!, animated: true, completion: nil)
        
    }
    
    @objc func personalRegistraiton() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! GetStartedRegistrationTableCell
        
        let urlString = BASE_URL_SWIIPE
                 
                 var parameters:Dictionary<AnyHashable, Any>!
               
        // Create UserDefaults
        let defaults = UserDefaults.standard
        if let myString = defaults.string(forKey: "deviceFirebaseToken") {
            myDeviceTokenIs = myString

        }
        else {
            myDeviceTokenIs = "111111111111111111111"
        }
        
                 let userName = defaults.string(forKey: "KeyLoginPersonal")
                 if userName == "loginViaPersonal" {
                     ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
                     parameters = [
                         "action"        : "registration",
                         "email"         : String(cell.txtEmail.text!),
                         "password"      : String(cell.txtPassword.text!),
                        "fullName"       : String(cell.txtName.text!),
                        "contactNumber"   : String(cell.txtPhone.text!),
                        "deviceToken"     : String(myDeviceTokenIs),
                        "device"      : String("iOS"),
                        "role"      : String("Member")//"123456"
                     ]
                 }
                 else {
                     // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
                  
                     parameters = [
                         "action"        : "registration",
                         "email"         : String(cell.txtEmail.text!),
                         "password"      : String(cell.txtPassword.text!),
                        "fullName"       : String(cell.txtName.text!),
                        "contactNumber"   : String(cell.txtPhone.text!),
                        "deviceToken"     : String(myDeviceTokenIs),
                        "device"      : String("iOS"),
                        "role"      : String("Vendor")//"123456"
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
                                        
                                        /*
                                         data =     {
                                             BEmail = "";
                                             BLat = "";
                                             BName = "";
                                             BPhone = "";
                                             BType = "";
                                             Baddress = "";
                                             Blong = "";
                                             address = "";
                                             contactNumber = 1234;
                                             device = Ios;
                                             deviceToken = "";
                                             email = "hello123@gmail.com";
                                             firebaseId = "";
                                             fullName = hello;
                                             image = "";
                                             lastName = "";
                                             role = Vendor;
                                             socialId = "";
                                             socialType = "";
                                             userId = 99;
                                             wallet = 0;
                                             zipCode = "";
                                         };
                                         msg = "Data save successfully.";
                                         status = success;
                                         */
                                        var strSuccess : String!
                                        strSuccess = JSON["status"]as Any as? String
                                        
                                        var strSuccessAlert : String!
                                        strSuccessAlert = JSON["msg"]as Any as? String
                                        
                                        if strSuccess == "success" //true
                                        {
                                      
                                            ERProgressHud.sharedInstance.hide()
                                            
                                            var dict: Dictionary<AnyHashable, Any>
                                            dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                                            
                                            let defaults = UserDefaults.standard
                                            defaults.setValue(dict, forKey: "keyLoginFullData")
                                            
                                          CRNotifications.showNotification(type: CRNotifications.success, title: "Message!", message:strSuccessAlert, dismissDelay: 1.5, completion:{})
                                         
                                         
                                         var strSuccess2 : String!
                                         strSuccess2 = dict["role"] as Any as? String
                                         
                                          print(strSuccess2 as Any)
                                         
                                            
                                            self.openOTPscreen(myPhoneNumber: cell.txtPhone.text!,myEmail: cell.txtEmail.text!)
                                            
                                            
                                            
                                            
                                            
                                            
                                            // self.dismiss(animated: true, completion: nil)
                                             
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


extension GetStartedNowNewRegistraiton: UITableViewDataSource
    {
        func numberOfSections(in tableView: UITableView) -> Int
        {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            return 1//arrListOfUsers.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        {
            let cell:GetStartedRegistrationTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! GetStartedRegistrationTableCell
            
            cell.backgroundColor = .clear
            
            cell.txtEmail.delegate = self
            cell.txtPassword.delegate = self
            cell.txtName.delegate = self
            cell.txtPhone.delegate = self
           
            let defaults = UserDefaults.standard
            let userName = defaults.string(forKey: "KeyLoginPersonal")
            if userName == "loginViaPersonal" {
                cell.btnSignInSubmit.layer.cornerRadius = 4
                cell.btnSignInSubmit.clipsToBounds = true
                cell.btnSignInSubmit.backgroundColor = .clear
                cell.btnSignInSubmit.setTitleColor(.white, for: .normal)
                
                   // Apply Gradient Color
                   let gradientLayer:CAGradientLayer = CAGradientLayer()
                   gradientLayer.frame.size = cell.btnSignInSubmit.frame.size
                   gradientLayer.colors =
                    [UIColor.init(red: 0.0/255.0, green: 179.0/255.0, blue: 138.0/255.0, alpha: 1).cgColor,UIColor.init(red: 59.0/255.0, green: 188.0/255.0, blue: 243.0/255.0, alpha: 1).withAlphaComponent(1).cgColor]
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
                
                cell.btnSignInSubmit.layer.addSublayer(gradientLayer)
            }
            else {
                cell.btnSignInSubmit.layer.cornerRadius = 4
                cell.btnSignInSubmit.clipsToBounds = true
                cell.btnSignInSubmit.backgroundColor = .clear
                cell.btnSignInSubmit.setTitleColor(.white, for: .normal)
                
                   // Apply Gradient Color
                   let gradientLayer:CAGradientLayer = CAGradientLayer()
                   gradientLayer.frame.size = cell.btnSignInSubmit.frame.size
                   gradientLayer.colors =
                    [UIColor.init(red: 18.0/255.0, green: 98.0/255.0, blue: 225.0/255.0, alpha: 1).cgColor,UIColor.init(red: 59.0/255.0, green: 188.0/255.0, blue: 243.0/255.0, alpha: 1).withAlphaComponent(1).cgColor]
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
                
                cell.btnSignInSubmit.layer.addSublayer(gradientLayer)
            }
            
            cell.btnSignInSubmit.addTarget(self, action: #selector(registrationBusinessWB), for: .touchUpInside)
            
            return cell
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 800
    }
        
    }


    extension GetStartedNowNewRegistraiton: UITableViewDelegate
    {
        
    }
