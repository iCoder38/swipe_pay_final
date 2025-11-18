//
//  Invoice.swift
//  Swipe
//
//  Created by Apple on 04/11/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CRNotifications

class Invoice: UIViewController {

    let cellReuseIdentifier = "invoicesTableCell"
    
    // array list
    // var arrListOfAllTransaction:Array<Any>!
    
    var arr_list_of_all_invoices:NSMutableArray! = []
    
    var page : Int! = 1
    var loadMore : Int! = 1;
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
              }
          }
          
      @IBOutlet weak var lblNavigationTitle:UILabel! {
          didSet {
              lblNavigationTitle.text = "INVOICES"
              lblNavigationTitle.textColor = .white
          }
      }
    
    @IBOutlet weak var addInvoice:UIButton!
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.addTarget(self, action: #selector(backClick), for: .touchUpInside)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = UserDefaults.standard
        if let name = defaults.string(forKey: "keySideBarMenu") {
            // print(name)
            if name == "dSideBar" {
                btnBack.setImage(UIImage(named: "menuWhite"), for: .normal)
                sidebarMenuClick()
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
        
        addInvoice.addTarget(self, action: #selector(addInvoiceClickMethod), for: .touchUpInside)
    }
    
    @objc func sidebarMenuClick() {
        if revealViewController() != nil {
        btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
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
        
        self.page = 1
        self.arr_list_of_all_invoices.removeAllObjects()
        self.allTransactionWB(pageNumber: 1)
    }

    @objc func addInvoiceClickMethod() {
         let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddInvoiceId") as? AddInvoice
         self.navigationController?.pushViewController(settingsVCId!, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
                
        if scrollView == self.tbleView {
            let isReachingEnd = scrollView.contentOffset.y >= 0
                && scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)
            if(isReachingEnd) {
                if(loadMore == 1) {
                    loadMore = 0
                    page += 1
                    print(page as Any)
                    
                    
                        self.allTransactionWB(pageNumber: page)
                    
                    
                }
            }
        }
    }
    
    //MARK:- ALL TRANSACTION
    @objc func allTransactionWB(pageNumber:Int) {
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
                       "action"        : "invoicelist",
                       "userId"        : String(myString),
                       "type"        : "Vendor",
                       "pageNo"        : pageNumber
                       
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
//                                 print(JSON)
                               
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
                                
                                var ar : NSArray!
                                ar = (JSON["data"] as! Array<Any>) as NSArray
                                // self.arrListOfAllTransaction = (ar as! Array<Any>)
                                   self.arr_list_of_all_invoices.addObjects(from: ar as! [Any])
                                   
                                self.tbleView.delegate = self
                                self.tbleView.dataSource = self
                                self.tbleView.reloadData()
                                   self.loadMore = 1
                                   
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

extension Invoice: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arr_list_of_all_invoices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:InvoicesTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! InvoicesTableCell
        
        cell.backgroundColor = .white
        
        let item = self.arr_list_of_all_invoices[indexPath.row] as? [String:Any]
        // print(item as Any)
        /*
         TotalAmount = "2.86";
         created = "Feb 17th, 2020, 1:03 pm";
         invoiceId = 65;
         invoiceNo = 38;
         iteamName = test;
         price = "2.86";
         sentToImage = "";
         sentToName = "test1@gmail.com";
         userImage = "http://demo2.evirtualservices.com/swiipe/site/img/uploads/users/15821979602.png";
         userName = purnima;
         */
        
        cell.lblDate.textColor = .black
        cell.lblPrice.textColor = .black
        cell.lblUserName.textColor = .black
        
        cell.lblDate.text = (item!["created"] as! String)
        
        if (item!["price"] as! String) == "" {
            cell.lblPrice.text = "$ "+"0"
        }
        else {
            cell.lblPrice.text = "$ "+(item!["price"] as! String)
        }
        cell.lblUserName.text = (item!["sentToName"] as! String)
        
        // image
        cell.imgProfilePicture.sd_setImage(with: URL(string: (item!["userImage"] as! String)), placeholderImage: UIImage(named: "avatar"))
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        let item = self.arr_list_of_all_invoices[indexPath.row] as? [String:Any]
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "InvoiceDetailsId") as? InvoiceDetails
        settingsVCId!.getDictInvoice = (item! as NSDictionary)
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
        
    }
}

extension Invoice: UITableViewDelegate
{
    
}
