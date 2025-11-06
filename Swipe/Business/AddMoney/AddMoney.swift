//
//  AddMoney.swift
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

import Stripe

class AddMoney: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource {

    var arrWallet = ["Payment Type", "Bank Account","Saved Card"]
    
    var arrBankAccount = ["Account", "Account Type 1","Account Type 2","Account Type 3","Account Type 4","Account Type 5"]
    
    var itemSelected = ""
    
    var pickerView: UIPickerView?
    var pickerViewSection: UIPickerView?
    
    var myStripeTokeinIdIs:String!
    
    // array list
    var arrListOfAllCards:Array<Any>!
    
    // save ids
    var saveCardId:String!
    var saveBankAccountId:String!
    var saveBankAccountSimpleId:String!
    var saveTransactionId:String!
    
    // who are you
    var strGetBankOrCard:String!
    
    // bottom view popup
    var height: CGFloat = 600 // height
    var topCornerRadius: CGFloat = 35 // corner
    var presentDuration: Double = 0.8 // present view time
    var dismissDuration: Double = 0.5 // dismiss view time
    let kHeightMaxValue: CGFloat = 600 // maximum height
    let kTopCornerRadiusMaxValue: CGFloat = 35 //
    let kPresentDurationMaxValue = 3.0
    let kDismissDurationMaxValue = 3.0
    
    //
    @IBOutlet weak var lblAddMoneyFrom:UILabel!
    
    @IBOutlet weak var navigationBar:UIView! {
           didSet {
               navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
           }
       }
       
       @IBOutlet weak var lblNavigationTitle:UILabel! {
           didSet {
               lblNavigationTitle.text = "ADD MONEY"
               lblNavigationTitle.textColor = .white
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
            lblTotalAmountInWallet.textColor = .white
            lblTotalAmountInWallet.backgroundColor = UIColor.init(red: 100.0/255.0, green: 206.0/255.0, blue: 225.0/255.0, alpha: 1)
        }
    }
    
