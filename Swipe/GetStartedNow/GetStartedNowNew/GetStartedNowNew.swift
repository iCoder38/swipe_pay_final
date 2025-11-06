//
//  GetStartedNowNew.swift
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



class GetStartedNowNew: UIViewController,UITextFieldDelegate {

    let cellReuseIdentifier = "getStartedNowNewTableCell"
    
    @IBOutlet weak var navigationBar:UIView!
    
    var myDeviceTokenIs:String!
    
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
    
    @IBOutlet weak var img_login_screen:UIImageView!
    
    
    
    @IBOutlet weak var tbleView: UITableView! {
            didSet {
                self.tbleView.delegate = self
                self.tbleView.dataSource = self
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
    
    @IBOutlet weak var btnSignUpClick:UIButton!
    
    @IBOutlet weak var viewToRound:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        _ = Date()
        _ = Calendar.current
        let currentYear = Calendar.current.component(.year, from: Date())
        let month = Calendar.current.component(.month, from: Date())
        let day = Calendar.current.component(.day, from: Date())
        let previousYear = currentYear - 1
        let nextYear = currentYear + 1
        
        let currentMonth = month
        let previousMonth = month - 1
        let nextMonth = month + 1
        print("\(previousYear)->\(currentYear)->\(nextYear)->\(currentMonth)->\(previousMonth)->\(nextMonth)")
        
        
        print(String(day))
        print(String(month))
        print(String(currentYear))
        */
        
        
        let defaults = UserDefaults.standard
        let userName = defaults.string(forKey: "KeyLoginPersonal")
        
        if userName == "loginViaPersonal" {
            
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                 print(person as Any)
                
                let indexPath = IndexPath.init(row: 0, section: 0)
                let cell = self.tbleView.cellForRow(at: indexPath) as! GetStartedNowNewTableCell
                
                if (person["role"] as! String) == "Member" {
                    cell.txtEmail.text = (person["email"] as! String)
                }
                else if (person["role"] as! String) == "User" {
                    cell.txtEmail.text = (person["email"] as! String)
                }
                else if (person["role"] as! String) == "Vendor" {
                    
                }
            }
            else {
                // i am logged out
            }
            navigationBar.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
            lblBusinessOrpersonal.text = "PERSONAL"
            imgBGColor.image = UIImage(named:"PloginBG")
            
            self.img_login_screen.image = UIImage(named:"new_personal_logo")
            
            self.signInPersonalSubmitGradientColor()
            
        }
        else {
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                // print(person as Any)
                
                let indexPath = IndexPath.init(row: 0, section: 0)
                let cell = self.tbleView.cellForRow(at: indexPath) as! GetStartedNowNewTableCell
                
                if (person["role"] as! String) == "Member" {
                    
                }
                else if (person["role"] as! String) == "User" {
                    
                }
                else if (person["role"] as! String) == "Vendor" {
                    cell.txtEmail.text = (person["email"] as! String)
                }
                
            }
            else {
                // i am logged out
            }
            navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
            lblBusinessOrpersonal.text = "BUSINESS"
            imgBGColor.image = UIImage(named:"bLoginBG")
            self.signInBusinessSubmitGradientColor()
        }
        
        
        
        // keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        btnSignUpClick.addTarget(self, action: #selector(pushToSignUpPage), for: .touchUpInside)
        
        
        // login()
        
        
        
        
 
        
        
    }
    
    @objc func forgotPasswordpush() {
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ForgotPasswordId") as? ForgotPassword
        self.present(settingsVCId!, animated: true, completion: nil)
    }
    @objc func pushToSignUpPage() {
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "GetStartedNowNewRegistraitonId") as? GetStartedNowNewRegistraiton
        self.present(settingsVCId!, animated: true, completion: nil)
        // self.navigationController?.pushViewController(settingsVCId!, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
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
    //MARK:- SIGN IN SUBMIT GRADIENT COLOR
    @objc func signInBusinessSubmitGradientColor() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! GetStartedNowNewTableCell
        
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
    //MARK:- SIGN IN SUBMIT GRADIENT COLOR - PERSONAL
    @objc func signInPersonalSubmitGradientColor() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! GetStartedNowNewTableCell
        
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
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:- LOGIN WEBSERVICE
    @objc func login() {
           
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! GetStartedNowNewTableCell
        
        
        if cell.txtEmail.text == "" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Email field should not be Empty.", dismissDelay: 1.5, completion:{})
        }
        else
        if cell.txtPassword.text == "" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Password field should not be Empty.", dismissDelay: 1.5, completion:{})
        }
        else {
         
            self.view.endEditing(true)
            
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
        
        
        // let defaults = UserDefaults.standard
        let userName = defaults.string(forKey: "KeyLoginPersonal")
        if userName == "loginViaPersonal" {
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            
            parameters = [
                "action"        : "login",
//                  "email"         : String("pandey@gmail.com"),
//                  "password"      : String("123456"),//"123456"
                "deviceToken"       :String(myDeviceTokenIs),
                   "email"         : String(cell.txtEmail.text!),//"pandey@gmail.com",
                   "password"      : String(cell.txtPassword.text!)//"123456"
            ]
        }
        else {
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            parameters = [
                "action"        : "login",
//                  "email"         : String("purnimaevs@gmail.com"),
//                  "password"      : String("123456"),//"123456"
                "deviceToken"       :String(myDeviceTokenIs),
                  "email"         : String(cell.txtEmail.text!),//"purnimaevs@gmail.com",
                 "password"      : String(cell.txtPassword.text!)//"123456"
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
                               
                               if strSuccess == "success" {
                                   
                                /*
                                 data =     {
                                     
                                 };
                                 msg = "Data save successfully.";
                                 status = success;
                                 */
                                
                                /*
                                 data =     {
                                         BEmail = "testnew@gmail.com";
                                         BLat = "0.0";
                                         BName = "business test 2";
                                         BPhone = 7896543210;
                                         BType = "";
                                         Baddress = noida;
                                         Blong = "0.0";
                                         OTP = "";
                                         address = "";
                                         contactNumber = 9638521230;
                                         device = "";
                                         deviceToken = "fzRpV1uV-ER5kwArqvIzTT:APA91bEOhhFSPp6wrSWZSqrbyRsfdqHlCyV_yfPAYM-SUNo2XcD_4hm1vG3ZGR9XNLfW5HeuU9ef0Yqo2t8witcS4QjaUuO6K2C4u2FE651YwQzx4X39TkaP6Il4TaMapVOpz9glIkxP";
                                         email = "purnimaevs@gmail.com";
                                         firebaseId = "";
                                         fullName = purnima101;
                                         image = "http://demo2.evirtualservices.com/swiipe/site/img/uploads/users/1582209055SwiipeBusinessEditProfile.jpg";
                                         lastName = "";
                                         role = Vendor;
                                         socialId = "";
                                         socialType = "";
                                         userId = 74;
                                         wallet = "501812.39";
                                         zipCode = "";
                                     };
                                     msg = "Data save successfully.";
                                     status = success;
                                 }
                                 */
                                   
                                   var dict: Dictionary<AnyHashable, Any>
                                   dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                                   
                                   let defaults = UserDefaults.standard
                                   defaults.setValue(dict, forKey: "keyLoginFullData")
                                   
                                 // CRNotifications.showNotification(type: CRNotifications.success, title: "Message!", message:strSuccessAlert, dismissDelay: 1.5, completion:{})
                                
                                
                                
                                
                                // otp check
                                
                                var otpCheck : String!
                                otpCheck = dict["OTP"] as Any as? String
                                print(otpCheck as Any)
                                
                                if otpCheck == "" {
                                    // not verified
                                    
                                    ERProgressHud.sharedInstance.hide()
                                    
                                    let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OTPId") as? OTP
                                     settingsVCId!.getNumber = dict["contactNumber"] as Any as? String
                                    self.present(settingsVCId!, animated: true, completion: nil)
                                    
                                    
                                    
                                    
                                } else if otpCheck == "YES" {
                                    //
                                    var bEmailCheck : String!
                                    bEmailCheck = dict["BEmail"] as Any as? String
                                    if bEmailCheck == "" {
                                        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FinalRegistraitonId") as? FinalRegistraiton
                                        // settingsVCId!.whatIsLoginId = strGetLoginUserId
                                        self.present(settingsVCId!, animated: true, completion: nil)
                                    }
                                    else {
                                        var strSuccess2 : String!
                                        strSuccess2 = dict["role"] as Any as? String
                                        
                                          print(strSuccess2 as Any)
                                        
                                        if strSuccess2 == "Member" {
                                            self.personalClick()
                                        }
                                        else
                                        if strSuccess2 == "User" {
                                            self.personalClick()
                                        }
                                        else {
                                            self.loginWBClickMethod()
                                        }
                                    }
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                }
                                else {
                                    let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OTPId") as? OTP
                                    settingsVCId!.getNumber = dict["contactNumber"] as Any as? String
                                    self.present(settingsVCId!, animated: true, completion: nil)
                                }
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                   
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
       }
    
    @objc func personalClick() {
        ERProgressHud.sharedInstance.hide()
        UserDefaults.standard.set("loginViaPersonal", forKey: "KeyLoginPersonal")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
        self.view.window?.rootViewController = sw
        let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "PersonalDashbaordId")
        let navigationController = UINavigationController(rootViewController: destinationController!)
        sw.setFront(navigationController, animated: true)
        
    }
    @objc func loginWBClickMethod() {
        ERProgressHud.sharedInstance.hide()
        
        UserDefaults.standard.set(nil, forKey: "KeyLoginPersonal")
        UserDefaults.standard.set("", forKey: "KeyLoginPersonal")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
        self.view.window?.rootViewController = sw
        let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "BusinessDashbaordId")
        let navigationController = UINavigationController(rootViewController: destinationController!)
        sw.setFront(navigationController, animated: true)
        
        /*
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BusinessDashbaordId") as? BusinessDashbaord
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
            */
    }
    
}


extension GetStartedNowNew: UITableViewDataSource {
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1//arrListOfUsers.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell:GetStartedNowNewTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! GetStartedNowNewTableCell
            
            cell.backgroundColor = .clear
            
            cell.txtEmail.delegate = self
            cell.txtPassword.delegate = self
           
            // cell.txtEmail.becomeFirstResponder()
            
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
            
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
            
            cell.btnSignInSubmit.addTarget(self, action: #selector(login), for: .touchUpInside)
            
            cell.btnForgotPassword.addTarget(self, action: #selector(forgotPasswordpush), for: .touchUpInside)
            
            return cell
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
    }
        
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
}
        
}

extension GetStartedNowNew: UITableViewDelegate {
        
}
