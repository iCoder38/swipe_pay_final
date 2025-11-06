//
//  OrderNewCard.swift
//  Swipe
//
//  Created by Apple on 04/11/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import CRNotifications

import BottomPopup

class OrderNewCard: UIViewController,UIScrollViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    let cellReuseIdentifier = "orderNewCardTableCell"
    
    // bottom view popup
    var height: CGFloat = 600 // height
    var topCornerRadius: CGFloat = 35 // corner
    var presentDuration: Double = 0.8 // present view time
    var dismissDuration: Double = 0.5 // dismiss view time
    let kHeightMaxValue: CGFloat = 600 // maximum height
    let kTopCornerRadiusMaxValue: CGFloat = 35 //
    let kPresentDurationMaxValue = 3.0
    let kDismissDurationMaxValue = 3.0
    
    // save ids
    var saveCardId:String!
    var saveBankAccountId:String!
    var saveTransactionId:String!
    
    // array list
    var arrListOfAllBanks:Array<Any>!
    
    
    
    // image
    var imgUploadYesOrNo:String!
    @IBOutlet weak var imgProfile:UIImageView! 
    
    var imageStr:String!
    var imgData:Data!
    
    /* ****************************************** */
    
    // ORDER CARD PAGE
    @IBOutlet weak var lblBankName:UILabel! {
        didSet {
            lblBankName.textColor = .white
        }
    }
    @IBOutlet weak var lblCardNumber:UILabel! {
        didSet {
            lblCardNumber.textColor = .white
        }
    }
    @IBOutlet weak var lblValidThru:UILabel! {
        didSet {
            lblValidThru.textColor = .white
        }
    }
    @IBOutlet weak var lblCardHolderName:UILabel! {
        didSet {
            lblCardHolderName.textColor = .white
        }
    }
    
    @IBOutlet weak var imgBankImage:UIImageView! {
        didSet {
            imgBankImage.layer.cornerRadius = 15
            imgBankImage.clipsToBounds = true
        }
    }
    
    /* ****************************************** */
    
    
    /* ****************************************** */
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            // navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "Order New Card"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.setImage(UIImage(named: "menuWhite"), for: .normal)
        }
    }
    
    /* ****************************************** */
    
    
    
    
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
                tbleView.delegate = self
                tbleView.dataSource = self
                self.tbleView.backgroundColor = .white
                self.tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))

               }
       }
    
    
    
    
    
    
    /* ****************************************** */
    
    @IBOutlet weak var btnSubmit:UIButton! {
        didSet {
            setButtonUI(btnUiDesign: btnSubmit, strText: "Submit Request")
            btnSubmit.addTarget(self, action: #selector(submitClickMethod), for: .touchUpInside)
        }
    }
    
    /* ****************************************** */
    
    
    
    
    
    
    /* ****************************************** */
    @IBOutlet weak var cardBGView:UIView! {
        didSet {
            setCardBGViewUI(viewName: cardBGView)
        }
    }
    /* ****************************************** */
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        
        let result = UIScreen.main.bounds.size
        if result.height == 896.000000 {
            
        }
        else {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        
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
        
        self.listOfBankWB()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        sideBarMenuClick()
    }

        @objc func sideBarMenuClick() {
            if revealViewController() != nil {
            btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
                revealViewController().rearViewRevealWidth = 300
                view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
              }
        }
    
       override var preferredStatusBarStyle: UIStatusBarStyle {
             return .lightContent
       }
    
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view .endEditing(true)
        return true
    }
    
    @objc func submitClickMethod() {
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ActivateCardId") as? ActivateCard
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
    }
    
    @objc func uploadImageOpenActionSheet() {
        let alert = UIAlertController(title: "Upload image", message: "Camera or Gallery", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
             self.openCamera()
        }))

        alert.addAction(UIAlertAction(title: "Gallery", style: .default , handler:{ (UIAlertAction)in
             self.openGallery()
        }))

        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler:{ (UIAlertAction)in
            //print("User click Dismiss button")
        }))

        self.present(alert, animated: true, completion: {
            //print("completion block")
        })
    }
    @objc func openCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera;
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func openGallery() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary;
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
        {
        
            imgUploadYesOrNo = "1"
            
            // let indexPath = IndexPath.init(row: 0, section: 0)
            // let cell = tbleView.cellForRow(at: indexPath) as! EditProfileTableCell
            
            let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            imgProfile.image = image_data // show image on image view
            let imageData:Data = image_data!.pngData()!
            imageStr = imageData.base64EncodedString()
            self.dismiss(animated: true, completion: nil)
            
            imgData = image_data!.jpegData(compressionQuality: 0.2)!

            
    }
    
    
    //MARK:- VIEW UI
    func setCardBGViewUI(viewName:UIView){
        viewName.backgroundColor = UIColor.init(red: 78.0/255.0, green: 92.0/255.0, blue: 173.0/255.0, alpha: 1)
        viewName.layer.cornerRadius = 4
        viewName.clipsToBounds = true
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

    func textFieldCustomMethod(textField: UITextField,placeholder:String){
        textField.delegate = self
        textField.backgroundColor = .clear
        textField.placeholder = placeholder
        textField.keyboardAppearance = .dark
        textField.textAlignment = .left
        textField.textColor = .black
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.font : UIFont(name: "OpenSans-Bold", size: 12)!
        ]

        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes:attributes)
        
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 2.0))
        textField.leftView = leftView
        textField.leftViewMode = .always
        
        
        // lower border
        let bottomLine = CALayer()
        
        let result = UIScreen.main.bounds.size
        //NSLog("%f",result.height)
        
        if result.height == 667 // 8
        {
            bottomLine.frame = CGRect(x : 0.0 ,y : textField.frame.height - 1 ,width : textField.frame.width-40,height : 1.0)
        }
        else
            if result.height == 736 // 8 plus
            {
                bottomLine.frame = CGRect(x : 0.0 ,y : textField.frame.height - 1 ,width : textField.frame.width,height : 1.0)
            }
        else
           if result.height == 896 // 11 , 11 pro max
           {
               bottomLine.frame = CGRect(x : 0.0 ,y : textField.frame.height - 1 ,width : textField.frame.width,height : 1.0)
           }
        else
            if result.height == 812 // 11 pro
            {
                bottomLine.frame = CGRect(x : 0.0 ,y : textField.frame.height - 1 ,width : textField.frame.width-40,height : 1.0)
            }
        
        bottomLine.backgroundColor = UIColor.black.cgColor
        textField.borderStyle = UITextField.BorderStyle.none
        textField.layer.addSublayer(bottomLine)
        
    }
    
}

