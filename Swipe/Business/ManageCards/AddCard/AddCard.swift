//
//  AddCard.swift
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

import Stripe
import CreditCardForm

class AddCard: UIViewController ,STPPaymentCardTextFieldDelegate {

    @IBOutlet weak var creditCardView: CreditCardFormView!
    let paymentTextField = STPPaymentCardTextField()
    
    // card holder name
    var strWhatIsCardHolderName:String!
    
    // card exp month
    var strWhatIsCardExpiryMonth:String!
    // card exp year
    var strWhatIsCardExpiryYear:String!
    
    // card number
    var strWhatIsCardNumber:String!
    
    // card cvc
    var strWhatIsCardCVC:String!
    
    var strWhoIamEditOrAdd:String!
    
    var dictGetManageCardDetails:NSDictionary!
    
    @IBOutlet weak var navigationBar:UIView! {
           didSet {
               // navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
           }
       }
       
       @IBOutlet weak var lblNavigationTitle:UILabel! {
           didSet {
               lblNavigationTitle.text = "Add Card"
               lblNavigationTitle.textColor = .white
           }
       }
       
    @IBOutlet weak var btnBack:UIButton!
    
    @IBOutlet weak var btnEditName:UIButton! {
        didSet {
            btnEditName.setTitleColor(.white, for: .normal)
            btnEditName.layer.cornerRadius = 4
            btnEditName.clipsToBounds = true
            btnEditName.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
        }
    }
    
