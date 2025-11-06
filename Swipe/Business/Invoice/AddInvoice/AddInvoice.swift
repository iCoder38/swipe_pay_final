//
//  AddInvoice.swift
//  Swipe
//
//  Created by evs_SSD on 2/20/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CRNotifications

class AddInvoice: UIViewController, UITextFieldDelegate {

    let cellReuseIdentifier = "addInvoiceTableCell"
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
              }
          }
          
      @IBOutlet weak var lblNavigationTitle:UILabel! {
          didSet {
              lblNavigationTitle.text = "ADD INVOICES"
              lblNavigationTitle.textColor = .white
          }
      }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        }
    }
    
    var addInitialMutable:NSMutableArray = []
    
    
    @IBOutlet weak var txtUsernameOrEmail:UITextField!
    
    @IBOutlet weak var btnAddMore:UIButton! {
        didSet {
            btnAddMore.setTitleColor(.white, for: .normal)
        }
    }
    @IBOutlet weak var btnRemove:UIButton! {
        didSet {
            btnRemove.setTitleColor(.white, for: .normal)
        }
    }
    @IBOutlet weak var btnSendToServer:UIButton! {
        didSet {
            btnSendToServer.layer.cornerRadius = 4
            btnSendToServer.clipsToBounds = true
            btnSendToServer.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
            btnSendToServer.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBOutlet weak var tbleView: UITableView! {
            didSet {
                // tbleView.delegate = self
                // tbleView.dataSource = self
                self.tbleView.backgroundColor = .white
                self.tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))

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


override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        btnAddMore.addTarget(self, action: #selector(popUp), for: .touchUpInside)
        btnRemove.addTarget(self, action: #selector(removeFromTableViewClickMethod), for: .touchUpInside)
        btnSendToServer.addTarget(self, action: #selector(addInvoiceWB), for: .touchUpInside)
    txtUsernameOrEmail.delegate = self
        popUp()
    }
    
    @objc func popUp() {
        let alertController = UIAlertController(title: "Add Invoice", message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "enter item name"
            textField.keyboardType = .default
            // textField.delegate = self
        }
        let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            let secondTextField = alertController.textFields![1] as UITextField
            
            let myDictionary: [String:String] = [
                "itemName":firstTextField.text!,
                "price":secondTextField.text!
            ]
            
            var res = [[String: String]]()
            res.append(myDictionary)
            
            self.addInitialMutable.addObjects(from: res)
            // print(self.addInitialMutable as Any)
            
            
            
            self.tbleView.delegate = self
            self.tbleView.dataSource = self
            self.tbleView .reloadData()
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "enter price"
            textField.keyboardType = .decimalPad
            textField.delegate = self
        }

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtUsernameOrEmail {
            
        }
        else {
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
        return true
    }
    
    @objc func removeFromTableViewClickMethod() {
        self.addInitialMutable .removeLastObject()
        self.tbleView .reloadData()
    }
    
    @objc func addInvoiceWB() {
        
        if txtUsernameOrEmail.text == "" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Username /Email field should not be empty", dismissDelay: 1.5, completion:{})
        }
        else
        {
            let urlString = BASE_URL_SWIIPE
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            
        var parameters:Dictionary<AnyHashable, Any>!
        
         if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
         {
            let x : Int = (person["userId"] as! Int)
             let myString = String(x)
        
        
        
        let paramsArray = self.addInitialMutable
        let paramsJSON = JSON(paramsArray)
        let paramsString = paramsJSON.rawString(String.Encoding.utf8, options: JSONSerialization.WritingOptions.prettyPrinted)!
        // print(paramsString as Any)
        
                   parameters = [
                       "action"        : "addmultiinvoice",
                       "userId"        : String(myString),
                       "sendTo"        : String(txtUsernameOrEmail.text!),
                       "invoiceList"    : paramsString
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
                                /*
                                 data =     {
                                     
                                 };
                                 msg = "Data save successfully.";
                                 status = success;
                                 */
                                   
                                  // 151504716
                                  CRNotifications.showNotification(type: CRNotifications.success, title: "Message!", message:strSuccessAlert, dismissDelay: 1.5, completion:{})
                                
                                    // self.loginWBClickMethod()
                                
                                self.view.endEditing(true)
                                
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
        }
       }//
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}


extension AddInvoice: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addInitialMutable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:AddInvoiceTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! AddInvoiceTableCell
        
        let item = addInitialMutable[indexPath.row] as? [String:Any]
        // print(item as Any)
        
        cell.lblName.text = (item!["itemName"] as! String)
        cell.lbPrice.text = (item!["price"] as! String)
        
        cell.backgroundColor = .white
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
    }
    
    
    
}

extension AddInvoice: UITableViewDelegate {
    
}