/*
 
 */

extension OrderNewCard: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1 // arrListOfCards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:OrderNewCardTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! OrderNewCardTableCell
        
        cell.backgroundColor = .white
        
        /*
         setPaddingWithImage(textField: txtSelectBank, strPlaceholder: "Select Bank")
         setPaddingWithImage(textField: txtYourName, strPlaceholder: "Your Name")
         setPaddingWithImage(textField: txtAccountNumber, strPlaceholder: "Account Number")
         setPaddingWithImage(textField: txtPhoneNumber, strPlaceholder: "Phone Number")
         setPaddingWithImage(textField: txtEmailAddress, strPlaceholder: "Email Address")
         setPaddingWithImage(textField: txtUploadImage, strPlaceholder: "Upload Image")
         */
        
        // let item = arrListOfCards[indexPath.row] as? [String:Any]
        
        textFieldCustomMethod(textField: cell.txtSelectBank, placeholder: "Select Bank")
        textFieldCustomMethod(textField: cell.txtYourName, placeholder: "Your Name")
        textFieldCustomMethod(textField: cell.txtAccountNumber, placeholder: "Account Number")
        textFieldCustomMethod(textField: cell.txtPhoneNumber, placeholder: "Phone Number")
        textFieldCustomMethod(textField: cell.txtEmailAddress, placeholder: "Email Address")
        textFieldCustomMethod(textField: cell.txtUploadImage, placeholder: "Upload Image")
        
        cell.btnOpenBankList.addTarget(self, action: #selector(submitRequestClickMethod), for: .touchUpInside)
        
        cell.btnSubmitRequest.addTarget(self, action: #selector(submitRequestWB), for: .touchUpInside)
        
        let defaults = UserDefaults.standard
        let userName = defaults.string(forKey: "KeyLoginPersonal")
        if userName == "loginViaPersonal" {
            // personal user
            cell.btnSubmitRequest.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
            cell.btnSubmitRequest.setTitleColor(.white, for: .normal)
        }
        else {
            cell.btnSubmitRequest.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
            cell.btnSubmitRequest.setTitleColor(.white, for: .normal)
        }
        
        cell.btnUpload.addTarget(self, action: #selector(uploadImageOpenActionSheet), for: .touchUpInside)
        
        return cell
    }
    
    @objc func submitRequestClickMethod() {
        guard let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "secondVC") as? ExamplePopupViewController else { return }
        popupVC.height = self.height
        popupVC.topCornerRadius = self.topCornerRadius
        popupVC.presentDuration = self.presentDuration
        popupVC.dismissDuration = self.dismissDuration
        //popupVC.shouldDismissInteractivelty = dismissInteractivelySwitch.isOn
        popupVC.popupDelegate = self
        popupVC.strGetDetails = "savedBankListOrderCard"
        //popupVC.getArrListOfCategory =
         popupVC.arrListOfBanks = self.arrListOfAllBanks as NSArray?
        self.present(popupVC, animated: true, completion: nil)
    }
    
    // MARK:- LIST OF BANKS
    @objc func listOfBankWB() {
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
         [action] => banklist
         */
                   parameters = [
                       "action" : "banklist"
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
                                
                                var ar : NSArray!
                                ar = (JSON["data"] as! Array<Any>) as NSArray
                                self.arrListOfAllBanks = (ar as! Array<Any>)
                                
                                //self.arrListOfAllCards = self.arrListOfSavedCards
                                
    
                                
                                
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
    
    @objc func submitRequestWB() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! OrderNewCardTableCell
        
        
        
        if cell.txtSelectBank.text == "" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Select Bank should not be empty.", dismissDelay: 1.5, completion:{})
        }
        else
            if cell.txtYourName.text == "" {
                CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Name should not be empty.", dismissDelay: 1.5, completion:{})
            }
            else
                if cell.txtAccountNumber.text == "" {
                    CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Account number should not be empty.", dismissDelay: 1.5, completion:{})
                }
                else
                    if cell.txtPhoneNumber.text == "" {
                        CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Phone number should not be empty.", dismissDelay: 1.5, completion:{})
                    }
                    else
                        if cell.txtEmailAddress.text == "" {
                            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Email address should not be empty.", dismissDelay: 1.5, completion:{})
                        }
                        else
        {
        
        
        
        
        if imgUploadYesOrNo == "1" {
            // send to multipart wb
            
            self.requestCardWithImage()
        }
        else {
        
        
/*
         [action] => requestcard
         [userId] => 74
         [bankId] => 2
         [accountName] => Mobile Gaming iPhone X
         [accountNo] => 252512154245134
         [phoneNo] => 4484046494
         [email] => dishantrajput38@gmail.com
         [type] => DEBIT
         */
        
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
                           "action" : "requestcard",
                           "userId" : String(myString),
                           "bankId" : String(saveBankAccountId),
                           "accountName" : String(cell.txtYourName.text!),
                           "accountNo" : String(cell.txtAccountNumber.text!),
                           "phoneNo" : String(cell.txtPhoneNumber.text!),
                           "email" : String(cell.txtEmailAddress.text!),
                           "type" : "DEBIT"
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
                                    ERProgressHud.sharedInstance.hide()
                                    CRNotifications.showNotification(type: CRNotifications.success, title: "Success!", message:strSuccessAlert, dismissDelay: 1.5, completion:{})
                                    
                                    cell.txtSelectBank.text = ""
                                    cell.txtYourName.text = ""
                                    cell.txtAccountNumber.text = ""
                                    cell.txtPhoneNumber.text = ""
                                    cell.txtEmailAddress.text = ""
                                    // cell.imageView.
                                    self.imgBankImage.image = nil
                                    
                                    let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OrderedCardListId") as? OrderedCardList
                                    self.navigationController?.pushViewController(settingsVCId!, animated: true)
                                    
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
    }
    
    // MARK:- REQUEST CARD WITH IMAGE
    @objc func requestCardWithImage() {

        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! OrderNewCardTableCell
        
        if cell.txtSelectBank.text == "" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Select Bank should not be empty.", dismissDelay: 1.5, completion:{})
        }
        else
        if cell.txtYourName.text == "" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Your Name should not be empty.", dismissDelay: 1.5, completion:{})
        }
        else
        if cell.txtAccountNumber.text == "" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Acount Number should not be empty.", dismissDelay: 1.5, completion:{})
        }
        else
        if cell.txtPhoneNumber.text == "" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Phone Number should not be empty.", dismissDelay: 1.5, completion:{})
        }
        else
        if cell.txtEmailAddress.text == "" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Email address should not be empty.", dismissDelay: 1.5, completion:{})
        }
        else {
        
        
        
        
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
         let x : Int = (person["userId"] as! Int)
         let myString = String(x)
          
            // var parameters:Dictionary<AnyHashable, Any>!
                 let parameters = [
                     "action" : "requestcard",
                     "userId" : String(myString),
                     "bankId" : String(saveBankAccountId),
                     "accountName" : String(cell.txtYourName.text!),
                     "accountNo" : String(cell.txtAccountNumber.text!),
                     "phoneNo" : String(cell.txtPhoneNumber.text!),
                     "email" : String(cell.txtEmailAddress.text!),
                     "type" : "DEBIT"
                 ]
                
                    print(parameters as Any)
                
                Alamofire.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(self.imgData, withName: "imageOnCard",fileName: "SwiipeBusinessOrderedCard.jpg", mimeType: "image/jpg")
                    for (key, value) in parameters {
                        
                        // let paramsData:Data = NSKeyedArchiver.archivedData(withRootObject: value)
                        
                        multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                    }
                },
                to:BASE_URL_SWIIPE)
                { (result) in
                    switch result {
                    case .success(let upload, _, _):

                        upload.uploadProgress(closure: { (progress) in
                            //print("Upload Progress: \(progress.fractionCompleted)")
                            
                            let alertController = UIAlertController(title: "Uploading image", message: "Please wait......", preferredStyle: .alert)

                            let progressDownload : UIProgressView = UIProgressView(progressViewStyle: .default)

                            progressDownload.setProgress(Float((progress.fractionCompleted)/1.0), animated: true)
                            progressDownload.frame = CGRect(x: 10, y: 70, width: 250, height: 0)

                            alertController.view.addSubview(progressDownload)
                            self.present(alertController, animated: true, completion: nil)
                        })

                        upload.responseJSON { response in
                            //print(response.result.value as Any)
                            if let data = response.result.value
                            {
                                 let JSON = data as! NSDictionary
                                 print(JSON)

                                // var dict: Dictionary<AnyHashable, Any>
                                // dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                                
                                // let defaults = UserDefaults.standard
                                // defaults.setValue(dict, forKey: "keyLoginFullData")
                                
                                self.imgUploadYesOrNo = "0"
                                
                                let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OrderedCardListId") as? OrderedCardList
                                self.navigationController?.pushViewController(settingsVCId!, animated: true)
                                
                                ERProgressHud.sharedInstance.hide()
                                self.dismiss(animated: true, completion: nil)
                            }
                            else
                            {
                                CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Server Not Responding. Please try again Later.", dismissDelay: 1.5, completion:{})

                            }
                        }
                    case .failure(let encodingError):
                        print(encodingError)
                        self.dismiss(animated: true, completion: nil)
                    }}}}
        
    }
    
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 780
}
    
    
}


