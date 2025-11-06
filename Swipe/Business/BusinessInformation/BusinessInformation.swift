//
//  BusinessInformation.swift
//  Swipe
//
//  Created by Apple  on 26/10/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit

class BusinessInformation: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {

    var arrBusinessType = ["Select Business Type", "Business Type 1","Business Type 2","Business Type 3","Business Type 4","Business Type 5"]
    
    var itemSelected = ""
    
    var pickerView: UIPickerView?
    var pickerViewSection: UIPickerView?
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "Business Information"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
    }
    
    @IBOutlet var txtBusinessType: UITextField! {
        didSet {
            textFieldCustomMethod(textField: txtBusinessType, placeholder: "Type of Business")
        }
    }
    
    @IBOutlet var txtBusinessName: UITextField! {
        didSet {
            textFieldCustomMethod(textField: txtBusinessName, placeholder: "Business Name")
        }
    }
    
    @IBOutlet var txtPhoneNumber: UITextField! {
        didSet {
            txtPhoneNumber.keyboardType = .numberPad
            textFieldCustomMethod(textField: txtPhoneNumber, placeholder: "Phone Number")
        }
    }
    
    @IBOutlet var txtEmailAddress: UITextField! {
        didSet {
            txtEmailAddress.keyboardType = .emailAddress
            textFieldCustomMethod(textField: txtEmailAddress, placeholder: "Email Address")
        }
    }
    
    @IBOutlet var txtUploadLocation: UITextField! {
        didSet {
            textFieldCustomMethod(textField: txtUploadLocation, placeholder: "Location")
        }
    }
    
    @IBOutlet var txtUploadImage: UITextField! {
        didSet {
            textFieldCustomMethod(textField: txtUploadImage, placeholder: "Upload Image")
        }
    }
    
    @IBOutlet weak var btnSaveAndFinish:UIButton! {
        didSet {
            btnSaveAndFinish.backgroundColor = BUTTON_BACKGROUND_COLOR_BLUE
            btnSaveAndFinish.layer.cornerRadius = 4
            btnSaveAndFinish.clipsToBounds = true
            btnSaveAndFinish.setTitleColor(.white, for: .normal)
            btnSaveAndFinish.setTitle("Save & Finish", for: .normal)
            btnSaveAndFinish.addTarget(self, action: #selector(saveAndFinishClickMethod), for: .touchUpInside)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //UIPICKER
        self.pickerView = UIPickerView()
        self.pickerView?.delegate = self //#1
        self.pickerView?.dataSource = self //#1
        
        txtBusinessType.inputView = self.pickerView
        
        self.pickerView?.backgroundColor = BUTTON_BACKGROUND_COLOR_BLUE
        
        self.view.backgroundColor = .white
        
        let defaults = UserDefaults.standard
        let userName = defaults.string(forKey: "KeyLoginPersonal")
        if userName == "loginViaPersonal" {
            // personal user
            navigationBar.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
             self.view.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
        }
        else {
            navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
            self.view.backgroundColor = BUTTON_BACKGROUND_COLOR_BLUE
        }
        
        /*
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
         */
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveAndFinishClickMethod() {
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BankAccountId") as? BankAccount
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
    }
    
    /*
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    */
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view .endEditing(true)
        return true
    }
    
    
    func textFieldCustomMethod(textField: UITextField,placeholder:String){
        textField.delegate = self
        textField.backgroundColor = .clear
        textField.keyboardAppearance = .dark
        textField.layer.cornerRadius = 4
        textField.clipsToBounds = true
        textField.layer.borderColor  = UIColor.darkGray.cgColor
        textField.layer.borderWidth = 0.80
        textField.textAlignment = .left
        textField.textColor = .black
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.font : UIFont(name: "OpenSans-Bold", size: 12)!
        ]

        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes:attributes)
        
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 2.0))
        textField.leftView = leftView
        textField.leftViewMode = .always
    }
    
    
    
    
    //    picker delegates
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if txtBusinessType.isFirstResponder
        {
            return arrBusinessType.count
        }
        
        
        

        return 0
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        
        if txtBusinessType.isFirstResponder
        {
            return arrBusinessType[row]
        }
        
        
        
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if txtBusinessType.isFirstResponder
        {
            let itemselected = arrBusinessType[row]
            txtBusinessType.text = itemselected
        }
        
        
    }
    
    
    
  
}
