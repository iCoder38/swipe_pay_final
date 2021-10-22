//
//  Utils.swift
//  KREASE
//
//  Created by Apple  on 16/10/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit
import RSLoadingView

// 25,32,143
// let BASE_URL_SWIIPE = "http://demo2.evirtualservices.com/swiipe/site/services/index"
let BASE_URL_SWIIPE = "http://app.swiipe-pay.com/site/services/index"

let base_url_create_Stripe_customer = "http://app.swiipe-pay.com/site/webroot/strip_master/charge_bank.php"

// 0 ,//// 179 , 138

let NAVIGATION_PERSONAL_BACKGROUND_COLOR = UIColor.init(red: 0.0/255.0, green: 179.0/255.0, blue: 138.0/255.0, alpha: 1)
// 0 , 155 , 123
let DASHBOARD_BACKGROUND_COLOR = UIColor.init(red: 0.0/255.0, green: 155.0/255.0, blue: 123.0/255.0, alpha: 1)



let NAVIGATION_BUSINESS_BACKGROUND_COLOR = UIColor.init(red: 25.0/255.0, green: 32.0/255.0, blue: 143.0/255.0, alpha: 1)

let NAVIGATION_TITLE_FONT_12 = UIFont(name: "Avenir Next", size: 12)
let NAVIGATION_TITLE_FONT_14 = UIFont(name: "Avenir", size: 14)
let NAVIGATION_TITLE_FONT_16 = UIFont(name: "Avenir", size: 16)

let BUTTON_BACKGROUND_COLOR = UIColor.init(red: 242.0/255.0, green: 208.0/255.0, blue: 11.0/255.0, alpha: 1)

let BUTTON_BACKGROUND_COLOR_GREEN = UIColor.init(red: 53.0/255.0, green: 211.0/255.0, blue: 100.0/255.0, alpha: 1)
let BUTTON_BACKGROUND_COLOR_BLUE = UIColor.init(red: 25.0/255.0, green: 32.0/255.0, blue: 143.0/255.0, alpha: 1)
let BUTTON_BACKGROUND_COLOR_YELLOW = UIColor.init(red: 242.0/255.0, green: 208.0/255.0, blue: 11.0/255.0, alpha: 1)

let PLACEHOLDER_EMAIL       = "Email address"
let PLACEHOLDER_PASSWORD    = "Password"
let PLACEHOLDER_NAME        = "Name"
let PLACEHOLDER_PHONE       = "Phone"
let PLACEHOLDER_ADDRESS     = "Address"

//MARK:- STORYBOARD IDs
let strAllTransactionId         = "AllTransactionId"
let strBusinessDashbaordId      = "BusinessDashbaordId"
let strBusinessProcessingCardId    = "ProcessingCardListId"
let strOrderNewCardId           = "OrderNewCardId"
let strOrderedCardList           = "OrderedCardListId"
let strEditId                 = "EditProfileId"
let strManageCardsId                 = "ManageCardsId"
let strSendMoney                 = "SendMoneyId"
let strAddMoneyId                 = "AddMoneyId"
let strCashoutId                 = "CashoutId"
let strCashoutTransaction                 = "CashoutTransactionId"
let strHelpId                 = "HelpId"
let strChangePassword                 = "ChangePasswordId"

// SERVER ISSUE
let SERVER_ISSUE_TITLE          = "Server Issue."
let SERVER_ISSUE_MESSAGE_ONE    = "Server Not Responding."
let SERVER_ISSUE_MESSAGE_TWO    = "Please contact to Server Admin."

// validations
let strNameValidation:String = "Name should not be empty."
let strPhoneValidation:String = "Phone should not be empty."

class Utils: NSObject {
    
    class func RiteVetIndicatorShow() {
        let loadingView = RSLoadingView()
        loadingView.shouldTapToDismiss = false
        loadingView.variantKey = "inAndOut"
        loadingView.speedFactor = 2.0
        loadingView.lifeSpanFactor = 2.0
        loadingView.mainColor = UIColor.blue
        loadingView.showOnKeyWindow()
    }
    
    class func RiteVetIndicatorPesonalShow() {
        let loadingView = RSLoadingView()
        loadingView.shouldTapToDismiss = false
        loadingView.variantKey = "inAndOut"
        loadingView.speedFactor = 2.0
        loadingView.lifeSpanFactor = 2.0
        loadingView.mainColor = .systemGreen
        loadingView.showOnKeyWindow()
    }
    
    class func RiteVetIndicatorHide() {
        let loadingView = RSLoadingView()
        loadingView.mainColor = UIColor.clear
        loadingView.showOnKeyWindow()
        loadingView.hide()
    }
    
}
