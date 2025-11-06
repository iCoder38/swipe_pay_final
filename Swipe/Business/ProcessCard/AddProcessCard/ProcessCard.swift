//
//  ProcessCard.swift
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

class ProcessCard: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {

    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?
    
    let cellReuseIdentifier = "addProcessCardTableCell"
    
    var arrClassValues = ["Select On/Off", "ON","OFF"]
    
    var itemSelected = ""
    
    var pickerView: UIPickerView?
    
    // save percentage in string
    var strSavePercentage:String!
    
    var strFinalResultPercentage:String!
    
    // array list
    var arrListOfProcessingCards:Array<Any>!
    
    @IBOutlet weak var navigationBar:UIView! {
           didSet {
               navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
           }
       }
       
       @IBOutlet weak var lblNavigationTitle:UILabel! {
           didSet {
               lblNavigationTitle.text = "PROCEED CARD"
               lblNavigationTitle.textColor = .white
           }
       }

    
    @IBOutlet weak var btnSubmit:UIButton! {
        didSet {
            setButtonUI(btnUiDesign: btnSubmit, strText: "Submit")
            btnSubmit.addTarget(self, action: #selector(pushToInvoice), for: .touchUpInside)
        }
    }
    
    
    
    @IBOutlet weak var tbleView: UITableView! {
            didSet
            {
                tbleView.delegate = self
                tbleView.dataSource = self
                self.tbleView.backgroundColor = .white
                self.tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))

            }
    }
    
    @IBOutlet weak var lblCardNumber:UILabel!
    
    
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        // detect card type
        // txtCardNumber.addTarget(self, action: #selector(reformatAsCardNumber), for: .editingChanged)
        
        let defaults = UserDefaults.standard
        let userName = defaults.string(forKey: "KeyLoginPersonal")
        if userName == "loginViaPersonal" {
            // personal user
            navigationBar.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
             // self.view.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
        }
        else {
            navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
            // self.view.backgroundColor = BUTTON_BACKGROUND_COLOR_BLUE
        }
        
          //UIPICKER
         self.pickerView = UIPickerView()
         self.pickerView?.delegate = self //#1
         self.pickerView?.dataSource = self //#1
                
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! AddProcessCardTableCell
        
        cell.txtFeeOnOff.inputView = self.pickerView;
              
        self.pickerView?.backgroundColor = BUTTON_BACKGROUND_COLOR
                
        self.processingChargeWB()
    }
    
    
    //    picker delegates
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! AddProcessCardTableCell
        
        if cell.txtFeeOnOff.isFirstResponder {
            return arrClassValues.count
        }

        return 0
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! AddProcessCardTableCell
        
        if cell.txtFeeOnOff.isFirstResponder
        {
            return arrClassValues[row]
        }
        
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! AddProcessCardTableCell
        
        //cell.lblProcessingFee.text = "PROCESSING FEE( 0% ): $0"
        
        if cell.txtFeeOnOff.isFirstResponder
        {
            if cell.txtInvoiceAmount.text == "" {
                CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Please Enter Invoice amount", dismissDelay: 1.5, completion:{})
            }
            else
            {
                
            
            
            let itemselected = arrClassValues[row]
            cell.txtFeeOnOff.text = itemselected
            
            if itemselected == "ON" {
                if cell.txtInvoiceAmount.text == "" {
                    CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Please Enter Invoice amount", dismissDelay: 1.5, completion:{})
                }
                else
                {
                    cell.lblProcessingFee.text = "PROCESSING FEE( 3% ): $0"
                    
                    // print(strSavePercentage as Any)
                    
                    // convert String to Int ( convert percantage to Int )
                    let myString1 = strSavePercentage
                    let myInt1 = Int(myString1!)
                    
                    // convert String to Int ( convert invoice amount text to Int )
                    let myString2 = cell.txtInvoiceAmount.text
                    let myInt2 = Int(myString2!)
                    
                    let result: Double = Double(myInt2!) * Double(myInt1!)/100+Double(myInt2!)
                    cell.txtTotalPayableAmount.text = String(format:"$ "+"%.02f", result)
                    
                    strFinalResultPercentage = String(format:"%.02f", result)
                }
            }
            else if itemselected == "OFF" {
                cell.lblProcessingFee.text = "PROCESSING FEE( 0% ): $0"
                cell.txtTotalPayableAmount.text = "$ "+cell.txtInvoiceAmount.text!
                strFinalResultPercentage = cell.txtInvoiceAmount.text
            }
            else {
                cell.lblProcessingFee.text = "PROCESSING FEE( 0% ): $0"
            }
        } // close
        }
    }
 
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! AddProcessCardTableCell
        
        if (cell.txtInvoiceAmount!.text != nil) {
            print("yes i am hit")
            cell.txtFeeOnOff.text = ""
            cell.txtTotalPayableAmount.text = "$ "+cell.txtInvoiceAmount.text!
            strFinalResultPercentage = cell.txtInvoiceAmount.text!
        }
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
    
    @objc func pushToInvoice() {
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "InvoiceId") as? Invoice
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
    }

    //MARK:- TEXT FIELD UI
    func setPaddingWithImage(textField: UITextField,strPlaceholder:String) {
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: textField.frame.height - 1, width: textField.frame.width, height: 1.0)
        textField.placeholder = strPlaceholder
        bottomLine.backgroundColor = UIColor.black.cgColor
        textField.borderStyle = UITextField.BorderStyle.none
        textField.layer.addSublayer(bottomLine)
        
        /*
            textField.delegate = self
            textField.font = NAVIGATION_TITLE_FONT_14
            textField.attributedPlaceholder = NSAttributedString(string: strPlaceholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            let indentView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
            textField.leftView = indentView
            textField.leftViewMode = .always
            textField.keyboardAppearance = .dark
         */
    }
    //MARK:- BUTTON UI
    func setButtonUI(btnUiDesign:UIButton,strText:String){
        btnUiDesign.setTitle(strText, for: .normal)
        btnUiDesign.layer.cornerRadius = 4
        btnUiDesign.clipsToBounds = true
        btnUiDesign.setTitleColor(.white, for: .normal)
        btnUiDesign.backgroundColor = BUTTON_BACKGROUND_COLOR_BLUE
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        previousTextFieldContent = textField.text;
        previousSelection = textField.selectedTextRange;
        //print(txtCardNumber.text as Any)
        
        
        return true
    }
    
    // MARK:- PROCESSING CHARGE WEBSERIVE HITS HERE
    @objc func processingChargeWB() {
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
           
                   parameters = [
                       "action"        : "processingcharge"
                   ]
              
                
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
                                var strPercentage : String!
                                strPercentage = JSON["percentage"]as Any as? String
                                // print(strPercentage as Any)
                                self.strSavePercentage = strPercentage
                                
                                let indexPath = IndexPath(row: 0, section: 0)
                                let cell = self.tbleView.cellForRow(at: indexPath) as! AddProcessCardTableCell
                                
                                cell.lblInvoiceAmount.text = "INVOICE AMOUNT : $0"
                                cell.lblProcessingFee.text = "PROCESSING FEE( 0% ): $0"
                                cell.lblTotalAmount.text = "TOTAL AMOUNT : $0"
                                
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
    
    //MARK:- PROCESSING CARD
    @objc func addCardProcessingWB() {
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
         /*
         action:addcardprocessing
         vendorId:4
         TransactionID:735451245
         Phone:121212121121
         email:avcca@gmail.com
         cardNo:xxxxxxxxxxxxxxx1452
         nameOnCard:121
         percentage:1.5
         processingCharge:1.5
         Amount:10
         Total:11.5
         */
         */
        
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! AddProcessCardTableCell
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
                   parameters = [
                       "action"        : "addcardprocessing",
                       "vendorId"        : String(myString),
                       "TransactionID"    : "735451245",
                       "Phone"        : String(cell.txtPhoneNumber.text!),
                       "email"        : String(cell.txtEmail.text!),
                       "cardNo"        : String(cell.txtCardNumber.text!),
                       "nameOnCard"        : String(cell.txtCustomerName.text!),
                       "percentage"        : String(strSavePercentage),
                       "processingCharge"   : String(cell.txtPhoneNumber.text!),
                       "Amount"        : String(cell.txtInvoiceAmount.text!),
                       "Total"        : String(strFinalResultPercentage),
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
                                var strPercentage : String!
                                strPercentage = JSON["percentage"]as Any as? String
                                // print(strPercentage as Any)
                                self.strSavePercentage = strPercentage
                                
                                let indexPath = IndexPath(row: 0, section: 0)
                                let cell = self.tbleView.cellForRow(at: indexPath) as! AddProcessCardTableCell
                                
                                cell.lblInvoiceAmount.text = "INVOICE AMOUNT : $0"
                                cell.lblProcessingFee.text = "PROCESSING FEE( 0% ): $0"
                                cell.lblTotalAmount.text = "TOTAL AMOUNT : $0"
                                
                                self.navigationController?.popViewController(animated: true)
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
        
        //MARK:- PROCESSING CARD

        /*
         action:addcardprocessing
         vendorId:4
         TransactionID:735451245
         Phone:121212121121
         email:avcca@gmail.com
         cardNo:xxxxxxxxxxxxxxx1452
         nameOnCard:121
         percentage:1.5
         processingCharge:1.5
         Amount:10
         Total:11.5
         */
    
       }
     
@objc func reformatAsCardNumber(textField: UITextField) {
        var targetCursorPosition = 0
        if let startPosition = textField.selectedTextRange?.start {
            targetCursorPosition = textField.offset(from: textField.beginningOfDocument, to: startPosition)
        }

        var cardNumberWithoutSpaces = ""
        if let text = textField.text {
            cardNumberWithoutSpaces = self.removeNonDigits(string: text, andPreserveCursorPosition: &targetCursorPosition)
        }

        if cardNumberWithoutSpaces.count > 19 {
            textField.text = previousTextFieldContent
            textField.selectedTextRange = previousSelection
            return
        }

        let cardNumberWithSpaces = self.insertCreditCardSpaces(cardNumberWithoutSpaces, preserveCursorPosition: &targetCursorPosition)
        textField.text = cardNumberWithSpaces

        if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition) {
            textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
        }
    }

    func removeNonDigits(string: String, andPreserveCursorPosition cursorPosition: inout Int) -> String {
        var digitsOnlyString = ""
        let originalCursorPosition = cursorPosition

        for i in Swift.stride(from: 0, to: string.count, by: 1) {
            let characterToAdd = string[string.index(string.startIndex, offsetBy: i)]
            if characterToAdd >= "0" && characterToAdd <= "9" {
                digitsOnlyString.append(characterToAdd)
            }
            else if i < originalCursorPosition {
                cursorPosition -= 1
            }
        }

        return digitsOnlyString
    }

    func insertCreditCardSpaces(_ string: String, preserveCursorPosition cursorPosition: inout Int) -> String {
        // Mapping of card prefix to pattern is taken from
        // https://baymard.com/checkout-usability/credit-card-patterns

        // UATP cards have 4-5-6 (XXXX-XXXXX-XXXXXX) format
        let is456 = string.hasPrefix("1")

        // These prefixes reliably indicate either a 4-6-5 or 4-6-4 card. We treat all these
        // as 4-6-5-4 to err on the side of always letting the user type more digits.
        let is465 = [
            // Amex
            "34", "37",

            // Diners Club
            "300", "301", "302", "303", "304", "305", "309", "36", "38", "39"
        ].contains { string.hasPrefix($0) }

        // In all other cases, assume 4-4-4-4-3.
        // This won't always be correct; for instance, Maestro has 4-4-5 cards according
        // to https://baymard.com/checkout-usability/credit-card-patterns, but I don't
        // know what prefixes identify particular formats.
        let is4444 = !(is456 || is465)

        var stringWithAddedSpaces = ""
        let cursorPositionInSpacelessString = cursorPosition

        for i in 0..<string.count {
            let needs465Spacing = (is465 && (i == 4 || i == 10 || i == 15))
            let needs456Spacing = (is456 && (i == 4 || i == 9 || i == 15))
            let needs4444Spacing = (is4444 && i > 0 && (i % 4) == 0)

            if needs465Spacing || needs456Spacing || needs4444Spacing {
                stringWithAddedSpaces.append(" ")

                if i < cursorPositionInSpacelessString {
                    cursorPosition += 1
                }
            }

            let characterToAdd = string[string.index(string.startIndex, offsetBy:i)]
            stringWithAddedSpaces.append(characterToAdd)
        }

        return stringWithAddedSpaces
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    enum CardType: String {
        case Unknown, Amex, Visa, MasterCard, Diners, Discover, JCB, Elo, Hipercard, UnionPay

        static let allCards = [Amex, Visa, MasterCard, Diners, Discover, JCB, Elo, Hipercard, UnionPay]

        var regex : String {
            switch self {
            case .Amex:
               return "^3[47][0-9]{5,}$"
            case .Visa:
               return "^4[0-9]{6,}([0-9]{3})?$"
            case .MasterCard:
               return "^(5[1-5][0-9]{4}|677189)[0-9]{5,}$"
            case .Diners:
               return "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
            case .Discover:
               return "^6(?:011|5[0-9]{2})[0-9]{3,}$"
            case .JCB:
               return "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"
            case .UnionPay:
               return "^(62|88)[0-9]{5,}$"
            case .Hipercard:
               return "^(606282|3841)[0-9]{5,}$"
            case .Elo:
               return "^((((636368)|(438935)|(504175)|(451416)|(636297))[0-9]{0,10})|((5067)|(4576)|(4011))[0-9]{0,12})$"
            default:
               return ""
            }
        }
    }
}


extension ProcessCard: UITableViewDataSource
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
    let cell:AddProcessCardTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! AddProcessCardTableCell
                
    cell.backgroundColor = .white
    
    cell.txtInvoiceAmount.delegate = self
    
    setPaddingWithImage(textField: cell.txtCustomerName, strPlaceholder: "Customer Name")
    setPaddingWithImage(textField: cell.txtEmail, strPlaceholder: "Email Address")
    setPaddingWithImage(textField: cell.txtCardNumber, strPlaceholder: "Card Number")
    setPaddingWithImage(textField: cell.txtCardExpDate, strPlaceholder: "Card Expiry Date");
    setPaddingWithImage(textField: cell.txtTotalPayableAmount, strPlaceholder: "Payable Amount")
    setPaddingWithImage(textField: cell.txtFeeOnOff, strPlaceholder: "On/Off")
    setPaddingWithImage(textField: cell.txtInvoiceAmount, strPlaceholder: "Invoice Amount")
    setPaddingWithImage(textField: cell.txtPhoneNumber, strPlaceholder: "Phone Number")
    setPaddingWithImage(textField: cell.txtCVV, strPlaceholder: "CVV")
    
    cell.btnSubmit.addTarget(self, action: #selector(addCardProcessingWB), for: .touchUpInside)
    
    return cell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
    }
            
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 800
    }
            
}


extension ProcessCard: UITableViewDelegate
{
            
}
