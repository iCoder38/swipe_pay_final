//
//  ProcessCardPageTwo.swift
//  Swipe
//
//  Created by evs_SSD on 1/23/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import CRNotifications



class ProcessCardPageTwo: UIViewController , UITextFieldDelegate {

    var arrProcessingFee:NSArray!
    
    var str_get_only_processing_fee:String! = "0"
    var str_get_only_total_price:String! = "0"
    var str_get_only_total_price_with_processing_fee:String! = "0"
    
    var arrListOfProcessingFee:NSMutableArray! = []
    
    // get value from previous page
    var strGetNameOnCardFromAddProcessCard:String! // name on card
    var strGetEmailFromAddProcessCard:String! // email address
    var strGetCreditCardNumberFromAddProcessCard:String! // credit card number
    var strGetExpDateFromAddProcessCard:String! // exp date
    var strGetCVVFromAddProcessCard:String! // cvv
    var strGetZipcodeFromAddProcessCard:String! // zipcode
    var strGetPhoneNumberFromAddProcessCard:String! // phone number
    // var strGetPriceFromAddProcessCard:String!
    
    var saveCardProcessingFees:String!
    
    var myfinalAmountofCardIs:String!
    
    var whatIsMyPer:String!
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
        }
    }
    
    @IBOutlet weak var lblProcessingFees:UILabel!
    @IBOutlet weak var lblDynamicPrice:UILabel!
    
    @IBOutlet weak var txtEnterAmount:UITextField!
    
    @IBOutlet weak var lblInvoiceAmount:UILabel!
    @IBOutlet weak var lblChangeProcessingFee:UILabel!
    @IBOutlet weak var lblTotalAmountUs:UILabel!
    
    
    @IBOutlet weak var lblCARDPROCESSGINFEES:UILabel!
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "PROCEED CARD"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var btnProcess:UIButton!
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var btnSubmit:UIButton! {
        didSet {
            btnSubmit.layer.cornerRadius = 4
            btnSubmit.clipsToBounds = true
            btnSubmit.backgroundColor = UIColor.init(red: 18.0/255.0, green: 198.0/255.0, blue: 250.0/255.0, alpha: 1)
            
            //
            // btnBack.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        }
    }
    
    // right bg views
    @IBOutlet weak var viewBGbig:UIView! {
        didSet {
            viewBGbig.backgroundColor = UIColor.init(red: 216.0/255.0, green: 216.0/255.0, blue: 216.0/255.0, alpha: 1)
            viewBGbig.layer.borderColor = UIColor.black.cgColor
            viewBGbig.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var viewBGCardProcessingFees:UIView! {
        didSet {
            viewBGCardProcessingFees.backgroundColor = UIColor.init(red: 216.0/255.0, green: 216.0/255.0, blue: 216.0/255.0, alpha: 1)
            viewBGCardProcessingFees.layer.borderColor = UIColor.black.cgColor
            viewBGCardProcessingFees.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var viewBGInvoiceAmount:UIView! {
        didSet {
            viewBGInvoiceAmount.backgroundColor = UIColor.init(red: 216.0/255.0, green: 216.0/255.0, blue: 216.0/255.0, alpha: 1)
            viewBGInvoiceAmount.layer.borderColor = UIColor.black.cgColor
            viewBGInvoiceAmount.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var viewBGCardProcessing:UIView! {
        didSet {
            viewBGCardProcessing.backgroundColor = UIColor.init(red: 216.0/255.0, green: 216.0/255.0, blue: 216.0/255.0, alpha: 1)
            viewBGCardProcessing.layer.borderColor = UIColor.black.cgColor
            viewBGCardProcessing.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var viewBGTotalAmount:UIView! {
        didSet {
            viewBGTotalAmount.backgroundColor = UIColor.init(red: 216.0/255.0, green: 216.0/255.0, blue: 216.0/255.0, alpha: 1)
            viewBGTotalAmount.layer.borderColor = UIColor.black.cgColor
            viewBGTotalAmount.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var segmentControls:UISegmentedControl!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // lblDynamicPrice.text = "Charge $"+strGetPriceFromAddProcessCard
        
        txtEnterAmount.placeholder = "$0"
        txtEnterAmount.delegate = self
        txtEnterAmount.keyboardType = .decimalPad
        
        segmentControls.selectedSegmentIndex = 1
        segmentControls.addTarget(self, action: #selector(segmentControlClickMethod), for: .valueChanged)
        
        // self.lblTotalAmountUs.text = "$"+strGetPriceFromAddProcessCard
        // self.lblInvoiceAmount.text = "$"+strGetPriceFromAddProcessCard
        
        // self.txtEnterAmount.text = "$"+strGetPriceFromAddProcessCard
        
        btnSubmit.addTarget(self, action: #selector(addCardProcessingWB), for: .touchUpInside)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
        
        self.btnProcess.addTarget(self, action: #selector(processClickMethod), for: .touchUpInside)
        
        self.processingChargeWB()
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view .endEditing(true)
        return true
    }
    @objc func backClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtEnterAmount {
            print("You edit myTextField")
            self.segmentControls.selectedSegmentIndex = 1
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("me click")
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        btnBack.setImage(UIImage(named: "backs"), for: .normal)
        btnBack.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        
        /*
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
        else {
            btnBack.setImage(UIImage(named: "backs"), for: .normal)
            btnBack.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        }
 */
    }
    @objc func sideBarMenuClick() {
        
        self.view.endEditing(true)
        
        if revealViewController() != nil {
        btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
          }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }

        print(textField.text as Any)
        
        let newText = oldText.replacingCharacters(in: r, with: string)
        let isNumeric = newText.isEmpty || (Double(newText) != nil)
        let numberOfDots = newText.components(separatedBy: ".").count - 1

        let numberOfDecimalDigits: Int
        if let dotIndex = newText.firstIndex(of: ".") {
            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }

        // self.lblInvoiceAmount.text = string
        
        
        
        
        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
    }
    
    @objc func segmentControlClickMethod() {
        if txtEnterAmount.text == "" {
            
        }
        else {
            if segmentControls.selectedSegmentIndex == 0 {
                
                lblChangeProcessingFee.text = saveCardProcessingFees+" %"
                
                let myString1 = saveCardProcessingFees
                let myInt1 = Int(myString1!)
                
                let myString2 = self.txtEnterAmount.text//lblInvoiceAmount.text
                let myInt2 = Int(myString2!)
                
                let result: Double = Double(myInt2!) * Double(myInt1!)/100+Double(myInt2!)
                lblTotalAmountUs.text = String(format:"$ "+"%.02f", result)
                
                myfinalAmountofCardIs = String(format:"%.02f", result)
                // print(myfinalAmountofCardIs as Any)
                
            }
            else
            if segmentControls.selectedSegmentIndex == 1 {
                // off
                lblChangeProcessingFee.text = "0"+" %"
                lblTotalAmountUs.text = "$ "+self.txtEnterAmount.text!//String(format:"$ "+"%.02f", result)
                myfinalAmountofCardIs = self.txtEnterAmount.text
                print(myfinalAmountofCardIs as Any)
            }
            
        }
        
        
        
        
        
        
        
        
        
        
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
                                  print(JSON)
                               
                               var strSuccess : String!
                               strSuccess = JSON["status"]as Any as? String
                               
                               var strSuccessAlert : String!
                               strSuccessAlert = JSON["msg"]as Any as? String
                               
                               if strSuccess == "success"  {
                                   
                                   
                                 // var strPercentage : String!
                                 // strPercentage = JSON["percentage"]as Any as? String
                                 
                                    
                                   var ar : NSArray!
                                   ar = (JSON["data"] as! Array<Any>) as NSArray
                                   // self.arrListOfProcessingFee = (ar as! NSMutableArray)
                                   // self.arrListOfProcessingFee.addObjects(from: ar as! [Any])
                                   
                                   for indexx in 0..<ar.count {
                                       
                                       let item = ar[indexx] as? [String:Any]
                                       
                                       self.arrListOfProcessingFee.add(item!["percentage"] as! String)
                                       
                                   }
                                   
                                   print(self.arrListOfProcessingFee as Any)
                                   
                                   
                                   //
                                   // self.arrProcessingFee = (JSON["data"] as! Array<Any>) as NSArray
                                   // self.arrListOfAllCards = (ar as! Array<Any>)
                                   
                                    
                                   
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                // print(strPercentage as Any)
                                // self.strSavePercentage = strPercentage
                                
                                // let indexPath = IndexPath(row: 0, section: 0)
                                // let cell = self.tbleView.cellForRow(at: indexPath) as! AddProcessCardTableCell
                                
                                // cell.lblInvoiceAmount.text = "INVOICE AMOUNT : $0"
                                // cell.lblProcessingFee.text = "PROCESSING FEE( 0% ): $0"
                                // cell.lblTotalAmount.text = "TOTAL AMOUNT : $0"
                                
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
    
    
    @objc func processClickMethod() {
        
        print(self.arrListOfProcessingFee as Any)
        
        if self.txtEnterAmount.text == "" {
            
            let alert = UIAlertController(title: "Alert", message: "Please enter amount.",preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_: UIAlertAction!) in
                                            
                                             
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {
           
            let array: [String] = self.arrListOfProcessingFee.copy() as! [String]
            
            RPicker.selectOption(title: "Processing Fee", cancelText: "Cancel", dataArray: array, selectedIndex: 0) {[] (selctedText, atIndex) in
                // TODO: Your implementation for selection
                // self!.lblProcessingFees.text = selctedText + " selcted at \(atIndex)"
                
                // processing fee
                self.str_get_only_processing_fee = selctedText
                
                // show processing fee add with %
                self.lblCARDPROCESSGINFEES.text = selctedText+" %"
                
                
                // calculate percentage
                let doubleProcessingfee = Double(selctedText)!/100
                // print(doubleProcessingfee as Any)
                
                
                // calculate percentage with total amount
                let value = calculatePercentage(value: Double(self.txtEnterAmount.text!)!,percentageVal: Double(self.str_get_only_processing_fee)!)
                // print(value)
                
                
                // set invoice amount
                self.lblInvoiceAmount.text = "$"+String(self.txtEnterAmount.text!)
                
                
                // add total amount with percentage amount
                let str_add_precentage_with_toal_amount = Double(value)+Double(self.txtEnterAmount.text!)!
                // print(str_add_precentage_with_toal_amount)
                
                
                // show total amount after add fee
                self.lblTotalAmountUs.text = "$"+String(str_add_precentage_with_toal_amount)
                
                
                // show calculated processing fee with total amount
                self.lblProcessingFees.text = "Processing Fees ("+String(doubleProcessingfee)+"%):"
                self.lblChangeProcessingFee.text = "$"+String(value)
                
                
                // total amount entered
                self.str_get_only_total_price = String(self.txtEnterAmount.text!)
                
                
                // total amount after add all values
                self.str_get_only_total_price_with_processing_fee = String(str_add_precentage_with_toal_amount)
                
            }
            
        }
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
     
        print("text field called here")
        
        // self.lblInvoiceAmount.text = textField
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        print(textField.text as Any)
        return true
    }
    
    //MARK:- PROCESSING CARD
    @objc func addCardProcessingWB() {
        if segmentControls.selectedSegmentIndex == 0 {

            if txtEnterAmount.text == "" {
                CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Please enter amount.", dismissDelay: 1.5, completion:{})
            }
            else {
                let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddProcessCardTwoId") as? AddProcessCardTwo
                settingsVCId!.amountIs = myfinalAmountofCardIs//self.txtEnterAmount.text
                settingsVCId!.percentageIs = self.saveCardProcessingFees
                self.navigationController?.pushViewController(settingsVCId!, animated: true)
            }
            
        }
        else if segmentControls.selectedSegmentIndex == 1 {
            
            if txtEnterAmount.text == "" {
                
                CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Please enter amount.", dismissDelay: 1.5, completion:{})
                
            } else {
                
                /*
                 self.str_get_only_total_price = String(self.txtEnterAmount.text!)
                 
                 
                 // total amount after add all values
                 self.str_get_only_total_price_with_processing_fee = String(str_add_precentage_with_toal_amount)
                 */
                
                let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddProcessCardTwoId") as? AddProcessCardTwo
                
                settingsVCId!.amountIs      = self.str_get_only_total_price
                settingsVCId!.percentageIs  = self.str_get_only_processing_fee
                settingsVCId!.total_price   = self.str_get_only_total_price_with_processing_fee
                
                self.navigationController?.pushViewController(settingsVCId!, animated: true)
                
            }
            
        }
        
        
        
        /*
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
        
        
        // let indexPath = IndexPath(row: 0, section: 0)
        // let cell = self.tbleView.cellForRow(at: indexPath) as! AddProcessCardTableCell
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            /*
             var strGetNameOnCardFromAddProcessCard:String! // name on card
             var strGetEmailFromAddProcessCard:String! // email address
             var strGetCreditCardNumberFromAddProcessCard:String! // credit card number
             var strGetExpDateFromAddProcessCard:String! // exp date
             var strGetCVVFromAddProcessCard:String! // cvv
             var strGetZipcodeFromAddProcessCard:String! // zipcode
             var strGetPhoneNumberFromAddProcessCard:String! // phone number
             
             var strGetPriceFromAddProcessCard:String!
             */
            
                   parameters = [
                       "action"        : "addcardprocessing",
                       "vendorId"           : String(myString),
                       "TransactionID"      : "735451245",
                       "Phone"              : String(strGetPhoneNumberFromAddProcessCard),
                       "email"              : String(strGetEmailFromAddProcessCard),
                       "cardNo"             : String(strGetCreditCardNumberFromAddProcessCard),
                       "nameOnCard"        : String(strGetNameOnCardFromAddProcessCard),
                       "percentage"        : String(saveCardProcessingFees),
                       "processingCharge"   : String(saveCardProcessingFees),
                       "Amount"             : String(strGetPriceFromAddProcessCard),
                       "Total"          : String(myfinalAmountofCardIs),
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
                                // var strPercentage : String!
                                // strPercentage = JSON["percentage"]as Any as? String
                                // print(strPercentage as Any)
                                // self.strSavePercentage = strPercentage
                                
                                // let indexPath = IndexPath(row: 0, section: 0)
                                // let cell = self.tbleView.cellForRow(at: indexPath) as! AddProcessCardTableCell
                                
                                // cell.lblInvoiceAmount.text = "INVOICE AMOUNT : $0"
                                // cell.lblProcessingFee.text = "PROCESSING FEE( 0% ): $0"
                                // cell.lblTotalAmount.text = "TOTAL AMOUNT : $0"
                                
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
        
        */
    
       }
}

public func calculatePercentage(value:Double,percentageVal:Double)->Double{
    let val = value * percentageVal
    return val / 100.0
}