    @IBOutlet weak var btnOpenBottomSheet:UIButton!
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        }
    }
    
    @IBOutlet var txtAddMoneyTo: UITextField! {
        didSet {
            textFieldCustomMethod(textField: txtAddMoneyTo, placeholder: "Wallet")
        }
    }
    
    @IBOutlet var txtAddMoneyFrom: UITextField! {
        didSet {
            textFieldCustomMethod(textField: txtAddMoneyFrom, placeholder: "Bank Account")
            txtAddMoneyFrom.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet var txtAmount: UITextField! {
        didSet {
            txtAmount.keyboardType = .decimalPad
            textFieldCustomMethod(textField: txtAmount, placeholder: "200")
        }
    }
    
    @IBOutlet weak var btnAddMoney:UIButton! {
        didSet {
            btnAddMoney.setTitleColor(.white, for: .normal)
            btnAddMoney.setTitle("Submit", for: .normal)
            btnAddMoney.addTarget(self, action: #selector(addAccountClickMethod), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white;
        
        self.myStripeTokeinIdIs = ""
        
        txtAmount.delegate = self
        setPaddingWithImage(image: UIImage(named:"dollarCashout")!, textField: txtAmount)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person)
            
            // let x : NSNumber = person["wallet"] as! NSNumber
            // self.lblTotalAmountInWallet.text = "$ "+"\(x)"
            
            let x : Double = person["wallet"] as! Double
            let foo = x.rounded(digits: 2)
            self.lblTotalAmountInWallet.text = "$ "+"\(foo)"
            
            
            /*
            let livingArea = person["wallet"] as? Int ?? 0
            if livingArea == 0 {
                let stringValue = String(livingArea)
                lblTotalAmountInWallet.text = "$ "+stringValue+"     "
            }
            else
            {
                let stringValue = String(livingArea)
                lblTotalAmountInWallet.text = "$ "+stringValue+"     "
            }
            
            */
        }
        else {
            lblTotalAmountInWallet.text = "$0"
        }

        let defaults = UserDefaults.standard
        let userName = defaults.string(forKey: "KeyLoginPersonal")
        if userName == "loginViaPersonal" {
            // personal user
            navigationBar.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
             // self.view.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
            btnAddMoney.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
        }
        else {
            navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
            // self.view.backgroundColor = BUTTON_BACKGROUND_COLOR_BLUE
            btnAddMoney.backgroundColor = BUTTON_BACKGROUND_COLOR_BLUE
        }
        
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(AddMoney.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        btnOpenBottomSheet.addTarget(self, action: #selector(openBottomSheetClickMethod), for: .touchUpInside)
        pickerDelegateCallMethod()
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func setPaddingWithImage(image: UIImage, textField: UITextField){
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 50))
        imageView.frame = CGRect(x: 13.0, y: 13.0, width: 24.0, height: 24.0)
        //For Setting extra padding other than Icon.
        let seperatorView = UIView(frame: CGRect(x: 50, y: 0, width: 2, height: 50))
        seperatorView.backgroundColor = .clear//UIColor(red: 80/255, green: 89/255, blue: 94/255, alpha: 1)
        view.addSubview(seperatorView)
        textField.leftViewMode = .always
        view.addSubview(imageView)
        view.backgroundColor = .clear
        textField.leftViewMode = UITextField.ViewMode.always
        textField.leftView = view
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtAmount {
            
        
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
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        // sideBarMenuClick()
        
        let defaults = UserDefaults.standard
        if let name = defaults.string(forKey: "keySideBarMenu") {
            // print(name)
            if name == "dSideBar" {
                btnBack.setImage(UIImage(named: "menuWhite"), for: .normal)
                sideBarMenuClick()
            }
            else {
                btnBack.setImage(UIImage(named: "backs"), for: .normal)
                btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
            }
        }
        else
        {
            btnBack.setImage(UIImage(named: "backs"), for: .normal)
            btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
        
    }
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func sideBarMenuClick() {
        
        self.view.endEditing(true)
        
        if revealViewController() != nil {
        btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
          }
    }
    @objc func openBottomSheetClickMethod() {
        // print(txtAddMoneyTo.text as Any)
        if txtAddMoneyTo.text == "Saved Card" {
            
            self.view.endEditing(true)
            
            guard let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "secondVC") as? ExamplePopupViewController else { return }
            popupVC.height = self.height
            popupVC.topCornerRadius = self.topCornerRadius
            popupVC.presentDuration = self.presentDuration
            popupVC.dismissDuration = self.dismissDuration
            //popupVC.shouldDismissInteractivelty = dismissInteractivelySwitch.isOn
            popupVC.popupDelegate = self
            popupVC.strGetDetails = "savedCardsFromAddMoney"
            //popupVC.getArrListOfCategory =
            popupVC.arrListOfSavedCards = self.arrListOfAllCards as NSArray?
            self.present(popupVC, animated: true, completion: nil)
        }
        else
        if txtAddMoneyTo.text == "Bank Account" {
            
            self.view.endEditing(true)
            
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
        else
        {
            
        }
    }
    
    @objc func pickerDelegateCallMethod() {
        //UIPICKER
        self.pickerView = UIPickerView()
        self.pickerView?.delegate = self //#1
        self.pickerView?.dataSource = self //#1
        
        self.pickerViewSection = UIPickerView()
        self.pickerViewSection?.delegate = self //#2
        self.pickerViewSection?.dataSource = self //#2
               
        txtAddMoneyTo.inputView = self.pickerView
        txtAddMoneyFrom.inputView = self.pickerViewSection
               
        let defaults = UserDefaults.standard
        let userName = defaults.string(forKey: "KeyLoginPersonal")
        if userName == "loginViaPersonal" {
            self.pickerView?.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
            self.pickerViewSection?.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
        }
        else {
            self.pickerView?.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
            self.pickerViewSection?.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
        }
        
        
        
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
        
    @objc func backClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldCustomMethod(textField: UITextField,placeholder:String){
        textField.delegate = self
        textField.backgroundColor = .clear
        textField.placeholder = placeholder
        textField.keyboardAppearance = .dark
        textField.textAlignment = .left
        textField.textColor = .black
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.font : UIFont(name: "OpenSans-Bold", size: 12)!
        ]

        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes:attributes)
        
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 2.0))
        textField.leftView = leftView
        textField.leftViewMode = .always
        
        
        // lower border
        let bottomLine = CALayer()
        
        let result = UIScreen.main.bounds.size
        //NSLog("%f",result.height)
        
        if result.height == 667 // 8
        {
            bottomLine.frame = CGRect(x : 0.0 ,y : textField.frame.height - 1 ,width : textField.frame.width-40,height : 1.0)
        }
        else
            if result.height == 736 // 8 plus
            {
                bottomLine.frame = CGRect(x : 0.0 ,y : textField.frame.height - 1 ,width : textField.frame.width,height : 1.0)
            }
        else
           if result.height == 896 // 11 , 11 pro max
           {
               bottomLine.frame = CGRect(x : 0.0 ,y : textField.frame.height - 1 ,width : textField.frame.width,height : 1.0)
           }
        else
            if result.height == 812 // 11 pro
            {
                bottomLine.frame = CGRect(x : 0.0 ,y : textField.frame.height - 1 ,width : textField.frame.width-40,height : 1.0)
            }
        
        bottomLine.backgroundColor = UIColor.black.cgColor
        textField.borderStyle = UITextField.BorderStyle.none
        textField.layer.addSublayer(bottomLine)
        
    }
    
    //    picker delegates
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if txtAddMoneyTo.isFirstResponder
        {
            return arrWallet.count
        }
        else
        if txtAddMoneyFrom.isFirstResponder
        {
            return arrBankAccount.count
        }
        
        return 0
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        
        if txtAddMoneyTo.isFirstResponder {
            return  arrWallet[row]
        }
        else
        if txtAddMoneyFrom.isFirstResponder {
            return arrBankAccount[row]
        }
        
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if txtAddMoneyTo.isFirstResponder {
            let itemselected = arrWallet[row]
            txtAddMoneyTo.text = itemselected
            
            txtAddMoneyFrom.isUserInteractionEnabled = true
            
            if itemselected == "Bank Account" {
                print("bank account")
                listOfBankWB()
            }
            else if itemselected == "Saved Card" {
                print("saved card")

                listOfSavedCard()
            }
        }
        else
        if txtAddMoneyFrom.isFirstResponder {
            let itemselected = arrBankAccount[row]
            txtAddMoneyFrom.text = itemselected
        }
    }
    
    // MARK:- LOGIN WEBSERVICE
    @objc func listOfSavedCard() {
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
                       "action"     : "listcard",
                    "userId"   : String(myString),
                    "type"      : "DEBIT"
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
                                 CVV = 321;
                                 cardId = 66;
                                 cardNumber = 4747474747474747;
                                 cardlimit = 1000;
                                 created = "Dec 12th, 2019, 1:03 pm";
                                 expMon = 08;
                                 expYear = 25;
                                 imageOnCard = "";
                                 modify = "";
                                 nameOnCard = PURNIMA;
                                 type = DEBIT;
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
    
    /*
     [action] => bankaccountlist
        [userId] => 74
     */
    
    // MARK:- LIST OF BANKS
    @objc func listOfBankWB() {
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
                                  print(JSON)
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
    
    @objc func addAccountClickMethod() {
        // let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CashoutId") as? Cashout
        // self.navigationController?.pushViewController(settingsVCId!, animated: true)
        addMoneyWB()
    }
    
    /*
     @Field("action") String action,
     @Field("userId") String userId,
     @Field("transactionID") String transactionID,
     @Field("amount") String amount,
     @Field("transactionBy") String transactionBy,
     @Field("cardId") String cardId,
     @Field("bankaccountId") String bankaccountId
     */
    // saveTransactionId
    
    
    
    
    //MARK:- ADD MONEY
    @objc func addMoneyWB() {
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
        
        let urlString = payment_url_for_add_money
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person)
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            let myString23 = String(txtAmount.text!)
            let myDouble = Double(myString23)
            
            if strGetBankOrCard == "CARD" {
                parameters = [
                    "action"         : "chargerAmount",
                    "userId"         : String(myString),
                    "tokenId"        : String(self.myStripeTokeinIdIs),
                    "amount"         : myDouble!*Double(100)
                ]
            }
            else
                if strGetBankOrCard == "BANK" {
                if("\(person["stripeCustomerNo"]!)" == "") {
                 print("Yes, Cutomer No is empty")
                    self.createStripeCustomerId()
                    
                    return
                }
                parameters = [
                    "action"        :"chargebybank",
                    "cutomer_id"    :"\(person["stripeCustomerNo"]!)",
                    "amount"        :"\(myDouble!)",
                    "stripeBankAccountNo":String(saveBankAccountId)
                ]
                    /*parameters = [
                        "action"            : "addmoney",
                        "userId"            : String(myString),
                        "transactionID"     : String(saveTransactionId),
                        "amount"            : String(""),
                        "transactionBy"     : String(strGetBankOrCard),
                        "cardId"            : "",
                        "bankaccountId"     : String(saveBankAccountId)
                    ]*/
                }
        }
        
        print("parameters-------\(String(describing: parameters))")
        
        Alamofire.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON {
            response in
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value {
                    
                    
                    let JSON = data as! NSDictionary
                    print(JSON)
                    
                    /*
                     amount = 200;
                     captured = 1;
                     card = "card_1G6Fn2Bnk7ygV50qSFP8tCIG";
                     currency = usd;
                     paymentResponseString = "{\"tokeId\":\"ch_1G6FnEBnk7ygV50qPQy9Iztk\",\"balance_transaction\":\"txn_1G6FnEBnk7ygV50qKlIjs4bg\",\"captured\":\"1\",\"description\":\"Payment from app by User :74\",\"status\":\"succeeded\"}";
                     status = Success;
                     tokeId = "ch_1G6FnEBnk7ygV50qPQy9Iztk";
                     */
                    
                    var strSuccess : String!
                    strSuccess = JSON["status"]as Any as? String
                    
                    var strSuccessAlert : String!
                    strSuccessAlert = JSON["msg"]as Any as? String
                    
                    if strSuccess == "success" {
                        // ERProgressHud.sharedInstance.hide()
                        
                        self.myStripeTokeinIdIs = ""
                        
                        var dict: Dictionary<AnyHashable, Any>
                        dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                        
                        var strSuccess2 : String!
                        strSuccess2 = dict["card"] as Any as? String
                        
                        // var strSuccessAlert2 : String!
                        // strSuccessAlert2 = JSON["card"]as Any as? String
                        
                        if self.strGetBankOrCard == "CARD" {
                            self.sendFinalPaymentToOurServer(strCardResponse: strSuccess2)
                        } else {
                            self.sendFinalPaymentToOurServerToBank(strCardResponse: strSuccess2)
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
    
    
    
    // MARK: - REGISTER STRIPE ACCOUNT AFTER EVS ACCOUNT -
    @objc func createStripeCustomerId() {
        self.view.endEditing(true)
        
        let urlString = base_url_create_Stripe_customer
        
        var parameters:Dictionary<AnyHashable, Any>!
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person)
            parameters = [
                "action"        : "createCustomer",
                "email"         : "\(person["email"]!)"
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
                    
                    if strSuccess == "success" {
                        
                        var strSuccess2 : String!
                        strSuccess2 = JSON["stripeCustomerNo"]as Any as? String
                        
                        self.edit_profile_after_success_register_stripe_wb(strStripeCustomerNumber: strSuccess2)
                            
                    }
                    else {
                        
                        CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Something went wrong. Please try again after some time", dismissDelay: 1.5, completion:{})
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
    
    @objc func edit_profile_after_success_register_stripe_wb(strStripeCustomerNumber:String) {
        self.view.endEditing(true)
        let urlString = BASE_URL_SWIIPE
        var parameters:Dictionary<AnyHashable, Any>!
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
                         
                        var strSuccess : String!
                        strSuccess = JSON["status"]as Any as? String
                        
                        if strSuccess == "success" {
                            
                            self.addMoneyWB()
                            
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
    
    
    
    @objc func sendFinalPaymentToOurServerToBank(strCardResponse:String) {
       
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
                           "action"         : "addmoney",
                           "userId"         : String(myString),
                           "transactionID"  : "",
                           "amount"         : String(self.txtAmount.text!),
                           "transactionBy"  : String("BANK"),
                           "cardId"         : String(""),
                           "bankaccountId"  : String(saveBankAccountSimpleId)
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
                                    
                                       // var dict: Dictionary<AnyHashable, Any>
                                       // dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                                       
                                       // let defaults = UserDefaults.standard
                                       // defaults.setValue(dict, forKey: "keyLoginFullData")
                                       
                                     CRNotifications.showNotification(type: CRNotifications.success, title: "Message!", message:strSuccessAlert, dismissDelay: 1.5, completion:{})
                                    
                                        // self.loginWBClickMethod()
                                    
                                    self.view.endEditing(true)
                                    
                                    self.profileWB()
                                    
                                    // ERProgressHud.sharedInstance.hide()
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
        
           //}
    }
    
    
    @objc func sendFinalPaymentToOurServer(strCardResponse:String) {
       
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
                           "action"         : "addmoney",
                           "userId"         : String(myString),
                           "transactionID"  : String(strCardResponse),
                           "amount"         : String(self.txtAmount.text!),
                           "transactionBy"  : String("CARD"),
                           "cardId"         : String(saveCardId),
                           "bankaccountId"  : String("")
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
                                    
                                       // var dict: Dictionary<AnyHashable, Any>
                                       // dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                                       
                                       // let defaults = UserDefaults.standard
                                       // defaults.setValue(dict, forKey: "keyLoginFullData")
                                       
                                     CRNotifications.showNotification(type: CRNotifications.success, title: "Message!", message:strSuccessAlert, dismissDelay: 1.5, completion:{})
                                    
                                        // self.loginWBClickMethod()
                                    
                                    self.view.endEditing(true)
                                    
                                    self.profileWB()
                                    
                                    // ERProgressHud.sharedInstance.hide()
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
        
           //}
    }
    
    
    /*
     [action] => profile
     [userId] => 74
     */
    
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
                                
                                
                                
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            let x : NSNumber = person["wallet"] as! NSNumber
            self.lblTotalAmountInWallet.text = "$ "+"\(x)"
            
             
            
            
            let userName = defaults.string(forKey: "KeyLoginPersonal")
            if userName == "loginViaPersonal" {
                // personal user
                 // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
                // PersonalDashbaord
                let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PersonalDashbaordId") as? PersonalDashbaord
                self.navigationController?.pushViewController(settingsVCId!, animated: true)
            }
            else {
                 let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BusinessDashbaordId") as? BusinessDashbaord
                 self.navigationController?.pushViewController(settingsVCId!, animated: true)
            }
            
            
            
               }
               else
               {
                self.lblTotalAmountInWallet.text = "$0"
               }
                                
                                self.txtAmount.text = ""
                                self.txtAddMoneyFrom.text = ""
                                self.txtAddMoneyTo.text = ""
                                
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
 
    // func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        // let text: NSString = (textField.text ?? "") as NSString
        // let finalString = text.replacingCharacters(in: range, with: string)

        // 'currency' is a String extension that doews all the number styling
        // txtAmount.text = finalString.currency

        // returning 'false' so that textfield will not be updated here, instead from styling extension
        // return false
    // }
    
}

extension AddMoney: BottomPopupDelegate {
    
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
        
        // let buttonPosition = sender.convert(CGPoint.zero, to: self.tbleView)
        // let indexPath = self.tbleView.indexPathForRow(at:buttonPosition)
        // let cell = self.tbleView.cellForRow(at: indexPath!) as! EditProfileTableCell
                
        // card details
        if let person = UserDefaults.standard.value(forKey: "keyDoneSelectingCardDetails") as? [String:Any]
        {
             // print(person as Any)
            
            /*
             ["modify": , "expYear": 24, "created": Jan 22nd, 2020, 7:32 pm, "userImage": http://demo2.evirtualservices.com/swiipe/site/img/uploads/users/1576134757images(8).jpeg, "expMon": 12, "CVV": 123, "nameOnCard": Test Again, "cardlimit": 1000, "imageOnCard": , "cardId": 92, "cardNumber": 4242424242424242, "userName": purnima2, "type": DEBIT]
             */
            
            self.lblAddMoneyFrom.text = "Add Money From ( Card )"
            
            // Create an STPCardParams instance
            let defaults = UserDefaults.standard
            let userName = defaults.string(forKey: "KeyLoginPersonal")
            if userName == "loginViaPersonal" {
                // personal user
                 ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
                
            }
            else {
                 ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            }
            
            let cardParams = STPCardParams()
            // cardParams.number = (person["cardNumber"] as! String) // ""
            // cardParams.expMonth = UInt((person["expMon"] as! NSString).doubleValue)
            // cardParams.expYear = UInt((person["expYear"] as! NSString).doubleValue)
            // cardParams.cvc = (person["CVV"] as! String) // ""
            
            cardParams.number = (person["cardNumber"] as! String) // "4242424242424242"
            cardParams.expMonth = UInt((person["expMon"] as! NSString).doubleValue)
            cardParams.expYear = UInt((person["expYear"] as! NSString).doubleValue)//25
            cardParams.cvc = (person["CVV"] as! String)//"242"

                // Pass it to STPAPIClient to create a Token
            STPAPIClient.shared.createToken(withCard: cardParams) { token, error in
                guard let token = token else {
                    // Handle the error
                    ERProgressHud.sharedInstance.hide()
                    return
                }
                let tokenID = token.tokenId
                print(tokenID)
                self.myStripeTokeinIdIs = tokenID
                ERProgressHud.sharedInstance.hide()
            }
            
            
            
            
             let x : Int = (person["cardId"] as! Int)
             let myString = String(x)
             print(myString as Any)
            
            saveCardId = myString
            
            strGetBankOrCard = "CARD"
            
            // transaction id
            //let x1 : Int = (person["cardId"] as! Int)
            //let myString1 = String(x1)
            saveTransactionId = "tok_1G1TJqBnk7ygV50qStTUp7x3"
            
            txtAddMoneyFrom.text = (person["nameOnCard"] as! String)
            
            /*
             ["userImage": http://demo2.evirtualservices.com/swiipe/site/img/uploads/users/1576134757images(8).jpeg, "imageOnCard": , "type": DEBIT, "CVV": 242, "created": Jan 16th, 2020, 11:55 am, "cardlimit": 1000, "userName": purnima, "cardNumber": 4242424242424242, "modify": , "expMon": 12, "cardId": 86, "nameOnCard": HSSJSHJS, "expYear": 25]

             */
            
            // let defaults = UserDefaults.standard
            defaults.set("", forKey: "keyDoneSelectingCardDetails")
            defaults.set(nil, forKey: "keyDoneSelectingCardDetails")
            
        }
        else
        {
            print("Never went to that page buddy.")
        }
        
        
        // bank details default
        if let person = UserDefaults.standard.value(forKey: "keyDoneSelectingBankDetails") as? [String:Any]
        {
             print(person as Any)
            
            self.lblAddMoneyFrom.text = "Add Money From ( Bank )"
            
//            let x : Int = (person["stripeBankAccountNo"] as! Int)
//            let myString = String(x)
//            print(myString as Any)
            
            saveBankAccountId = "\(person["stripeBankAccountNo"] ?? "na")"
            saveBankAccountSimpleId = "\(person["bankaccountId"]!)"
            
            // print(saveBankAccountId as Any)
            strGetBankOrCard = "BANK"
            saveTransactionId = "tok_1G1TJqBnk7ygV50qStTUp7x3"
            
            txtAddMoneyFrom.text = (person["bankName"] as! String)
            
            /*
             ["accountName": purnima, "modify": , "created": Dec 12th, 2019, 1:02 pm, "bankName": WELLS FARGO, "routingNo": 9876412343, "bankImage": http://demo2.evirtualservices.com/swiipe/site/img/uploads/bank/Wells_Fargo_Bank.svg.png, "accountNumber": 1236549874563, "bankaccountId": 70, "userImage": http://demo2.evirtualservices.com/swiipe/site/img/uploads/users/1576134757images(8).jpeg, "userName": purnima]
             */
            
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

extension String {
    var currency: String {
        // removing all characters from string before formatting
        let stringWithoutSymbol = self.replacingOccurrences(of: "$", with: "")
        let stringWithoutComma = stringWithoutSymbol.replacingOccurrences(of: ",", with: "")

        let styler = NumberFormatter()
        styler.minimumFractionDigits = 0
        styler.maximumFractionDigits = 0
        styler.currencySymbol = "$"
        styler.numberStyle = .currency

        if let result = NumberFormatter().number(from: stringWithoutComma) {
            return styler.string(from: result)!
        }

        return self
    }
}
