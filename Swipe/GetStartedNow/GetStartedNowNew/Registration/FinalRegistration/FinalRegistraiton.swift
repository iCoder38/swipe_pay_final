//
//  FinalRegistraiton.swift
//  Swipe
//
//  Created by evs_SSD on 2/20/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import SwiftyJSON
import CoreLocation
import CRNotifications

class FinalRegistraiton: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate  {

    
    var getRegName:String!
    var getRegEmail:String!
    var getRegPhone:String!
    var getRegPassword:String!
    
    var myDeviceTokenIs:String!
    
    var imgUploadYesOrNo:String!
        
        // image
        var imageStr:String!
        var imgData:Data!
        
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
                   lblNavigationTitle.text = "Business Details"
                   lblNavigationTitle.textColor = .white
               }
           }
           
        // business name
        // phone number
        // email
        // location
        // image
        
        @IBOutlet weak var txtBusinessName:UITextField! {
            didSet {
                txtBusinessName.layer.cornerRadius = 4
                txtBusinessName.clipsToBounds = true
                txtBusinessName.keyboardAppearance = .dark
                txtBusinessName.layer.borderColor = UIColor.lightGray.cgColor
                txtBusinessName.layer.borderWidth = 0.8
                txtBusinessName.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: txtBusinessName.frame.height))
                txtBusinessName.leftViewMode = .always
                
            }
        }
        @IBOutlet weak var txtPhoneNumber:UITextField! {
            didSet {
                txtPhoneNumber.layer.cornerRadius = 4
                txtPhoneNumber.clipsToBounds = true
                txtPhoneNumber.keyboardAppearance = .dark
                txtPhoneNumber.layer.borderColor = UIColor.lightGray.cgColor
                txtPhoneNumber.layer.borderWidth = 0.8
                txtPhoneNumber.keyboardType = .phonePad
                txtPhoneNumber.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: txtPhoneNumber.frame.height))
                txtPhoneNumber.leftViewMode = .always
            }
        }
        @IBOutlet weak var txtEmail:UITextField! {
            didSet {
                txtEmail.layer.cornerRadius = 4
                txtEmail.clipsToBounds = true
                txtEmail.keyboardAppearance = .dark
                txtEmail.layer.borderColor = UIColor.lightGray.cgColor
                txtEmail.layer.borderWidth = 0.8
                txtEmail.keyboardType = .emailAddress
                txtEmail.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: txtEmail.frame.height))
                txtEmail.leftViewMode = .always
            }
        }
        @IBOutlet weak var txtLocation:UITextField! {
            didSet {
                txtLocation.layer.cornerRadius = 4
                txtLocation.clipsToBounds = true
                txtLocation.keyboardAppearance = .dark
                txtLocation.layer.borderColor = UIColor.lightGray.cgColor
                txtLocation.layer.borderWidth = 0.8
                txtLocation.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: txtLocation.frame.height))
                txtLocation.leftViewMode = .always
            }
        }
        @IBOutlet weak var btnEditBusinessDetails:UIButton! {
            didSet {
                btnEditBusinessDetails.setTitleColor(.white, for: .normal)
                btnEditBusinessDetails.layer.cornerRadius = 4
                btnEditBusinessDetails.clipsToBounds = true
                btnEditBusinessDetails.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
                
                btnEditBusinessDetails.addTarget(self, action: #selector(editProfileImageWB), for: .touchUpInside)
            }
        }
        
        @IBOutlet weak var imgProfile:UIImageView! {
            didSet {
                imgProfile.layer.cornerRadius = 60
                imgProfile.clipsToBounds = true
            }
        }
        
        @IBOutlet weak var btnBack:UIButton! {
            didSet {
                btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
            }
        }
        override func viewDidLoad() {
            super.viewDidLoad()
/*
            self.getRegName = ""
            self.getRegEmail = ""
            self.getRegPhone = ""
            self.getRegPassword = ""
            
            self.txtBusinessName.text = ""
            self.txtPhoneNumber.text = ""
            self.txtEmail.text = ""
            self.txtLocation.text = ""
            */
            // self.imgProfile.image = nil
            
            /*
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
            {
                // print(person)
                /*
                 ["BName": business test, "socialId": , "contactNumber": 9638521230, "fullName": purnima2, "zipCode": , "BPhone": 7896543210, "role": Vendor, "wallet": 630, "BEmail": testnew@gmail.com, "address": , "image": http://demo2.evirtualservices.com/swiipe/site/img/uploads/users/1576134757images(8).jpeg, "device": Android, "firebaseId": , "BLat": 0.0, "userId": 74, "Blong": 0.0, "socialType": , "lastName": , "deviceToken": , "BType": , "email": purnimaevs@gmail.com, "Baddress": noida]
                 (lldb)
                 */
                txtEmail.text = (person["BEmail"] as! String) // email
                txtBusinessName.text = (person["BName"] as! String) // name
                txtPhoneNumber.text = (person["BPhone"] as! String) // phone
                txtLocation.text = (person["Baddress"] as! String) // name
                
                // business image
                imgProfile.sd_setImage(with: URL(string: (person["image"] as! String)), placeholderImage: UIImage(named: "plainBack")) // my profile image
            }
            else
            {
                // CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Your Session has been Expired.", dismissDelay: 1.5, completion:{})
            }
            */
            //
            
            
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
            {
                // print(person)
                
                
            }
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditBusinessDetails.cellTappedMethod(_:)))

            imgProfile.isUserInteractionEnabled = true
            imgProfile.addGestureRecognizer(tapGestureRecognizer)
            
            txtEmail.delegate = self
            txtBusinessName.delegate = self
            txtPhoneNumber.delegate = self
            txtLocation.delegate = self
        }
        @objc func backClickMethod() {
            // self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
            navigationController?.setNavigationBarHidden(true, animated: animated)
        }
        
        override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
        @objc func cellTappedMethod(_ sender:AnyObject){
             // print("you tap image number: \(sender.view.tag)")
            self.uploadImageOpenActionSheet()
        }
        
        @objc func uploadImageOpenActionSheet() {
            let alert = UIAlertController(title: "Upload image", message: "Camera or Gallery", preferredStyle: .actionSheet)

            alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
                 self.openCamera()
            }))

            alert.addAction(UIAlertAction(title: "Gallery", style: .default , handler:{ (UIAlertAction)in
                 self.openGallery()
            }))

            alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler:{ (UIAlertAction)in
                //print("User click Dismiss button")
            }))

            self.present(alert, animated: true, completion: {
                //print("completion block")
            })
        }
        @objc func openCamera() {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        @objc func openGallery() {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
                imgUploadYesOrNo = "1"
                
                // let indexPath = IndexPath.init(row: 0, section: 0)
                // let cell = tbleView.cellForRow(at: indexPath) as! EditProfileTableCell
                
                let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                imgProfile.image = image_data // show image on image view
                let imageData:Data = image_data!.pngData()!
                imageStr = imageData.base64EncodedString()
                self.dismiss(animated: true, completion: nil)
                
                imgData = image_data!.jpegData(compressionQuality: 0.2)!

        }
        
        // MARK:- EDIT BUSINESS DETAILS WITH IMAGE
        @objc func editProfileImageWB() {
            // first registration
            
            if txtBusinessName.text == "" {
                 CRNotifications.showNotification(type: CRNotifications.error, title: "Message!", message:"Business Name should not be empty", dismissDelay: 1.5, completion:{})
            }
            else
            if txtPhoneNumber.text == "" {
                 CRNotifications.showNotification(type: CRNotifications.error, title: "Message!", message:"Phone Number should not be empty", dismissDelay: 1.5, completion:{})
            }
            else
            if txtEmail.text == "" {
                 CRNotifications.showNotification(type: CRNotifications.error, title: "Message!", message:"Email should not be empty", dismissDelay: 1.5, completion:{})
            }
            else
            if txtLocation.text == "" {
                 CRNotifications.showNotification(type: CRNotifications.error, title: "Message!", message:"Location should not be empty", dismissDelay: 1.5, completion:{})
            }
            else if imgProfile.image == nil {
                CRNotifications.showNotification(type: CRNotifications.error, title: "Message!", message:"Image should not be empty", dismissDelay: 1.5, completion:{})
            }
            else if imgProfile.image == UIImage(named:"avatar") {
                CRNotifications.showNotification(type: CRNotifications.error, title: "Message!", message:"Image should not be empty", dismissDelay: 1.5, completion:{})
            }
            else {
                self.firstRegistrationBeforeImage()
            }
           }
    
    @objc func firstRegistrationBeforeImage() {
        
        if self.imgUploadYesOrNo == "1" {
            self.editWithImage()
        }
        else {
            self.editWithoutImage()
        }
        
        /*
        let urlString = BASE_URL_SWIIPE
                 
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
                     ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
                     parameters = [
                         "action"        : "registration",
                         "email"         : String(getRegEmail),
                         "password"      : String(getRegPassword),
                        "fullName"       : String(getRegName),
                        "contactNumber"   : String(getRegPhone),
                        "deviceToken"     : String(myDeviceTokenIs),
                        "device"      : String("Ios"),
                        "role"      : String("User")//"123456"
                     ]
                 }
                 else
                 {
                     ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
                    /*
                     [action] => registration
                     [email] => hellobusiness@gmail.com
                     [fullName] => hello
                     [contactNumber] => +918929963
                     [password] => 123456
                     [device] => Android
                     [deviceToken] =>
                     [role] => Vendor
                     */
                     parameters = [
                         "action"        : "registration",
                         "email"         : String(getRegEmail),
                        "password"      : String(getRegPassword),
                        "fullName"       : String(getRegName),
                        "contactNumber"   : String(getRegPhone),
                        "deviceToken"     : String(myDeviceTokenIs),
                        "device"      : String("Ios"),
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
                                            
                                          // CRNotifications.showNotification(type: CRNotifications.success, title: "Message!", message:strSuccessAlert, dismissDelay: 1.5, completion:{})
                                         
                                         
                                         var strSuccess2 : String!
                                         strSuccess2 = dict["role"] as Any as? String
                                         
                                          print(strSuccess2 as Any)
                                       
                                            
                                            
                                            if self.imgUploadYesOrNo == "1" {
                                                self.editWithImage()
                                            }
                                            else {
                                                self.editWithoutImage()
                                            }
                                            
                                        }
                                        else
                                        {
                                            // self.indicator.stopAnimating()
                                            // self.enableService()
                                         CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:strSuccessAlert, dismissDelay: 1.5, completion:{})
                                            ERProgressHud.sharedInstance.hide()
                                            self.dismiss(animated: true, completion: nil)
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
        
        
        
        
        */
    } // last
    
        // MARK:- EDIT BUSINESS DETAILS WITH IMAGE
        @objc func editWithImage() {

            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
            {
             let x : Int = (person["userId"] as! Int)
             let myString = String(x)
              
                // var parameters:Dictionary<AnyHashable, Any>!
                     let parameters = [
                         "action"    : "editprofile",
                         "userId"    : String(myString),
                         "BName"     : String(txtBusinessName.text!),
                         "BPhone"    : String(txtPhoneNumber.text!),
                         "Baddress"  : String(txtLocation.text!),
                         "BEmail"    : String(txtEmail.text!),
                     ]
                    
                        print(parameters as Any)
                    
                    Alamofire.upload(multipartFormData: { multipartFormData in
                    multipartFormData.append(self.imgData, withName: "image",fileName: "SwiipeBusinessEditProfile.jpg", mimeType: "image/jpg")
                        for (key, value) in parameters {
                            
                            // let paramsData:Data = NSKeyedArchiver.archivedData(withRootObject: value)
                            
                            multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                        }
                    },
                    to:BASE_URL_SWIIPE)
                    { (result) in
                        switch result {
                        case .success(let upload, _, _):

                            upload.uploadProgress(closure: { (progress) in
                                //print("Upload Progress: \(progress.fractionCompleted)")
                                
                                let alertController = UIAlertController(title: "Uploading image", message: "Please wait......", preferredStyle: .alert)

                                let progressDownload : UIProgressView = UIProgressView(progressViewStyle: .default)

                                progressDownload.setProgress(Float((progress.fractionCompleted)/1.0), animated: true)
                                progressDownload.frame = CGRect(x: 10, y: 70, width: 250, height: 0)

                                alertController.view.addSubview(progressDownload)
                                self.present(alertController, animated: true, completion: nil)
                            })

                            upload.responseJSON { response in
                                //print(response.result.value as Any)
                                if let data = response.result.value
                                {
                                     let JSON = data as! NSDictionary
                                    print(JSON)

                                    var dict: Dictionary<AnyHashable, Any>
                                    dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                                    
                                    let defaults = UserDefaults.standard
                                    defaults.setValue(dict, forKey: "keyLoginFullData")
                                    
                                    self.imgUploadYesOrNo = "0"
                                    
                                    ERProgressHud.sharedInstance.hide()
                                    
                                    self.getRegName = ""
                                    self.getRegEmail = ""
                                    self.getRegPhone = ""
                                    self.getRegPassword = ""
                                    
                                    self.txtBusinessName.text = ""
                                    self.txtPhoneNumber.text = ""
                                    self.txtEmail.text = ""
                                    self.txtLocation.text = ""
                                    
                                    self.imgProfile.image = nil
                                    
                                    self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                                    
                                    // self.dismiss(animated: true, completion: nil)
                                }
                                else
                                {
                                    CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Server Not Responding. Please try again Later.", dismissDelay: 1.5, completion:{})

                                }
                            }
                        case .failure(let encodingError):
                            print(encodingError)
                            self.dismiss(animated: true, completion: nil)
                        }}}
            
        }
        
        // MARK:- EDIT BUSINESS DETAILS WITHOUT IMAGE
        @objc func editWithoutImage() {
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
               
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
            {
                let x : Int = (person["userId"] as! Int)
                let myString = String(x)
                       parameters = [
                           "action"    : "editprofile",
                           "userId"    : String(myString),
                           "BName"     : String(txtBusinessName.text!),
                           "BPhone"    : String(txtPhoneNumber.text!),
                           "Baddress"  : String(txtLocation.text!),
                           "BEmail"    : String(txtEmail.text!),
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
                                    
                                    self.getRegName = ""
                                    self.getRegEmail = ""
                                    self.getRegPhone = ""
                                    self.getRegPassword = ""
                                    
                                    self.txtBusinessName.text = ""
                                    self.txtPhoneNumber.text = ""
                                    self.txtEmail.text = ""
                                    self.txtLocation.text = ""
                                    
                                    self.imgProfile.image = nil
                                    
                                    self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                                    
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
