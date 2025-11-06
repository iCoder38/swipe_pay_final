//
//  EditProfile.swift
//  Swipe
//
//  Created by evs_SSD on 1/10/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import CRNotifications

class EditProfile: UIViewController {

    @IBOutlet weak var navigationBar:UIView! {
           didSet {
            let defaults = UserDefaults.standard
            let userName = defaults.string(forKey: "KeyLoginPersonal")
            if userName == "loginViaPersonal" {
                // personal user
                navigationBar.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
            }
            else {
               navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
            }
            
           }
       }
       
       @IBOutlet weak var lblNavigationTitle:UILabel! {
           didSet {
               lblNavigationTitle.text = "Edit Profile"
               lblNavigationTitle.textColor = .white
           }
       }
       
    @IBOutlet weak var btnBack:UIButton!
    
    @IBOutlet weak var txtEmail:UITextField! {
        didSet {
            txtEmail.layer.cornerRadius = 4
            txtEmail.clipsToBounds = true
            txtEmail.isUserInteractionEnabled = false
            txtEmail.keyboardAppearance = .dark
        }
    }
    @IBOutlet weak var txtName:UITextField! {
        didSet {
            txtName.layer.cornerRadius = 4
            txtName.clipsToBounds = true
            txtName.keyboardAppearance = .dark
        }
    }
    @IBOutlet weak var txtPhoneNumber:UITextField! {
        didSet {
            txtPhoneNumber.layer.cornerRadius = 4
            txtPhoneNumber.clipsToBounds = true
            txtPhoneNumber.keyboardAppearance = .dark
            txtPhoneNumber.keyboardType = .numberPad
        }
    }
    
    @IBOutlet weak var btnSubmit:UIButton! {
        didSet {
            btnSubmit.setTitleColor(.white, for: .normal)
            btnSubmit.layer.cornerRadius = 4
            btnSubmit.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var btnEditBusinessDetails:UIButton! {
        didSet {
            btnEditBusinessDetails.setTitleColor(.white, for: .normal)
            btnEditBusinessDetails.layer.cornerRadius = 4
            btnEditBusinessDetails.clipsToBounds = true
            btnEditBusinessDetails.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
            btnEditBusinessDetails.addTarget(self, action: #selector(editBusinessDetailsClickMethod), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        btnBack.setImage(UIImage(named: "menuWhite"), for: .normal)
        sideBarMenu()
        
        
        
        
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // print(person)
            txtEmail.text = (person["email"] as! String) // email
            txtName.text = (person["fullName"] as! String) // name
            txtPhoneNumber.text = (person["contactNumber"] as! String) // phone
        }
        else {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Your Session has been Expired.", dismissDelay: 1.5, completion:{})
        }
        
        
        let defaults = UserDefaults.standard
        let userName = defaults.string(forKey: "KeyLoginPersonal")
        if userName == "loginViaPersonal" {
            // personal user
            
            let userIcon = UIImage(named: "personalMail")
            setPaddingWithImage(image: userIcon!, textField: txtEmail)
            
            let userIcon2 = UIImage(named: "personalUser")
            setPaddingWithImage(image: userIcon2!, textField: txtName)
            
            let userIcon3 = UIImage(named: "personalphone")
            setPaddingWithImage(image: userIcon3!, textField: txtPhoneNumber)
            
            btnSubmit.addTarget(self, action: #selector(editProfileTextScreenValidation), for: .touchUpInside)
            btnSubmit.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
            btnEditBusinessDetails.isHidden = true
        }
        else
        {
            let userIcon = UIImage(named: "businessEmail")
            setPaddingWithImage(image: userIcon!, textField: txtEmail)
            
            let userIcon2 = UIImage(named: "businessUser")
            setPaddingWithImage(image: userIcon2!, textField: txtName)
            
            let userIcon3 = UIImage(named: "businessPhone")
            setPaddingWithImage(image: userIcon3!, textField: txtPhoneNumber)
            
            btnSubmit.addTarget(self, action: #selector(editProfileTextScreenValidation), for: .touchUpInside)
            btnSubmit.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
            btnEditBusinessDetails.isHidden = false
        }
        
        
    }
    @objc func editBusinessDetailsClickMethod() {
         let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditBusinessDetailsId") as? EditBusinessDetails
         self.navigationController?.pushViewController(settingsVCId!, animated: true)
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
        textField.leftViewMode = .always
        view.addSubview(imageView)
        view.backgroundColor = .clear
        textField.leftViewMode = UITextField.ViewMode.always
        textField.leftView = view
    }
    
    
    // MARK:- EDIT PROFILE WEBSERVICE
    @objc func editProfileTextScreenValidation() {

        if txtName.text == "" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:strNameValidation, dismissDelay: 1.5, completion:{})
        }
        else
        if txtPhoneNumber.text == "" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:strPhoneValidation, dismissDelay: 1.5, completion:{})
        }
        else {
            self.editProfileWB()
        }
        
    }
    
    @objc func editProfileWB() {
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
           
        /*
         [action] => editprofile
         [userId] => 76
         [fullName] => purnima
         [contactNumber] => 6859693458
         */
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
                   parameters = [
                       "action"        : "editprofile",
                       "userId"        : String(myString),
                       "fullName"       : String(txtName.text!),
                       "contactNumber"   : String(txtPhoneNumber.text!)
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
                                /*
                                 data =     {
                                     
                                 };
                                 msg = "Data save successfully.";
                                 status = success;
                                 */
                                   var dict: Dictionary<AnyHashable, Any>
                                   dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                                   
                                   let defaults = UserDefaults.standard
                                   defaults.setValue(dict, forKey: "keyLoginFullData")
                                   
                                 CRNotifications.showNotification(type: CRNotifications.success, title: "Message!", message:strSuccessAlert, dismissDelay: 1.5, completion:{})
                                
                                    // self.loginWBClickMethod()
                                
                                self.view.endEditing(true)
                                
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
