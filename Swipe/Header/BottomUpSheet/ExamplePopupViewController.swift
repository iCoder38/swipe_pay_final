//
//  ExamplePopupViewController.swift
//  BottomPopup
//
//  Created by Emre on 16.09.2018.
//  Copyright © 2018 Emre. All rights reserved.
//

import UIKit
import BottomPopup
import Alamofire
import SwiftyJSON

class ExamplePopupViewController: BottomPopupViewController {

    let cellReuseIdentifier = "exampleNewProductTableCel"
    
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
   
    var strGetDetails:String!
   
    var dynamicString:String!
    
    var arrListOfSavedCards : NSArray! // list of saved cards
    var arrListOfBanks : NSArray! // list of banks
    
    var arrTotalUser : NSArray! // list of user
    
    @IBOutlet weak var lblTitle:UILabel!
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            
            tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            tbleView.backgroundColor = .clear
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(strGetDetails as Any)
        
        //
        if strGetDetails == "savedCardsFromAddMoney" {
            lblTitle.text = "My Cards"
            tbleView.delegate = self
            tbleView.dataSource = self
            
            // print(arrListOfSavedCards as Any)
        }
        else
        if strGetDetails == "savedBankList" {
            lblTitle.text = "My Bank Accounts"
            tbleView.delegate = self
            tbleView.dataSource = self
            
            // print(arrListOfSavedCards as Any)
        }
        else
        if strGetDetails == "savedBankListOrderCard" {
            lblTitle.text = "Banks"
            tbleView.delegate = self
            tbleView.dataSource = self
            
            // print(arrListOfSavedCards as Any)
        }
         
        else
        if strGetDetails == "addNewGiftSelectUsers" {
            lblTitle.text = "All Users"
            tbleView.delegate = self
            tbleView.dataSource = self
            
            // print(arrListOfSavedCards as Any)
        }
       
    }
    
     func getPopupHeight() -> CGFloat {
        return height ?? CGFloat(300)
    }
    
     func getPopupTopCornerRadius() -> CGFloat {
        return topCornerRadius ?? CGFloat(10)
    }
    
     func getPopupPresentDuration() -> Double {
        return presentDuration ?? 1.0
    }
    
     func getPopupDismissDuration() -> Double {
        return dismissDuration ?? 1.0
    }
    
     func shouldPopupDismissInteractivelty() -> Bool {
        return shouldDismissInteractivelty ?? true
    }
    
    
}

extension ExamplePopupViewController: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if strGetDetails == "savedCardsFromAddMoney" {
            return arrListOfSavedCards.count
        }
        else
        if strGetDetails == "savedBankList" {
            return arrListOfBanks.count
        }
        else
        if strGetDetails == "savedBankListOrderCard" {
            return arrListOfBanks.count
        }
        else
        if strGetDetails == "addNewGiftSelectUsers" {
            return arrTotalUser.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:ExampleNewProductTableCel = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ExampleNewProductTableCel
        
        cell.backgroundColor = .clear
        
        if strGetDetails == "savedCardsFromAddMoney" {
            let item = arrListOfSavedCards[indexPath.row] as? [String:Any]
            cell.lblTitle.text = (item!["nameOnCard"] as! String)
            // print(arrListOfSavedCards as Any)
            
            let last4 = (item!["cardNumber"] as! String).suffix(4)
            cell.lblCardNumber.text = "xxxx xxxx xxxx - "+String(last4)
            
            cell.img.sd_setImage(with: URL(string: (item!["imageOnCard"] as! String)), placeholderImage: UIImage(named: "cardPlaceholder")) // my profile image
        }
        else if strGetDetails == "savedBankList" {
            let item = arrListOfBanks[indexPath.row] as? [String:Any]
             // print(item as Any)
            
            cell.lblTitle.text = (item!["bankName"] as! String)
            
            let last4 = (item!["accountNumber"] as! String).suffix(4)
            cell.lblCardNumber.text = "xxxx xxxx xxxx - "+String(last4)
            
            cell.img.sd_setImage(with: URL(string: (item!["bankImage"] as! String)), placeholderImage: UIImage(named: "avatar")) // my profile image
        }
        else if strGetDetails == "savedBankListOrderCard" {
            let item = arrListOfBanks[indexPath.row] as? [String:Any]
            // print(item)
            cell.lblTitle.text = (item!["bankName"] as! String)
            cell.lblCardNumber.text = (item!["created"] as! String)
            
            cell.img.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "bankPlaceholderBlack")) // my profile image
        }
        else if strGetDetails == "addNewGiftSelectUsers" {
            let item = arrTotalUser[indexPath.row] as? [String:Any]
//             print(item)
            cell.lblTitle.text = (item!["userName"] as! String)
            cell.lblCardNumber.text = (item!["contactNumber"] as! String)
            
            cell.img.sd_setImage(with: URL(string: (item!["userImage"] as! String)), placeholderImage: UIImage(named: "avatar")) // my profile image
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
            
        
        if strGetDetails == "savedCardsFromAddMoney" {
            let defaults = UserDefaults.standard
            
            let item = arrListOfSavedCards[indexPath.row] as? [String:Any]
            defaults.set(item, forKey: "keyDoneSelectingCardDetails")
            dismiss(animated: true, completion: nil)
        }
        else if strGetDetails == "savedBankList" {
            let defaults = UserDefaults.standard
            
            let item = arrListOfBanks[indexPath.row] as? [String:Any]
            defaults.set(item, forKey: "keyDoneSelectingBankDetails")
            dismiss(animated: true, completion: nil)
        }
        else if strGetDetails == "savedBankListOrderCard" {
            let defaults = UserDefaults.standard
            
            let item = arrListOfBanks[indexPath.row] as? [String:Any]
            defaults.set(item, forKey: "keyDoneSelectingBankDetails")
            dismiss(animated: true, completion: nil)
        }
        else if strGetDetails == "addNewGiftSelectUsers" {
            let defaults = UserDefaults.standard
            
            let item = arrTotalUser[indexPath.row] as? [String:Any]
            defaults.set(item, forKey: "keyDoneSelectingUser")
            dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
}

extension ExamplePopupViewController: UITableViewDelegate
{
    
}
