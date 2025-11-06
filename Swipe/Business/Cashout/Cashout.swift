//
//  Cashout.swift
//  Swipe
//
//  Created by Apple on 28/10/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import CRNotifications

import BottomPopup

class Cashout: UIViewController,UITextFieldDelegate {
    
    var buttonOrigin : CGPoint = CGPoint(x: 0, y: 0)
    
    var btnDragButton:UIButton!
    var imgDownArrow:UIImageView!
    
    var byDefaultDragButtonX :CGFloat!
    var byDefaultDragButtonY :CGFloat!
    var byDefaultDragButtonW :CGFloat!
    var byDefaultDragButtonH :CGFloat!
    
    var myCGFloatDrag :CGFloat!
    var myCGFloatNonDrag :CGFloat!
    
    // array list
    var arrListOfAllCards:Array<Any>!
    
    // bottom view popup
    var height: CGFloat = 600 // height
    var topCornerRadius: CGFloat = 35 // corner
    var presentDuration: Double = 0.8 // present view time
    var dismissDuration: Double = 0.5 // dismiss view time
    let kHeightMaxValue: CGFloat = 600 // maximum height
    let kTopCornerRadiusMaxValue: CGFloat = 35 //
    let kPresentDurationMaxValue = 3.0
    let kDismissDurationMaxValue = 3.0
    
    // save ids
    var saveCardId:String!
    var saveBankAccountId:String!
    var saveTransactionId:String!
    
    // who are you
    var strGetBankOrCard:String!
    
