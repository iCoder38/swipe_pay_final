//
//  InvoiceDetails.swift
//  Swipe
//
//  Created by Apple on 04/11/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CRNotifications
import SDWebImage

class InvoiceDetails: UIViewController {

    var getDictInvoice:NSDictionary!

    let cellReuseIdentifier = "invoiceDetailsTableCell"
    
    // array list
    var arrListOfAllTransaction:Array<Any>!
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
              }
          }
          
      @IBOutlet weak var lblNavigationTitle:UILabel! {
          didSet {
              lblNavigationTitle.text = "INVOICES DETAILS"
              lblNavigationTitle.textColor = .white
          }
      }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var lblUserName:UILabel! {
        didSet {
            lblUserName.text = "Bob Marley"
            lblUserName.textColor = .white
        }
    }
    
    @IBOutlet weak var lblUserPhoneNumber:UILabel! {
        didSet {
            lblUserPhoneNumber.text = "1800 - 1234 - 5678"
            lblUserPhoneNumber.textColor = .white
        }
    }
    
    @IBOutlet weak var lblEmailAddress:UILabel! {
        didSet {
            lblEmailAddress.text = "xyz@gmail.com"
            lblEmailAddress.textColor = .white
        }
    }
    
    @IBOutlet weak var lblDateAndTime:UILabel! {
        didSet {
            lblDateAndTime.text = "Tue, 18 - Sept 2019, 10:00 a.m - 1:00 p.m"
            lblDateAndTime.textColor = .black
        }
    }
    
    @IBOutlet weak var lblInvoiceTitleOne:UILabel! {
        didSet {
            lblInvoiceTitleOne.text = "Invoice Title goes Here"
            lblInvoiceTitleOne.textColor = .black
        }
    }
    
    // @IBOutlet weak var lblTotalPrice:UILabel!
    
    @IBOutlet weak var lblInvoiceTitleTwo:UILabel! {
        didSet {
            lblInvoiceTitleTwo.text = "Invoice Title goes Here"
            lblInvoiceTitleTwo.textColor = .black
        }
    }
    
    @IBOutlet weak var lblInvoiceTitleThree:UILabel! {
        didSet {
            lblInvoiceTitleThree.text = "Invoice Title goes Here"
            lblInvoiceTitleThree.textColor = .black
        }
    }
    
    @IBOutlet weak var lblTotalPrice:UILabel! {
        didSet {
            lblTotalPrice.text = ""
            lblTotalPrice.textColor = .black
        }
    }
    
    @IBOutlet weak var btnSendInvoice:UIButton! {
        didSet {
            setButtonUI(btnUiDesign: btnSendInvoice, strText: "Send Invoice")
        }
    }
    
    @IBOutlet weak var imgDisplayPic:UIImageView! {
        didSet {
            imgDisplayPic.layer.cornerRadius = 30
            imgDisplayPic.clipsToBounds = true
        }
    }
    @IBOutlet weak var tbleView: UITableView! {
                didSet
                {
    //                tbleView.delegate = self
    //                tbleView.dataSource = self
                    self.tbleView.backgroundColor = .white
                    self.tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))

                }
        }
    @IBOutlet weak var btnProceedCustomerCard:UIButton! {
        didSet {
            setButtonUI(btnUiDesign: btnProceedCustomerCard, strText: "Proceed Customer Card")
        }
    }
    
    @IBOutlet weak var viewTopView:UIView! {
        didSet {
            viewTopView.backgroundColor = UIColor.init(red: 107.0/255.0, green: 221.0/255.0, blue: 251.0/255.0, alpha: 1)
        }
    }
    
    @IBOutlet weak var viewDateAndTimeView:UIView! {
        didSet {
            viewDateAndTimeView.backgroundColor = UIColor.init(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1)
        }
    }
    
    @IBOutlet weak var viewTotalPriceView:UIView! {
        didSet {
            viewTotalPriceView.backgroundColor = UIColor.init(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1)
        }
    }
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        invoiceDetailsGetWB()
//         print(getDictInvoice as Any)
        /*
         TotalAmount = "456398.22";
         created = "Feb 20th, 2020, 6:04 pm";
         invoiceId = 75;
         invoiceNo = 45;
         iteamName = hdhdh;
         price = 454548;
         sentToImage = "";
         sentToName = bshdhd;
         userImage = "http://demo2.evirtualservices.com/swiipe/site/img/uploads/users/15821979602.png";
         userName = purnima;
         */
        self.lblUserPhoneNumber.text = ""
        self.lblEmailAddress.text = ""
        self.lblUserName.text = (self.getDictInvoice["sentToName"] as! String)
        self.lblDateAndTime.text = (self.getDictInvoice["created"] as! String) // created
        
        // image
        self.imgDisplayPic.sd_setImage(with: URL(string: (self.getDictInvoice["userImage"] as! String)), placeholderImage: UIImage(named: "avatar"))
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
    
    
    
    //MARK:- BUTTON UI
    func setButtonUI(btnUiDesign:UIButton,strText:String){
        btnUiDesign.setTitle(strText, for: .normal)
        btnUiDesign.layer.cornerRadius = 4
        btnUiDesign.clipsToBounds = true
        btnUiDesign.setTitleColor(.white, for: .normal)
        if btnUiDesign.titleLabel?.text == "Send Invoice" {
            btnUiDesign.backgroundColor = BUTTON_BACKGROUND_COLOR_BLUE
        }
        else if btnUiDesign.titleLabel?.text == "Proceed Customer Card"
        {
            btnUiDesign.backgroundColor = UIColor.init(red: 107.0/255.0, green: 221.0/255.0, blue: 251.0/255.0, alpha: 1)
        }
        
    }
    
    
    
    @objc func invoiceDetailsGetWB() {
     
     
     let urlString = BASE_URL_SWIIPE
         ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
         
     var parameters:Dictionary<AnyHashable, Any>!
     
      // if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
     //  {
         // let x : Int = (person["userId"] as! Int)
          // let myString = String(x)
     
                parameters = [
                    "action"        : "invoicedetails",
                    "invoiceNo"        : (getDictInvoice["invoiceNo"] as! NSNumber)
                    // email
                    // self.addInitialMutable //String("74"),
                ]
     //  }
             
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
                             TotalAmount = "401.74";
                             created = "Feb 20th, 2020, 6:24 pm";
                             invoiceId = 79;
                             invoiceNo = 46;
                             iteamName = two;
                             price = 400;
                             sendDiveceToken = "";
                             sendEmail = "";
                             sendTo = "";
                             sendTouserImage = "";
                             sendTouserName = ahagaba;
                             sendcontactNumber = "";
                             userDiveceToken = "e4A9A9aNuUMuqyoLJo2j0p:APA91bGbsRWFkFeGU_k27WYa5v2BESWdifEoYA_QH-cl8b6wWM3xIFNSINjFv8hki3SSXuPkUVVbP84ppVA9Z1LGzNjQxbV5eywABRvF2qS1uy20TUHljuTXNJnu0mvuxD1CqD3LL7es";
                             userEmail = "purnimaevs@gmail.com";
                             userId = 74;
                             userImage = "http://demo2.evirtualservices.com/swiipe/site/img/uploads/users/15821979602.png";
                             userName = purnima;
                             usercontactNumber = 9638521230;
                             */
                            var strSuccess : String!
                            strSuccess = JSON["status"]as Any as? String
                            
                             // var strSuccessAlert : String!
                             // strSuccessAlert = JSON["msg"]as Any as? String
                            
                            if strSuccess == "success" //true
                            {
                                
                                
                                
                                var ar : NSArray!
                                ar = (JSON["data"] as! Array<Any>) as NSArray
                                self.arrListOfAllTransaction = (ar as! Array<Any>)
                                
                                let item = self.arrListOfAllTransaction[0] as? [String:Any]
                                self.lblTotalPrice.text = "Total price: $"+(item!["TotalAmount"] as! String)
                                
                                
                                
                                
                            
                                
                                
                             self.view.endEditing(true)
                             
                                self.tbleView.delegate = self
                                self.tbleView.dataSource = self
                                self.tbleView.reloadData()
                                
                             // self.navigationController?.popViewController(animated: true)
                              ERProgressHud.sharedInstance.hide()
                            }
                            else
                            {
                                // self.indicator.stopAnimating()
                                // self.enableService()
                              // CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:strSuccessAlert, dismissDelay: 1.5, completion:{})
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


extension InvoiceDetails: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrListOfAllTransaction.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:InvoiceDetailsTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! InvoiceDetailsTableCell
        
        cell.backgroundColor = .white
        
         let item = arrListOfAllTransaction[indexPath.row] as? [String:Any]
         // print(item as Any)
        // (item!["created"] as! String)
        

        
        /*
        TotalAmount = "401.74";
        created = "Feb 20th, 2020, 6:24 pm";
        invoiceId = 79;
        invoiceNo = 46;
        iteamName = two;
        price = 400;
        sendDiveceToken = "";
        sendEmail = "";
        sendTo = "";
        sendTouserImage = "";
        sendTouserName = ahagaba;
        sendcontactNumber = "";
        userDiveceToken = "e4A9A9aNuUMuqyoLJo2j0p:APA91bGbsRWFkFeGU_k27WYa5v2BESWdifEoYA_QH-cl8b6wWM3xIFNSINjFv8hki3SSXuPkUVVbP84ppVA9Z1LGzNjQxbV5eywABRvF2qS1uy20TUHljuTXNJnu0mvuxD1CqD3LL7es";
        userEmail = "purnimaevs@gmail.com";
        userId = 74;
        userImage = "http://demo2.evirtualservices.com/swiipe/site/img/uploads/users/15821979602.png";
        userName = purnima;
        usercontactNumber = 9638521230;
        */
        
        cell.lblTitle.text = (item!["iteamName"] as! String)
        cell.lblPrice.text = (item!["price"] as! String)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        // let item = arrListOfAllTransaction[indexPath.row] as? [String:Any]
        
        
    }
}

extension InvoiceDetails: UITableViewDelegate
{
    
}