    @IBOutlet weak var btnDone:UIButton! {
        didSet {
            btnDone.setTitleColor(.white, for: .normal)
            btnDone.layer.cornerRadius = 4
            btnDone.clipsToBounds = true
            btnDone.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // print(strWhoIamEditOrAdd as Any)
        // print(dictGetManageCardDetails as Any)
        
        strWhatIsCardCVC = "0"
        
         let defaults = UserDefaults.standard
         let userName = defaults.string(forKey: "KeyLoginPersonal")
        if userName == "loginViaPersonal" {
            // personal user
            navigationBar.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
            
             btnDone.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
             btnEditName.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
        }
        else {
            navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
            
             btnDone.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
             btnEditName.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
        }
        
        // car strings to nil
        self.strWhatIsCardHolderName = ""
        self.strWhatIsCardExpiryMonth = ""
        self.strWhatIsCardExpiryYear = ""
        self.strWhatIsCardNumber = ""
        self.strWhatIsCardCVC = ""
        
         //btnBack.setImage(UIImage(named: "menuWhite"), for: .normal)
         //sideBarMenu()
        btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        btnDone.addTarget(self, action: #selector(doneClickMethod), for: .touchUpInside)
        btnEditName.addTarget(self, action: #selector(editClickMethod), for: .touchUpInside)
        
        
        
        
        
        
        
        if strWhoIamEditOrAdd == "editCard" {
            /*
            CVV = 123;
            cardId = 96;
            cardNumber = 4242424242424242;
            cardlimit = 1000;
            created = "Feb 5th, 2020, 1:42 pm";
            expMon = 4;
            expYear = 25;
            imageOnCard = "";
            modify = "";
            nameOnCard = amex;
            type = DEBIT;
            userImage = "http://demo2.evirtualservices.com/swiipe/site/img/uploads/users/1581055625SwiipeBusinessEditProfile.jpg";
            userName = purnima2;
            */
            
            self.createTextField2()
            self.creditCardView.cardHolderString = dictGetManageCardDetails["nameOnCard"] as! String
        }
        else {
            self.textFieldAlertViewController()
        }
        
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(AddCard.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func textFieldAlertViewController()  {
        
        let alertController = UIAlertController(title: "Card Holder Name", message: "Please enter card holder name", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Card Holder Name"
        }
        let saveAction = UIAlertAction(title: "Enter", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            
            self.creditCardView.cardHolderString = firstTextField.text!
            self.strWhatIsCardHolderName = firstTextField.text!
            
            self.createTextField()
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action : UIAlertAction!) -> Void in
            
            self.creditCardView.cardHolderString = ""
            self.strWhatIsCardHolderName = ""
            
        })

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
        
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

    @objc func editClickMethod() {
        let alertController = UIAlertController(title: "Card Holder Name", message: "Please enter card holder name", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Card Holder Name"
        }
        let saveAction = UIAlertAction(title: "Enter", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            
            self.creditCardView.cardHolderString = firstTextField.text!
            self.strWhatIsCardHolderName = firstTextField.text!
            
            self.createTextField()
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action : UIAlertAction!) -> Void in
            
            self.creditCardView.cardHolderString = ""
            self.strWhatIsCardHolderName = ""
            
            self.createTextField()
            
        })

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
    
    func createTextField2() {
        paymentTextField.frame = CGRect(x: 15, y: 199, width: self.view.frame.size.width - 30, height: 44)
        paymentTextField.delegate = self
        paymentTextField.translatesAutoresizingMaskIntoConstraints = false
        paymentTextField.borderWidth = 0
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: paymentTextField.frame.size.height - width, width:  paymentTextField.frame.size.width, height: paymentTextField.frame.size.height)
        border.borderWidth = width
        paymentTextField.layer.addSublayer(border)
        paymentTextField.layer.masksToBounds = true
        
        view.addSubview(paymentTextField)
        
        NSLayoutConstraint.activate([
            paymentTextField.topAnchor.constraint(equalTo: creditCardView.bottomAnchor, constant: 20),
            paymentTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            paymentTextField.widthAnchor.constraint(equalToConstant: self.view.frame.size.width-20),
            paymentTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // paymentTextField.text = " hello"
        
        // creditCardView.pay
        
    }
    
    func createTextField() {
        paymentTextField.frame = CGRect(x: 15, y: 199, width: self.view.frame.size.width - 30, height: 44)
        paymentTextField.delegate = self
        paymentTextField.translatesAutoresizingMaskIntoConstraints = false
        paymentTextField.borderWidth = 0
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: paymentTextField.frame.size.height - width, width:  paymentTextField.frame.size.width, height: paymentTextField.frame.size.height)
        border.borderWidth = width
        paymentTextField.layer.addSublayer(border)
        paymentTextField.layer.masksToBounds = true
        
        view.addSubview(paymentTextField)
        
        NSLayoutConstraint.activate([
            paymentTextField.topAnchor.constraint(equalTo: creditCardView.bottomAnchor, constant: 20),
            paymentTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            paymentTextField.widthAnchor.constraint(equalToConstant: self.view.frame.size.width-20),
            paymentTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // paymentTextField.text = " hello"
        
        
        
    }

    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        
        creditCardView.paymentCardTextFieldDidChange(cardNumber: textField.cardNumber, expirationYear: UInt(textField.expirationYear), expirationMonth: UInt(textField.expirationMonth), cvc: textField.cvc)
        
        /*
         /*
         // card exp date
         var strWhatIsCardExpiryDate:String!
         
         // card number
         var strWhatIsCardNumber:String!
         
         // card cvc
         var strWhatIsCardCVC:String!
         */
         */
        if strWhoIamEditOrAdd == "editCard" {
            
        }
        else {
            // self.textFieldAlertViewController()
        
        print(textField.cardNumber as Any)
        print(textField.expirationYear as Any)
        print(textField.expirationMonth as Any)
        print(textField.cvc as Any)
        
        strWhatIsCardNumber = textField.cardNumber
        strWhatIsCardCVC = textField.cvc
            
        // month
        let x : Int = Int(textField.expirationMonth)
        let myString = String(x)
        strWhatIsCardExpiryMonth = myString
        }
        
    }
    
    func paymentCardTextFieldDidEndEditingExpiration(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidEndEditingExpiration(expirationYear: UInt(textField.expirationYear))
        
        // print(textField.expirationYear)
        
        // year
        let x : Int = Int(textField.expirationYear)
        let myString = String(x)
        strWhatIsCardExpiryYear = myString
    }
    
    
    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidBeginEditingCVC()
        // print("text begin")
    }
    
    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidEndEditingCVC()
       // print("text is end now")
        
        
    }
    
    @objc func doneClickMethod() {
        
        
        
        if strWhatIsCardHolderName == "" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Please Enter Card Holder Name", dismissDelay: 1.5, completion:{})
        }
        else
        if strWhatIsCardNumber == "" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Please Enter Card Number", dismissDelay: 1.5, completion:{})
        }
        else
        if strWhatIsCardExpiryYear == "" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Please Enter Card Expiry Year", dismissDelay: 1.5, completion:{})
        }
        else
        if strWhatIsCardExpiryMonth == "" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Please Enter Card Expiry Month", dismissDelay: 1.5, completion:{})
        }
        else
        if strWhatIsCardCVC == "" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Please Enter Card CVC", dismissDelay: 1.5, completion:{})
            
            // print(strWhatIsCardCVC.count as Any)
            
        }
        else
        if strWhatIsCardCVC == nil {
             CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Please Enter Card CVC", dismissDelay: 1.5, completion:{})
        }
        else {
            // print("YES ITS DONE")
            // self.addCardWB()
            
            if strWhatIsCardCVC.count == 0 {
                CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Please Enter Card CVC", dismissDelay: 1.5, completion:{})
            }
            else if strWhatIsCardCVC.count == 1 {
                CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Please Enter Card CVC", dismissDelay: 1.5, completion:{})
            }
            else if strWhatIsCardCVC.count == 2 {
                CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Please Enter Card CVC", dismissDelay: 1.5, completion:{})
            }
            else {
                self.addCardWB()
            }
        }
    }
    
    
    // MARK:- ADD CARDS WEBSERVICE
    @objc func addCardWB() {
        self.view.endEditing(true)
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
           
        /*
         [action] => addcard
         [userId] => 74
         [cardNumber] => 2222222222222222
         [nameOnCard] => GGG
         [expMon] => 12
         [expYear] => 25
         [CVV] => 125
         [cardlimit] => 1000
         [type] => DEBIT
         */
        
        // print(strWhatIsCardCVC.count)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
                   parameters = [
                       "action"         : "addcard",
                        "userId"        : String(myString),
                        "cardNumber"    : String(strWhatIsCardNumber),
                        "nameOnCard"    : String(strWhatIsCardHolderName),
                        "expMon"       : String(strWhatIsCardExpiryMonth),
                        "expYear"       : String(strWhatIsCardExpiryYear),
                        "CVV"          : String(strWhatIsCardCVC),
                        "cardlimit"     : String("1000"),
                        "type"         : String("DEBIT"),
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
                                
                                    // self.loginWBClickMethod()
                                   
                                ERProgressHud.sharedInstance.hide()
                                self.navigationController?.popViewController(animated: true)
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

extension UITextField {

 func addDoneButtonToKeyboard(myAction:Selector?) {
    let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    doneToolbar.barStyle = UIBarStyle.default

    let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
    let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: myAction)

    var items = [UIBarButtonItem]()
    items.append(flexSpace)
    items.append(done)

    doneToolbar.items = items
    doneToolbar.sizeToFit()

    self.inputAccessoryView = doneToolbar
 }
}