extension OrderNewCard: UITableViewDelegate
{
    
}

extension OrderNewCard: BottomPopupDelegate {
    
    func bottomPopupViewLoaded() {
        print("bottomPopupViewLoaded")
    }
    
    func bottomPopupWillAppear() {
        print("bottomPopupWillAppear")
    }
    
    func bottomPopupDidAppear() {
        print("bottomPopupDidAppear")
    }
    
    func bottomPopupWillDismiss() {
        print("bottomPopupWillDismiss")
        // one
    }
    
    func bottomPopupDidDismiss() {
        print("bottomPopupDidDismiss")
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! OrderNewCardTableCell
        
        // bank details default
        if let person = UserDefaults.standard.value(forKey: "keyDoneSelectingBankDetails") as? [String:Any]
        {
            // print(person as Any)
            
            /*
            Optional(["image": http://demo2.evirtualservices.com/swiipe/site/img/uploads/bank/Wells_Fargo_Bank.svg.png, "created": Oct 30th, 2019, 6:54 am, "bankName": WELLS FARGO, "bankId": 4])
            */
            
            let x : Int = (person["bankId"] as! Int)
            let myString = String(x)
            // print(myString as Any)
            
            saveBankAccountId = myString
            
            // strGetBankOrCard = "BANK"
            saveTransactionId = "tok_1G1TJqBnk7ygV50qStTUp7x3"
            
            self.lblBankName.text = (person["bankName"] as! String)
            cell.txtSelectBank.text = (person["bankName"] as! String)
            
            // bank image
            imgBankImage.sd_setImage(with: URL(string: (person["image"] as! String)), placeholderImage: UIImage(named: "bankPlaceholderBlack")) // my profile image
            
            let defaults = UserDefaults.standard
            defaults.set("", forKey: "keyDoneSelectingBankDetails")
            defaults.set(nil, forKey: "keyDoneSelectingBankDetails")
            
        }
        else
        {
            print("Never went to that page.")
        }
        
        // bank details
       
    }
    
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
        print("bottomPopupDismissInteractionPercentChanged fromValue: \(oldValue) to: \(newValue)")
    }
}
