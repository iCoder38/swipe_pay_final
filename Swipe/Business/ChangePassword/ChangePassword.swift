//
//  ChangePassword.swift
//  Swipe
//
//  Created by evs_SSD on 1/16/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import CRNotifications

class ChangePassword: UIViewController,UITextFieldDelegate {

    let cellReuseIdentifier = "changePasswordTableCell"
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "CHANGE PASSWORD"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var btnBack:UIButton!
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
                self.tbleView.delegate = self
                self.tbleView.dataSource = self
                self.tbleView.backgroundColor = .white
                self.tbleView.separatorStyle = UITableViewCell.SeparatorStyle.none
            }
    }
    
    override func viewDidLoad() {
     super.viewDidLoad()
     
     
     self.navigationController?.setNavigationBarHidden(true, animated: true)
     
        let defaults = UserDefaults.standard
        let userName = defaults.string(forKey: "KeyLoginPersonal")
        if userName == "loginViaPersonal" {
            // personal user
            navigationBar.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
             self.view.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
        }
        else {
            navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
            self.view.backgroundColor = BUTTON_BACKGROUND_COLOR_BLUE
        }
        
        // self.profileWB()
     // self.gerServerFullData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        sideBarMenuClick()
    }

        @objc func sideBarMenuClick() {
            if revealViewController() != nil {
            btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
                revealViewController().rearViewRevealWidth = 300
                view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
              }
        }
    
       override var preferredStatusBarStyle: UIStatusBarStyle {
             return .lightContent
       }
       
    
    func setPaddingWithImage(image: UIImage, textField: UITextField){
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 50))
        imageView.frame = CGRect(x: 13.0, y: 13.0, width: 24.0, height: 24.0)
        //For Setting extra padding other than Icon.
        let seperatorView = UIView(frame: CGRect(x: 50, y: 0, width: 2, height: 50))
        seperatorView.backgroundColor = UIColor(red: 80/255, green: 89/255, blue: 94/255, alpha: 1)
        view.addSubview(seperatorView)
        textField.delegate = self
        textField.leftViewMode = .always
        textField.layer.cornerRadius = 4
        textField.clipsToBounds = true
        view.addSubview(imageView)
        view.backgroundColor = .clear
        textField.leftViewMode = UITextField.ViewMode.always
        textField.leftView = view
    }
    
    //MARK:- PROFILE
    @objc func profileWB() {
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
                                
                                var dict: Dictionary<AnyHashable, Any>
                                dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                                
                                let defaults = UserDefaults.standard
                                defaults.setValue(dict, forKey: "keyLoginFullData")
                                
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
    
    //MARK:- VALIDATION BEFORE HIT CHANGE PASSWORD WEBSERVICE
    @objc func changePasswordValidation() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! ChangePasswordTableCell
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            // let x : Int = (person["userId"] as! Int)
            // let myString = String(x)
            
            // print(person as Any)
            
            if cell.txtCurrentPassword.text == "" {
                CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Current password field should not be Empty", dismissDelay: 1.5, completion:{})
            }
            else
            if cell.txtNewPassword.text == "" {
                CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"New password field should not be Empty", dismissDelay: 1.5, completion:{})
            }
            else
            if cell.txtConfirmPassword.text == "" {
                CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Confirm password field should not be Empty", dismissDelay: 1.5, completion:{})
            }
            else
            if cell.txtNewPassword.text == cell.txtCurrentPassword.text {
                CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"New Password Must not be same as Current Password", dismissDelay: 1.5, completion:{})
            }
            else
            if cell.txtNewPassword.text != cell.txtConfirmPassword.text {
                CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Password Must be Same", dismissDelay: 1.5, completion:{})
            }
            else {
                self.changePasswordWB()
            }
            
        }
        else
        {
            // session expired login again.
        }
        
        
        
        
    }
    //MARK:- CHANGE PASSWORD WEBSERVICE
    @objc func changePasswordWB() {
        /*
        [action] => changePassword
        [oldPassword] => 123456
        [newPassword] => 123
        [userId] => 74
        */
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
            
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = tbleView.cellForRow(at: indexPath) as! ChangePasswordTableCell
        
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
            {
                let x : Int = (person["userId"] as! Int)
                let myString = String(x)
                       parameters = [
                           "action" : "changePassword",
                           "userId"    : String(myString),
                           "oldPassword"   : String(cell.txtCurrentPassword.text!),
                           "newPassword"   : String(cell.txtNewPassword.text!)
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
                                    // var ar : NSArray!
                                    // ar = (JSON["data"] as! Array<Any>) as NSArray
                                    // self.arrListOfAllCards = (ar as! Array<Any>)
                                    
                                    //self.arrListOfAllCards = self.arrListOfSavedCards
                                
        CRNotifications.showNotification(type: CRNotifications.success, title: "Success!", message:strSuccessAlert, dismissDelay: 1.5, completion:{})
                                    
                                    cell.txtCurrentPassword.text = ""
                                    cell.txtNewPassword.text = ""
                                    cell.txtConfirmPassword.text = ""
                                    
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

extension ChangePassword: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:ChangePasswordTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ChangePasswordTableCell
        
        cell.backgroundColor = .clear
        
        let defaults = UserDefaults.standard
        let userName = defaults.string(forKey: "KeyLoginPersonal")
        if userName == "loginViaPersonal" {
            // personal user
            navigationBar.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
            cell.viewUpperBG.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
            cell.btnUpdatePassword.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
            
            // text fields
            let userIconPhone1 = UIImage(named: "personalkey")
            setPaddingWithImage(image: userIconPhone1!, textField: cell.txtCurrentPassword)
            
            let userIconPhone2 = UIImage(named: "personalkey")
            setPaddingWithImage(image: userIconPhone2!, textField: cell.txtNewPassword)
            
            let userIconPhone3 = UIImage(named: "personalkey")
            setPaddingWithImage(image: userIconPhone3!, textField: cell.txtConfirmPassword)
        }
        else {
            navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
            cell.viewUpperBG.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
            cell.btnUpdatePassword.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
            
            // text fields
            let userIconPhone1 = UIImage(named: "businessKey")
            setPaddingWithImage(image: userIconPhone1!, textField: cell.txtCurrentPassword)
            
            let userIconPhone2 = UIImage(named: "businessKey")
            setPaddingWithImage(image: userIconPhone2!, textField: cell.txtNewPassword)
            
            let userIconPhone3 = UIImage(named: "businessKey")
            setPaddingWithImage(image: userIconPhone3!, textField: cell.txtConfirmPassword)
        }
        
        
        
        cell.btnUpdatePassword.layer.cornerRadius = 4
        cell.btnUpdatePassword.clipsToBounds = true
        cell.btnUpdatePassword.setTitleColor(.white, for: .normal)
        cell.btnUpdatePassword.addTarget(self, action: #selector(changePasswordValidation), for: .touchUpInside)
        
        cell.txtCurrentPassword.placeholder     = "Current Password"
        cell.txtNewPassword.placeholder         = "New Password"
        cell.txtConfirmPassword.placeholder     = "Confirm Password"
        
        cell.txtCurrentPassword.keyboardAppearance = .dark
        cell.txtNewPassword.keyboardAppearance = .dark
        cell.txtConfirmPassword.keyboardAppearance = .dark
        
        return cell
           
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 735
    }
    
}

extension ChangePassword: UITableViewDelegate
{
    
}

