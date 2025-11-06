
//
//  ForgotPassword.swift
//  Swipe
//
//  Created by evs_SSD on 2/5/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit
import Alamofire
import CRNotifications

class ForgotPassword: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            // navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "FORGOT PASSWORD"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
    }
    @IBOutlet weak var btnForgotPassword:UIButton! {
        didSet {
            btnForgotPassword.setTitle("Submit", for: .normal)
            btnForgotPassword.addTarget(self, action: #selector(forgot), for: .touchUpInside)
        }
    }
    @IBOutlet weak var txtEmail:UITextField! {
        didSet {
            txtEmail.layer.borderWidth = 0.8
            txtEmail.layer.borderColor = UIColor.init(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1).cgColor
            txtEmail.backgroundColor = UIColor.init(red: 251.0/255.0, green: 251.0/255.0, blue: 251.0/255.0, alpha: 1)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let defaults = UserDefaults.standard
        let userName = defaults.string(forKey: "KeyLoginPersonal")
        if userName == "loginViaPersonal" {
            navigationBar.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
        }
        else {
            navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
        }
        txtEmail.delegate = self
        
    }
    @objc func backClickMethod() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    
    @objc func forgot() {
        if txtEmail.text == "" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Email should not be empty.", dismissDelay: 1.5, completion:{})
        }
        else {
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
           
         // if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
         // {
             // let x : Int = (person["userId"] as! Int)
             // let myString = String(x)
            
                parameters = [
                    "action"         : "forgotpassword",
                    "email"         : String(txtEmail.text!)
                ]
         // }
                
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
                                
                                // var dict: Dictionary<AnyHashable, Any>
                                // dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                                
                                // let defaults = UserDefaults.standard
                                // defaults.setValue(dict, forKey: "keyLoginFullData")
                                
                                self.dismiss(animated: true, completion: nil)
                                
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
    
}
