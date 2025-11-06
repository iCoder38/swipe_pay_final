//
//  MenuControllerVC.swift
//  SidebarMenu
//
//  Created by Apple  on 16/10/19.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit
import Alamofire

class MenuControllerVC: UIViewController {

    let cellReuseIdentifier = "menuControllerVCTableCell"
    
    var bgImage: UIImageView?
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            let defaults = UserDefaults.standard
            let userName = defaults.string(forKey: "KeyLoginPersonal")
            if userName == "loginViaPersonal" {
                navigationBar.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
            }
            else {
                navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
            }
            
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "NAVIGATION"
            lblNavigationTitle.textColor = .white
        }
    }
    
    var arrMenuItemList = ["Dashhboard", // done
                           "Edit Profile", // done
                           "Manage Cards", // done
                           "Send Money",
                           "Request Money",
                           "Order New Card", // forgot to take backup from PC
                           "Ordered Card",
                           "Processing Card",
                           "All Transaction",
                           "Add Money",
                           "Cashout",
                           "Cashout Transaction",
                           "Invoice",
                           "Help",
                           "Change Password",
                           "Logout"]
    
    
    var arrMenuItemListPersonal = ["Dashhboard", // done
                                    "Edit Profile", // done
                                    "Manage Cards", // done
                                    "Send Money",
                                    "Order New Card", // forgot to take backup from PC
                                    "Ordered Card",
                                    "Gift Cards",
                                    "All Transaction",
                                    // "Add Money",
                                    "Cashout",
                                    "Cashout Transaction",
                                     "Request Money",
                                    "Help",
                                    "Change Password",
                                    "Logout"]
    
    
    var arrImageMenuItemListPersonal = ["home", // done
                                        "edit", // done
                                        "manage_cards", // done
                                        "send_money",
                                        "card", // forgot to take backup from PC
                                        "password",
                                        "giftP", // gift
                                        "invoice",
                                        // "home",
                                        "cashout",
                                        "cashoutTransactionB",
                                         "receiveWhite",
                                        "help",
                                        "password",
                                        "logout"]
    
    var arrImageMenuItemList = ["home", // done
                                "edit", // done
                                "manage_cards", // done
                                "send_money",
                                "receiveWhite",
                                "card", // forgot to take backup from PC
                                "password",
                                "processingCardB",
                                "cashoutTransactionB",
                                "addMoneyB",
                                "cashoutB",
                                "cashoutTransactionB",
                                "invoice",
                                "help",
                                "password",
                                "logout"]
    
    @IBOutlet var menuButton:UIButton!
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            tbleView.delegate = self
            tbleView.dataSource = self
            tbleView.tableFooterView = UIView.init()
            tbleView.backgroundColor = .clear
            tbleView.separatorInset = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50)
            tbleView.separatorColor = .white
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = UserDefaults.standard
        let userName = defaults.string(forKey: "KeyLoginPersonal")
        if userName == "loginViaPersonal" {
            self.view.backgroundColor = DASHBOARD_BACKGROUND_COLOR
        }
        else {
            self.view.backgroundColor = BUTTON_BACKGROUND_COLOR_BLUE
        }
        
        sideBarMenuClick()
           
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    @objc func sideBarMenuClick() {
        if revealViewController() != nil {
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
          }
    }
}