    @IBOutlet weak var dragbaseView:UIView! {
        didSet {
            dragbaseView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var imgSelectedBankName:UIImageView! {
        didSet {
             
        }
    }
    
    @IBOutlet weak var navigationBar:UIView! {
           didSet {
               navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
           }
       }
    
    @IBOutlet weak var lblBankName:UILabel!
    @IBOutlet weak var lblAccountNumberShowOnScreen:UILabel!
    
       @IBOutlet weak var lblNavigationTitle:UILabel! {
           didSet {
               lblNavigationTitle.text = "CASHOUT"
               lblNavigationTitle.textColor = .white
           }
       }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            //btnBack.setTitleColor(BUTTON_BACKGROUND_COLOR_BLUE, for: .normal)
            // btnBack.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var lblCurrentWalletBalance:UILabel! {
        didSet {
            lblCurrentWalletBalance.text = "      Current Wallet Balance          "
            lblCurrentWalletBalance.textColor = .white
            lblCurrentWalletBalance.backgroundColor = UIColor.init(red: 100.0/255.0, green: 206.0/255.0, blue: 225.0/255.0, alpha: 1)
        }
    }
    
    @IBOutlet weak var lblTotalAmountInWallet:UILabel! {
        didSet {
            lblTotalAmountInWallet.textAlignment = .center
            // lblTotalAmountInWallet.text = "      Current Wallet Balance          $600     "
            lblTotalAmountInWallet.textColor = .white
            lblTotalAmountInWallet.backgroundColor = UIColor.init(red: 100.0/255.0, green: 206.0/255.0, blue: 225.0/255.0, alpha: 1)
        }
    }
     
    @IBOutlet weak var btnChangeAccount:UIButton! {
        didSet {
            btnChangeAccount.setTitle("Change Account", for: .normal)
            btnChangeAccount.setTitleColor(BUTTON_BACKGROUND_COLOR_BLUE, for: .normal)
            btnChangeAccount.addTarget(self, action: #selector(changeAccountClick), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var extendedWithDrawableBalance:UILabel! {
        didSet {
            extendedWithDrawableBalance.textColor = .black
            extendedWithDrawableBalance.textColor = .black
            // extendedWithDrawableBalance.text = "Withdrawable amount is $650"
        }
    }
    
    @IBOutlet weak var txtEnterAmount:UITextField! {
        didSet {
            txtEnterAmount.layer.cornerRadius = 4
            txtEnterAmount.clipsToBounds = true
            txtEnterAmount.placeholder = "Enter Amount"
            txtEnterAmount.keyboardAppearance = .dark
            txtEnterAmount.keyboardType = .decimalPad
            txtEnterAmount.delegate = self
        }
    }
    @IBOutlet weak var txtTotalAccountList:UITextField! {
        didSet {
            txtTotalAccountList.layer.cornerRadius = 4
            txtTotalAccountList.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var btnOpenBankList:UIButton!
        
    @IBOutlet weak var btnSubmitRequest:UIButton! {
        didSet {
            btnSubmitRequest.layer.cornerRadius = 4
            btnSubmitRequest.clipsToBounds = true
            btnSubmitRequest.setTitle("Submit Request", for: .normal)
            btnSubmitRequest.setTitleColor(.white, for: .normal)
        }
    }
    
    @objc func changeAccountClick() {
        // self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(Cashout.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        btnSubmitRequest.addTarget(self, action: #selector(checkBalanceIsAvailaibleInWalletOrNot), for: .touchUpInside)
        btnOpenBankList.addTarget(self, action: #selector(openBankListClickMethod), for: .touchUpInside)
        
        // delegate
        txtEnterAmount.delegate = self
        
        setPaddingWithImage(image: UIImage(named:"dollarCashout")!, textField: txtEnterAmount)
        
        // self.sideBarMenuClick()
        let defaults = UserDefaults.standard
        if let name = defaults.string(forKey: "keySideBarMenu") {
            // print(name)
            if name == "dSideBar" {
                btnBack.setImage(UIImage(named: "menuWhite"), for: .normal)
                sideBarMenuClick()
            }
            else {
                btnBack.setImage(UIImage(named: "backs"), for: .normal)
                btnBack.addTarget(self, action: #selector(backClick), for: .touchUpInside)
            }
        }
        else
        {
            btnBack.setImage(UIImage(named: "backs"), for: .normal)
            btnBack.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        }
        
        // let defaults = UserDefaults.standard
        let userName = defaults.string(forKey: "KeyLoginPersonal")
        if userName == "loginViaPersonal" {
            // personal user
            navigationBar.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
             btnSubmitRequest.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
        }
        else {
            navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
            btnSubmitRequest.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
        }
        
        
        
        
        
        txtEnterAmount.delegate = self
        
         // setdragButtomFrame()
        
        // list of al bank wb
        listOfBankWB()
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            
            // let x : NSNumber = person["wallet"] as! NSNumber
            // self.lblTotalAmountInWallet.text = "Current Wallet Balance : "+"$ "+"\(x)"
            
            let x : Double = person["wallet"] as! Double
            let foo = x.rounded(digits: 2)
            self.lblTotalAmountInWallet.text = "Current Wallet Balance : "+"$ "+"\(foo)"
            
            
            
            
            // extendedWithDrawableBalance.text =
            
            /*
            let livingArea = person["wallet"] as? Int ?? 0
            if livingArea == 0 {
                let stringValue = String(livingArea)
                lblTotalAmountInWallet.text = "Current Wallet Balance : "+"$ "+stringValue+"     "
                extendedWithDrawableBalance.text = "Current Wallet Balance : "+"$ "+stringValue
            }
            else
            {
                let stringValue = String(livingArea)
                lblTotalAmountInWallet.text = "Current Wallet Balance : "+"$ "+stringValue+"     "
                extendedWithDrawableBalance.text = "Current Wallet Balance : "+"$ "+stringValue
            }
             */
        }
        else
        {
            lblTotalAmountInWallet.text = "Current Wallet Balance : "+"$0"
            // extendedWithDrawableBalance.text = "0"
        }
        
        
        // btnOpenBankList
        
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func backClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
   @objc func sideBarMenuClick() {
          
          self.view.endEditing(true)
          
          if revealViewController() != nil {
          btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
          
              revealViewController().rearViewRevealWidth = 300
              view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            }
      }
    
    @objc func openBankListClickMethod() {

        guard let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "secondVC") as? ExamplePopupViewController else { return }
        popupVC.height = self.height
        popupVC.topCornerRadius = self.topCornerRadius
        popupVC.presentDuration = self.presentDuration
        popupVC.dismissDuration = self.dismissDuration
        //popupVC.shouldDismissInteractivelty = dismissInteractivelySwitch.isOn
        popupVC.popupDelegate = self
        popupVC.strGetDetails = "savedBankList"
        //popupVC.getArrListOfCategory =
        popupVC.arrListOfBanks = self.arrListOfAllCards as NSArray?
        self.present(popupVC, animated: true, completion: nil)
    }
    
    
    
    @objc func buttonDrag(pan: UIPanGestureRecognizer) {
        /*
        if pan.state == .began {
            buttonOrigin = pan.location(in: btnDragButton)
            dragbaseView.backgroundColor = .clear
        }else {
            let location = pan.location(in: view) // get pan location
            btnDragButton.frame.origin = CGPoint(x: location.x - buttonOrigin.x, y: location.y - buttonOrigin.y)
            
            myCGFloatDrag = CGFloat(btnDragButton.frame.origin.y)
            myCGFloatNonDrag = CGFloat(dragbaseView.frame.origin.y)
            
            if myCGFloatDrag >= myCGFloatNonDrag {
                print("SHOW SOME ALERT")
                // showBankPopUp()
            }
            else
            {
                print("DO NOT SHOW SOME ALERT")
            }
        }
 */
    }
    
    @objc func showBankPopUp() {
        let alert = UIAlertController(title: "Withdraw", message: "Are you sure you want to withdraw from 'Central Bank of America'",
                                      preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Yes",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        self.btnDragButton.removeFromSuperview()
                                        self.setdragButtomFrame()
        }))
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        self.btnDragButton.removeFromSuperview()
                                        self.setdragButtomFrame()
        }))
        self.present(alert, animated: true, completion: nil)
    }

    @objc func setdragButtomFrame() {
        
        let result = UIScreen.main.bounds.size
        //NSLog("%f",result.height)
        
        if result.height == 667 { // iphone 8
            btnDragButton = UIButton(frame: CGRect(x: 148, y: 250, width: 120, height: 120))
            imgDownArrow = UIImageView(frame: CGRect(x: 168, y: 350, width: 40, height: 40))
        }
        else
        if result.height == 736 { // iphone 8 plus
            btnDragButton = UIButton(frame: CGRect(x: 150, y: 256, width: 120, height: 120))
            imgDownArrow = UIImageView(frame: CGRect(x: 187, y: 394, width: 40, height: 40))
        }
        else
        if result.height == 812 { // iphone 11 pro
            btnDragButton = UIButton(frame: CGRect(x: 148, y: 326, width: 80, height: 80))
            imgDownArrow = UIImageView(frame: CGRect(x: 167, y: 466, width: 40, height: 40))
        }
        else
        if result.height == 896 { // iphone 11 & 11 Pro Max
            btnDragButton = UIButton(frame: CGRect(x: 167, y: 335, width: 120, height: 120))
            imgDownArrow = UIImageView(frame: CGRect(x: 187, y: 500, width: 40, height: 40))
        }
        
        btnDragButton.setImage(UIImage(named:"wallet"), for: .normal)
        btnDragButton.backgroundColor = .clear
        
        imgDownArrow.image = UIImage(named:"businessDownArrow")
        imgDownArrow.backgroundColor = .clear
        
        self.view .addSubview(imgDownArrow)
        self.view .addSubview(btnDragButton)
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(buttonDrag(pan:)))
        self.btnDragButton.addGestureRecognizer(gesture)
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
         [action] => listcard
         [userId] => 74
         [type] => DEBIT
         */
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
                   parameters = [
                       "action" : "bankaccountlist",
                       "userId"   : String(myString)
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
                                /*
                                 accountName = purnima;
                                 accountNumber = 1236549874563;
                                 bankImage = "http://demo2.evirtualservices.com/swiipe/site/img/uploads/bank/Wells_Fargo_Bank.svg.png";
                                 bankName = "WELLS FARGO";
                                 bankaccountId = 70;
                                 created = "Dec 12th, 2019, 1:02 pm";
                                 modify = "";
                                 routingNo = 9876412343;
                                 userImage = "http://demo2.evirtualservices.com/swiipe/site/img/uploads/users/1576134757images(8).jpeg";
                                 userName = purnima;
                                 */
                               
                               var strSuccess : String!
                               strSuccess = JSON["status"]as Any as? String
                               
                               var strSuccessAlert : String!
                               strSuccessAlert = JSON["msg"]as Any as? String
                               
                               if strSuccess == "success" //true
                               {
                                var ar : NSArray!
                                ar = (JSON["data"] as! Array<Any>) as NSArray
                                self.arrListOfAllCards = (ar as! Array<Any>)
                                
                                //self.arrListOfAllCards = self.arrListOfSavedCards
                            
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    // cashout webservice
    /*
     
     */
    
    @objc func checkBalanceIsAvailaibleInWalletOrNot() {
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            /*
        //              print(person)
                    let livingArea = person["wallet"] as? Int ?? 0
                        if livingArea == 0 {
                            let stringValue = String(livingArea)
                         self.lblTotalAmountInWallet.text = "Current Wallet Balance : "+"$ "+stringValue+"     "
                            
                            if stringValue == "0" {
                                print(" i am equal ")
                                CRNotifications.showNotification(type: CRNotifications.error, title: "Message!", message:"Your Balance is 0. Please add some money from Add Money section.", dismissDelay: 3, completion:{})
                            }
                        }
                        else {
                            let stringValue = String(livingArea)
                            self.lblTotalAmountInWallet.text = "Current Wallet Balance : "+"$ "+stringValue+"     "

                            print(txtEnterAmount.text!)
                            
                            
                            let a:Int? = Int(txtEnterAmount.text!)
                            let b:Int? = Int(stringValue)
                            
                            if a! > b ?? 0 {
                                CRNotifications.showNotification(type: CRNotifications.error, title: "Message!", message:"You don't have enough Balance.", dismissDelay: 3, completion:{})
                            }
                            else {
                                cashoutWB()
                            }
                            
                            
                            
                            
            }
                            
            
                            
                        
                    
        }
        else
        {
            // session out please logout.
        }
        */
            
            
            let x : NSNumber = person["wallet"] as! NSNumber
            self.lblTotalAmountInWallet.text = "Current Wallet Balance : "+"$ "+"\(x)"
            cashoutWB()
            
    }
}
    
    // MARK:- CASHOUT WEBSERVICE
    @objc func cashoutWB() {
        if self.txtEnterAmount.text == "" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Please Enter Amount", dismissDelay: 1.5, completion:{})
        }
        else
        if lblBankName.text == "" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"", dismissDelay: 1.5, completion:{})
        }
        else
        if lblBankName.text == "Please select bank" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Please Select Bank", dismissDelay: 1.5, completion:{})
        }
        else
        if lblAccountNumberShowOnScreen.text == "" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Please Select Bank", dismissDelay: 1.5, completion:{})
            
        }
        else
        if lblAccountNumberShowOnScreen.text == "Click here to Select Bank." {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Please Select Bank", dismissDelay: 1.5, completion:{})
            
        }
        else
        {
            
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
         [action] => cashout
         [userId] => 74
         [amount] => 1
         [BankId] => 70
         */
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
                   parameters = [
                    "action"     : "cashout",
                    "userId"      : String(myString),
                    "amount"      : String(txtEnterAmount.text!),
                    "BankId"      : String(saveBankAccountId)
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
                                CRNotifications.showNotification(type: CRNotifications.success, title: "Success!", message:strSuccessAlert, dismissDelay: 1.5, completion:{})
                                
                                  self.profileWB()
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
                                
                                self.txtEnterAmount.text = ""
                                
                                var dict: Dictionary<AnyHashable, Any>
                                dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                                
                                let defaults = UserDefaults.standard
                                defaults.setValue(dict, forKey: "keyLoginFullData")
                                
                                
                                
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            let x : NSNumber = person["wallet"] as! NSNumber
            self.lblTotalAmountInWallet.text = "Current Wallet Balance : "+"$ "+"\(x)"
            
            /*
                   let livingArea = person["wallet"] as? Int ?? 0
                   if livingArea == 0 {
                       let stringValue = String(livingArea)
                    self.lblTotalAmountInWallet.text = "Current Wallet Balance : "+"$ "+stringValue+"     "
                    self.extendedWithDrawableBalance.text = "Current Wallet Balance : "+"$ "+stringValue
                   }
                   else
                   {
                    let stringValue = String(livingArea)
                    self.lblTotalAmountInWallet.text = "Current Wallet Balance : "+"$ "+stringValue+"     "
                    self.extendedWithDrawableBalance.text = "Current Wallet Balance : "+"$ "+stringValue
                   }
            */
               }
               else
               {
                self.lblTotalAmountInWallet.text = "$0"
                // self.extendedWithDrawableBalance.text = "Current Wallet Balance : $0"
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
    /*
      [action] => userlist
      [userId] => 74
      [pageNo] => 0
     */
}

extension Cashout: BottomPopupDelegate {
    
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
        
        // bank details default
        if let person = UserDefaults.standard.value(forKey: "keyDoneSelectingBankDetails") as? [String:Any]
        {
            // print(person as Any)
            
            /*
            ["accountName": purnima, "modify": , "created": Dec 12th, 2019, 1:02 pm, "bankName": WELLS FARGO, "routingNo": 9876412343, "bankImage": http://demo2.evirtualservices.com/swiipe/site/img/uploads/bank/Wells_Fargo_Bank.svg.png, "accountNumber": 1236549874563, "bankaccountId": 70, "userImage": http://demo2.evirtualservices.com/swiipe/site/img/uploads/users/1576134757images(8).jpeg, "userName": purnima]
            */
            
            let x : Int = (person["bankaccountId"] as! Int)
            let myString = String(x)
            print(myString as Any)
            
            saveBankAccountId = myString
            
            strGetBankOrCard = "BANK"
            saveTransactionId = "tok_1G1TJqBnk7ygV50qStTUp7x3"
            
            // account number
            let last4 = (person["accountNumber"] as! String).suffix(4)
            lblAccountNumberShowOnScreen.text = "xxxx xxxx xxxx - "+last4
            
            // bank name
            lblBankName.text = (person["bankName"] as! String)
            
            // bank image
            imgSelectedBankName.sd_setImage(with: URL(string: (person["bankImage"] as! String)), placeholderImage: UIImage(named: "bankPlaceholderBlack")) // my profile image
            
            imgSelectedBankName.layer.cornerRadius = 50
            imgSelectedBankName.clipsToBounds = true
            
            let defaults = UserDefaults.standard
            defaults.set("", forKey: "keyDoneSelectingBankDetails")
            defaults.set(nil, forKey: "keyDoneSelectingBankDetails")
            
        }
        else {
            print("Never went to that page.")
        }
        
        // bank details
       
    }
    
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
        print("bottomPopupDismissInteractionPercentChanged fromValue: \(oldValue) to: \(newValue)")
    }
}
