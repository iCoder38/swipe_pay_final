//
//  OTP.swift
//  Swipe
//
//  Created by evs_SSD on 2/24/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit
import SROTPView
import Alamofire
import CRNotifications

class OTP: UIViewController {

    @IBOutlet weak var otpView: SROTPView! //dont use SROTPField use SROTPView
    
    @IBOutlet weak var btnResend: UIButton!
    
    var enteredOtp: String = ""
    
    var whatIsLoginId:String!
    
    @IBOutlet weak var imgBG:UIImageView!
    
    @IBOutlet weak var lblOtpSentTo:UILabel!
    
    var getNumber:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // print(whatIsLoginId as Any)

        btnResend.addTarget(self, action: #selector(resendClickMethod), for: .touchUpInside)
        
        
        lblOtpSentTo.text = "We sent a code to "+getNumber+" Please write down."
        
        
        let defaults = UserDefaults.standard
        let userName = defaults.string(forKey: "KeyLoginPersonal")
        if userName == "loginViaPersonal" {
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            
            imgBG.image = UIImage(named:"PloginBG")
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                let x : Int = (person["userId"] as! Int)
                let myString = String(x)
                self.otpVerification(strLoginUserIdIs: myString)
                
            }
        }
        else {
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            imgBG.image = UIImage(named:"bLoginBG")
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                let x : Int = (person["userId"] as! Int)
                let myString = String(x)
                self.otpVerification(strLoginUserIdIs: myString)
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        otpView.otpTextFieldsCount = 4
        otpView.otpTextFieldActiveBorderColor = UIColor.white
        otpView.otpTextFieldDefaultBorderColor = UIColor.white
        otpView.otpTextFieldFontColor = UIColor.white
//        otpView.cursorColor = UIColor.white
//        otpView.otpTextFieldBorderWidth = 2
        otpView.otpEnteredString = { pin in
            print("The entered pin is \(pin)")
            
            self.checkMyOtpIs(strMyOtpIsHere: "\(pin)")
        }
    }
    
    override func viewDidLayoutSubviews() {
         otpView.initializeUI()
    }

    @objc func resendClickMethod() {
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
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            parameters = [
                "action"        : "generateotp",
                "userId"        : String(myString)
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
                        
                        // var dict: Dictionary<AnyHashable, Any>
                        // dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                        
                        // let defaults = UserDefaults.standard
                        // defaults.setValue(dict, forKey: "keyLoginFullData")
                        
                        CRNotifications.showNotification(type: CRNotifications.success, title: "Message!", message:strSuccessAlert, dismissDelay: 1.5, completion:{})
                        
                        
                        // var strSuccess2 : String!
                        // strSuccess2 = dict["role"] as Any as? String
                        
                        // print(strSuccess2 as Any)
                        
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
    
    // MARK:- SEND OTP
    @objc func otpVerification(strLoginUserIdIs:String!) {
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
                 
                     ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
                     parameters = [
                         "action"        : "generateotp",
                         "userId"        : String(strLoginUserIdIs)
                        
                     ]
                 
                 
                 
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
                                            
                                            // var dict: Dictionary<AnyHashable, Any>
                                            // dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                                            
                                            // let defaults = UserDefaults.standard
                                            // defaults.setValue(dict, forKey: "keyLoginFullData")
                                            
                                          CRNotifications.showNotification(type: CRNotifications.success, title: "Message!", message:strSuccessAlert, dismissDelay: 1.5, completion:{})
                                         
                                         
                                         // var strSuccess2 : String!
                                         // strSuccess2 = dict["role"] as Any as? String
                                         
                                          // print(strSuccess2 as Any)
                                         
                                            // self.dismiss(animated: true, completion: nil)
                                             
                                             self.dummyLogin()
                                            
                                            
                                            //
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
    
    
    
    
    @objc func dummyLogin() {
        
        
        self.view.endEditing(true)
        
        let urlString = BASE_URL_SWIIPE
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        parameters = [
            "action"        : "login",
            //
            
            "email"         : String("dishu5@gmail.com"),
            "password"      : String("123456")
        ]
        
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
                    
                    if strSuccess == "success" {
                       
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
    
    
    
    @objc func checkMyOtpIs(strMyOtpIsHere:String) {
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
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            // self.otpVerification(strLoginUserIdIs: myString)
            
        
        
                 
                 
                     ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
                     parameters = [
                         "action"        : "verifyotp",
                         "userId"        : String(myString),
                         "OTP"        : String(strMyOtpIsHere)
                        
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
                                            
                                            // var dict: Dictionary<AnyHashable, Any>
                                            // dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                                            
                                            // let defaults = UserDefaults.standard
                                            // defaults.setValue(dict, forKey: "keyLoginFullData")
                                            
                                          CRNotifications.showNotification(type: CRNotifications.success, title: "Message!", message:strSuccessAlert, dismissDelay: 1.5, completion:{})
                                         
                                         
                                         // var strSuccess2 : String!
                                         // strSuccess2 = dict["role"] as Any as? String
                                         
                                          // print(strSuccess2 as Any)
                                         
                                            // self.dismiss(animated: true, completion: nil)
                                     
                                            
                                            
                                            
                                            
                                            
                                            
                                            let defaults = UserDefaults.standard
                                            let userName = defaults.string(forKey: "KeyLoginPersonal")
                                            if userName == "loginViaPersonal" {
                                                // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
                                                
                                                self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                                                
                                            }
                                            else {
                                                // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
                                                // self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                                                
                                                
                                                
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FinalRegistraitonId") as? FinalRegistraiton
        self.present(settingsVCId!, animated: true, completion: nil)
                                                
                                                
                                                
                                                
                                                
                                                
                                                
        //self.navigationController?.pushViewController(settingsVCId!, animated: true)
                                                
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
}