extension MenuControllerVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let defaults = UserDefaults.standard
        let userName = defaults.string(forKey: "KeyLoginPersonal")
        if userName == "loginViaPersonal" {
            return arrMenuItemListPersonal.count
        }
        else
        {
            return arrMenuItemList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MenuControllerVCTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MenuControllerVCTableCell
        
        cell.backgroundColor = .white
        
        let defaults = UserDefaults.standard
        let userName = defaults.string(forKey: "KeyLoginPersonal")
        if userName == "loginViaPersonal" {
            cell.backgroundColor = DASHBOARD_BACKGROUND_COLOR
            
            cell.lblName.text = arrMenuItemListPersonal[indexPath.row]
            cell.imgProfile.image = UIImage(named:arrImageMenuItemListPersonal[indexPath.row])
        }
        else {
            cell.backgroundColor = BUTTON_BACKGROUND_COLOR_BLUE
            
            cell.lblName.text = arrMenuItemList[indexPath.row]
            cell.imgProfile.image = UIImage(named:arrImageMenuItemList[indexPath.row])
        }
                
        
        
        cell.lblName.textColor = .white
        cell.imgProfile.backgroundColor = .clear
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let defaults = UserDefaults.standard
        defaults.set("dSideBar", forKey: "keySideBarMenu")
        
        let userName = defaults.string(forKey: "KeyLoginPersonal")
        if userName == "loginViaPersonal" {
            
            // personal user
        
            if indexPath.row == 0 { // dashboard
                
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                       self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "PersonalDashbaordId")
            let navigationController = UINavigationController(rootViewController: destinationController!)
                       sw.setFront(navigationController, animated: true)
            }
            
            if indexPath.row == 1 { // edit
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                           self.view.window?.rootViewController = sw
                let destinationController = self.storyboard?.instantiateViewController(withIdentifier: strEditId)
                let navigationController = UINavigationController(rootViewController: destinationController!)
                           sw.setFront(navigationController, animated: true)
            }
            if indexPath.row == 2 { // manage cards
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                           self.view.window?.rootViewController = sw
                let destinationController = self.storyboard?.instantiateViewController(withIdentifier: strManageCardsId)
                let navigationController = UINavigationController(rootViewController: destinationController!)
                           sw.setFront(navigationController, animated: true)
            }
            //
            if indexPath.row == 3 { // send money
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                           self.view.window?.rootViewController = sw
                let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "SendMoneyId")
                let navigationController = UINavigationController(rootViewController: destinationController!)
                           sw.setFront(navigationController, animated: true)
            }
            if indexPath.row == 4 { // order new card
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                           self.view.window?.rootViewController = sw
                let destinationController = self.storyboard?.instantiateViewController(withIdentifier: strOrderNewCardId)
                let navigationController = UINavigationController(rootViewController: destinationController!)
                           sw.setFront(navigationController, animated: true)
            }
            if indexPath.row == 5 { // ordered card list
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                           self.view.window?.rootViewController = sw
                let destinationController = self.storyboard?.instantiateViewController(withIdentifier: strOrderedCardList)
                let navigationController = UINavigationController(rootViewController: destinationController!)
                           sw.setFront(navigationController, animated: true)
            }
            
            // 6 gift
            if indexPath.row == 6 {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                           self.view.window?.rootViewController = sw
                let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "GiftCardsId")
                let navigationController = UINavigationController(rootViewController: destinationController!)
                           sw.setFront(navigationController, animated: true)
            }
            if indexPath.row == 7 {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                           self.view.window?.rootViewController = sw
                let destinationController = self.storyboard?.instantiateViewController(withIdentifier: strAllTransactionId)
                let navigationController = UINavigationController(rootViewController: destinationController!)
                           sw.setFront(navigationController, animated: true)
            }
        if indexPath.row == 8 { // cashout
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                       self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: strCashoutId)
            let navigationController = UINavigationController(rootViewController: destinationController!)
                       sw.setFront(navigationController, animated: true)
        }
        if indexPath.row == 9 { // cashout transactions
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                       self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: strCashoutTransaction)
            let navigationController = UINavigationController(rootViewController: destinationController!)
                       sw.setFront(navigationController, animated: true)
        }
            if indexPath.row == 10 { // cashout transactions
                /*
                 let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SendMoneyPersonalId") as? SendMoneyPersonal
                 settingsVCId!.removePlusFromNavigation = "1"
                 self.navigationController?.pushViewController(settingsVCId!, animated: true)
                 */
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                self.view.window?.rootViewController = sw
                
                let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "SendMoneyPersonalId")
                
                let myString = "hidePlus"
                UserDefaults.standard.set(myString, forKey: "noPlus")
                
                // destinationController.removePlusFromNavigation = "1"
                
                let navigationController = UINavigationController(rootViewController: destinationController!)
                sw.setFront(navigationController, animated: true)
                
                /*
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                           self.view.window?.rootViewController = sw
                let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "ReceiveListId")
                let navigationController = UINavigationController(rootViewController: destinationController!)
                           sw.setFront(navigationController, animated: true)
                 */
                
            }
        if indexPath.row == 11 { // help
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                       self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: strHelpId)
            let navigationController = UINavigationController(rootViewController: destinationController!)
                       sw.setFront(navigationController, animated: true)
        }
        if indexPath.row == 12 { // change password
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                       self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: strChangePassword)
            let navigationController = UINavigationController(rootViewController: destinationController!)
                       sw.setFront(navigationController, animated: true)
        }
        if indexPath.row == 13 { // logout
            let alertController = UIAlertController(title: "Logout", message: "Are you sure you want to logout ?", preferredStyle: .actionSheet)
            
            let logoutAction = UIAlertAction(title: "Logout", style: UIAlertAction.Style.destructive) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                
                let defaults = UserDefaults.standard
                defaults.setValue("", forKey: "keyLoginFullData")
                defaults.setValue(nil, forKey: "keyLoginFullData")
                
                defaults.setValue("", forKey: "KeyLoginPersonal")
                defaults.setValue(nil, forKey: "KeyLoginPersonal")
                
                // let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "StartId") as? Start
                // self.navigationController?.pushViewController(settingsVCId!, animated: true)
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                           self.view.window?.rootViewController = sw
                let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "StartNewId")
                let navigationController = UINavigationController(rootViewController: destinationController!)
                           sw.setFront(navigationController, animated: true)
                
                }
            
            let okAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("OK Pressed")
            }
            
            alertController.addAction(logoutAction)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
            /*
             
             */
        else {
        if indexPath.row == 0 { // dashboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                       self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: strBusinessDashbaordId)
            let navigationController = UINavigationController(rootViewController: destinationController!)
                       sw.setFront(navigationController, animated: true)
        }
        
        if indexPath.row == 1 { // edit
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                       self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: strEditId)
            let navigationController = UINavigationController(rootViewController: destinationController!)
                       sw.setFront(navigationController, animated: true)
        }
        
        if indexPath.row == 2 { // manage cards
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                       self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: strManageCardsId)
            let navigationController = UINavigationController(rootViewController: destinationController!)
                       sw.setFront(navigationController, animated: true)
        }
        if indexPath.row == 3 { // send money
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                       self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: strSendMoney)
            let navigationController = UINavigationController(rootViewController: destinationController!)
                       sw.setFront(navigationController, animated: true)
        }
            if indexPath.row == 4 { // request user
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                           self.view.window?.rootViewController = sw
                let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "RequestMoneyUserId")
                let navigationController = UINavigationController(rootViewController: destinationController!)
                           sw.setFront(navigationController, animated: true)
            }
        if indexPath.row == 4+1 { // order new card
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                       self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: strOrderNewCardId)
            let navigationController = UINavigationController(rootViewController: destinationController!)
                       sw.setFront(navigationController, animated: true)
        }
        if indexPath.row == 5+1 { // ordered card list
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                       self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: strOrderedCardList)
            let navigationController = UINavigationController(rootViewController: destinationController!)
                       sw.setFront(navigationController, animated: true)
        }
        
        if indexPath.row == 6+1 { // business process card
            /*
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                       self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "AddProcessCardTwoId")
            let navigationController = UINavigationController(rootViewController: destinationController!)
                       sw.setFront(navigationController, animated: true)
            */
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                       self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: strBusinessProcessingCardId)
            let navigationController = UINavigationController(rootViewController: destinationController!)
                       sw.setFront(navigationController, animated: true)
             
        }
        
        if indexPath.row == 7+1 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                       self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: strAllTransactionId)
            let navigationController = UINavigationController(rootViewController: destinationController!)
                       sw.setFront(navigationController, animated: true)
        }
        if indexPath.row == 8+1 { // add money
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                       self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: strAddMoneyId)
            let navigationController = UINavigationController(rootViewController: destinationController!)
                       sw.setFront(navigationController, animated: true)
        }
        if indexPath.row == 9+1 { // cashout
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                       self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: strCashoutId)
            let navigationController = UINavigationController(rootViewController: destinationController!)
                       sw.setFront(navigationController, animated: true)
        }
        if indexPath.row == 10+1 { // cashout transactions
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                       self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: strCashoutTransaction)
            let navigationController = UINavigationController(rootViewController: destinationController!)
                       sw.setFront(navigationController, animated: true)
        }
        if indexPath.row == 11+1 { // invoice
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                       self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "InvoiceId")
            let navigationController = UINavigationController(rootViewController: destinationController!)
                       sw.setFront(navigationController, animated: true)
        }
        if indexPath.row == 12+1 { // help
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                       self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: strHelpId)
            let navigationController = UINavigationController(rootViewController: destinationController!)
                       sw.setFront(navigationController, animated: true)
        }
        if indexPath.row == 13+1 { // change password
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                       self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: strChangePassword)
            let navigationController = UINavigationController(rootViewController: destinationController!)
                       sw.setFront(navigationController, animated: true)
        }
        if indexPath.row == 14+1 { // logout
            let alertController = UIAlertController(title: "Logout", message: "Are you sure you want to logout ?", preferredStyle: .actionSheet)
            
            let logoutAction = UIAlertAction(title: "Logout", style: UIAlertAction.Style.destructive) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                
                self.logoutAndNilDeviceToken()
                
                }
            
            let okAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("OK Pressed")
            }
            
            alertController.addAction(logoutAction)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        }
        
        
        
        
        
    }
    
    @objc func logoutAndNilDeviceToken() {
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
         [action] => deletcard
         [userId] => 74
         [cardId] => 77
         */
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
                   parameters = [
                       "action"     : "logout",
                        "userId"    : String(myString),
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
                               
                                if strSuccess == "success" {//true {
                                ERProgressHud.sharedInstance.hide()
                                    self.pushAndNilAfterLogout()
                               }
                               else {
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
    @objc func pushAndNilAfterLogout() {
        let defaults = UserDefaults.standard
        defaults.setValue("", forKey: "keyLoginFullData")
        defaults.setValue(nil, forKey: "keyLoginFullData")
        
        defaults.setValue("", forKey: "KeyLoginPersonal")
        defaults.setValue(nil, forKey: "KeyLoginPersonal")
        
        // let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "StartId") as? Start
        // self.navigationController?.pushViewController(settingsVCId!, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                   self.view.window?.rootViewController = sw
        let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "StartNewId")
        let navigationController = UINavigationController(rootViewController: destinationController!)
                   sw.setFront(navigationController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
    
}

extension MenuControllerVC: UITableViewDelegate
{
    
}
