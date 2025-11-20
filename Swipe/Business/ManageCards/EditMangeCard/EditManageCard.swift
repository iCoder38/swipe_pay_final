//
//  EditManageCard.swift
//  Swipe
//
//  Created by evs_SSD on 2/18/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit
import Alamofire
import CRNotifications

class EditManageCard: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "Edit Card"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var btnBack:UIButton!
    
    @IBOutlet weak var txtCardHolderName:UITextField! {
        didSet {
            txtCardHolderName.layer.borderWidth = 0.8
            txtCardHolderName.layer.borderColor = UIColor.init(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1).cgColor
            txtCardHolderName.backgroundColor = UIColor.init(red: 251.0/255.0, green: 251.0/255.0, blue: 251.0/255.0, alpha: 1)
            txtCardHolderName.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: txtCardHolderName.frame.height))
            txtCardHolderName.leftViewMode = .always
        }
    }
    @IBOutlet weak var txtCardNumber:UITextField! {
        didSet {
            txtCardNumber.layer.borderWidth = 0.8
            txtCardNumber.layer.borderColor = UIColor.init(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1).cgColor
            txtCardNumber.backgroundColor = UIColor.init(red: 251.0/255.0, green: 251.0/255.0, blue: 251.0/255.0, alpha: 1)
            txtCardNumber.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: txtCardNumber.frame.height))
            txtCardNumber.leftViewMode = .always
        }
    }
    @IBOutlet weak var txtExpiryDate:UITextField! {
        didSet {
            txtExpiryDate.layer.borderWidth = 0.8
            txtExpiryDate.layer.borderColor = UIColor.init(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1).cgColor
            txtExpiryDate.backgroundColor = UIColor.init(red: 251.0/255.0, green: 251.0/255.0, blue: 251.0/255.0, alpha: 1)
            txtExpiryDate.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: txtCardNumber.frame.height))
            txtExpiryDate.leftViewMode = .always
            txtExpiryDate.textAlignment = .center
            txtExpiryDate.keyboardType = .numberPad
        }
    }
    @IBOutlet weak var txtCVV:UITextField! {
        didSet {
            txtCVV.layer.borderWidth = 0.8
            txtCVV.layer.borderColor = UIColor.init(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1).cgColor
            txtCVV.backgroundColor = UIColor.init(red: 251.0/255.0, green: 251.0/255.0, blue: 251.0/255.0, alpha: 1)
            txtCVV.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: txtCVV.frame.height))
            txtCVV.leftViewMode = .always
            txtCVV.textAlignment = .center
            txtCVV.keyboardType = .phonePad
        }
    }
    
    @IBOutlet weak var btnSubmit:UIButton! {
        didSet {
            btnSubmit.backgroundColor = BUTTON_BACKGROUND_COLOR_BLUE
            btnSubmit.layer.cornerRadius = 4
            btnSubmit.clipsToBounds = true
            btnSubmit.setTitleColor(.white, for: .normal)
            btnSubmit.setTitle("Submit", for: .normal)
            btnSubmit.addTarget(self, action: #selector(editCardWB), for: .touchUpInside)
        }
    }
    
    var dictGetManageCardDetails:NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        txtCardHolderName.delegate = self
        txtCardNumber.delegate = self
        txtExpiryDate.delegate = self
        txtCVV.delegate = self
        
        txtCardHolderName.text = (dictGetManageCardDetails["nameOnCard"] as! String)
        txtCardNumber.text = (dictGetManageCardDetails["cardNumber"] as! String)
        txtExpiryDate.text = (dictGetManageCardDetails["expMon"] as! String)+"/"+(dictGetManageCardDetails["expYear"] as! String)
        txtCVV.text = (dictGetManageCardDetails["CVV"] as! String)
        
        btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // le t indexPath = IndexPath(row: 0, section: 0)
        // let cell = self.tbleView.cellForRow(at: indexPath) as! AddProcessCardTwoTableCell
        
        let newLength = (textField.text ?? "").count + string.count - range.length
        if(textField == txtCardNumber) {
            return newLength <= 19
        }
        
        if(textField == txtCVV) {
            return newLength <= 3
        }
        // exp date
        if textField == txtExpiryDate {
            if range.length > 0 {
                return true
            }
            if string == "" {
                return false
            }
            if range.location > 4 {
                return false
            }
            var originalText = textField.text
            let replacementText = string.replacingOccurrences(of: " ", with: "")
            
            //Verify entered text is a numeric value
            if !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: replacementText)) {
                return false
            }
            
            //Put / after 2 digit
            if range.location == 2 {
                originalText?.append("/")
                textField.text = originalText
            }
        }
        
        return true
    }
    
    
    // MARK:- EDIT CARD WEBSERVICE
    // editcard
    
    /*
     @Field("action") String action,
     @Field("userId") String userId,
     @Field("cardId") String cardId,
     @Field("cardNumber") String cardNumber,
     @Field("nameOnCard") String nameOnCard,
     @Field("expMon") String expMon,
     @Field("expYear") String expYear,
     @Field("CVV") String CVV,
     @Field("cardlimit") String cardlimit,
     @Field("type") String type
     */
    
    
    
    @objc func editCardWB() {
        
        
        if txtCardHolderName.text == "" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Field should not be Empty.", dismissDelay: 1.5, completion:{})
        }
        else
        if txtCardNumber.text == "" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Field should not be Empty.", dismissDelay: 1.5, completion:{})
        }
        else
        if txtExpiryDate.text == "" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Field should not be Empty.", dismissDelay: 1.5, completion:{})
        }
        else
        if txtCVV.text == "" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Field should not be Empty.", dismissDelay: 1.5, completion:{})
        }
        else {
            
            
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
                
                let parts = String(txtExpiryDate.text!).components(separatedBy: "/")
                let month = parts.first ?? ""
                let year = parts.last ?? ""
                
                parameters = [
                    "action"         : "editcard",
                    "userId"         : String(myString),
                    "cardId"         : dictGetManageCardDetails["cardId"] as! Int,
                    "cardNumber"     : String(txtCardNumber.text!),
                    "nameOnCard"     : String(txtCardHolderName.text!),
                    "expMon"         :  String(month),
                    "expYear"        : String(year),
                    "CVV"            : String(txtCVV.text!),
                    "cardlimit"      : String("1000"),
                    "type"           : String("DEBIT"),
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
                        
                        if strSuccess == "success" {
                            ERProgressHud.sharedInstance.hide()
                        }
                        else{
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
