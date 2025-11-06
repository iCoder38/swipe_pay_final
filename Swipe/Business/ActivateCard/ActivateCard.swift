//
//  ActivateCard.swift
//  Swipe
//
//  Created by Apple on 04/11/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit

class ActivateCard: UIViewController,UITextFieldDelegate {

    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?
    
    /* ****************************************** */
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "Activate Card"
            lblNavigationTitle.textColor = .white
        }
    }
    
    
    /* ****************************************** */
    
    @IBOutlet weak var txtNameOnCard:UITextField! {
        didSet {
            setPaddingWithImage(textField: txtNameOnCard, strPlaceholder: "Name on Card")
        }
    }
    
    @IBOutlet weak var txtCardNumber:UITextField! {
        didSet {
            setPaddingWithImage(textField: txtCardNumber, strPlaceholder: "Card Number")
        }
    }
    
    @IBOutlet weak var txtCardExpiryDate:UITextField! {
        didSet {
            setPaddingWithImage(textField: txtCardExpiryDate, strPlaceholder: "Expiry Date")
        }
    }
    
    @IBOutlet weak var txtCVV:UITextField! {
        didSet {
            setPaddingWithImage(textField: txtCVV, strPlaceholder: "CVV")
        }
    }
    
    @IBOutlet weak var txtPayableAmount:UITextField! {
        didSet {
            setPaddingWithImage(textField: txtPayableAmount, strPlaceholder: "Payable Amount")
        }
    }
    
    
    /* ****************************************** */
    
    
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
    }
    
    
    
    @IBOutlet weak var btnPayNow:UIButton! {
        didSet {
            setButtonUI(btnUiDesign: btnPayNow, strText: "Pay Now")
            btnPayNow.addTarget(self, action: #selector(payNowClickMethod), for: .touchUpInside)
        }
    }
    
    
    
    
    @IBOutlet weak var viewTopView:UIView! {
        didSet {
            viewTopView.backgroundColor = UIColor.init(red: 107.0/255.0, green: 221.0/255.0, blue: 251.0/255.0, alpha: 1)
        }
    }
    
    /* ****************************************** */
    
    @IBOutlet weak var lblFeesForActivationCard:UILabel! {
        didSet {
            lblFeesForActivationCard.text = "$5.99 Fees for Activation Card"
            lblFeesForActivationCard.textColor = .white
        }
    }
    
    /* ****************************************** */
    
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
        
        // detect card type
               txtCardNumber.addTarget(self, action: #selector(reformatAsCardNumber), for: .editingChanged)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }

    
    
    @objc func payNowClickMethod() {
        
    }
    
    
    
    
    /* ****************************************** */
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    /* ****************************************** */
    
    
    
    
    //MARK:- CARD VALIDATION
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
    
    
    //MARK:- TEXT FIELD UI
    func setPaddingWithImage(textField: UITextField,strPlaceholder:String){
        textField.delegate = self
        textField.font = NAVIGATION_TITLE_FONT_14
        textField.attributedPlaceholder = NSAttributedString(string: strPlaceholder,
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        let indentView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        textField.leftView = indentView
        textField.leftViewMode = .always
        textField.keyboardAppearance = .dark
    }
    //MARK:- BUTTON UI
    func setButtonUI(btnUiDesign:UIButton,strText:String){
        btnUiDesign.setTitle(strText, for: .normal)
        btnUiDesign.layer.cornerRadius = 4
        btnUiDesign.clipsToBounds = true
        btnUiDesign.setTitleColor(.white, for: .normal)
        btnUiDesign.backgroundColor = BUTTON_BACKGROUND_COLOR_BLUE
    }
    
}
