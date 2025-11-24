//
//  PersonalDashbaord.swift
//  Swipe
//
//  Created by evs_SSD on 1/22/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit
import MessageUI
import SDWebImage
import Alamofire
import SwiftyJSON
import CRNotifications

class PersonalDashbaord: UIViewController,MFMailComposeViewControllerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var imgUploadYesOrNo:String!
    
    // image
    var imageStr:String!
    var imgData:Data!
    
    var arrTitleStatic = ["Send Money","Cards","Cashout","Request Money","Transaction","Add Money","Bank Account","Order Card","Help"]
    var arrImageTitleStatic = ["p1",
                               "p2",
                               "p7",
                               "receiveMoney",
                               "p9",
                               "p10",
                               "p3",
                               "p5",
                               "p8"]
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "Dashboard"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var btnBack:UIButton!
    
    @IBOutlet weak var lblTotalAmountInWallet:UILabel!
    
    @IBOutlet weak var lblAmountLeftInAccoun:UILabel! {
        didSet {
            lblAmountLeftInAccoun.text = "..."
            lblAmountLeftInAccoun.textColor = .white
        }
    }
    
    @IBOutlet weak var imgBusinessUserProfileImage:UIImageView! {
        didSet {
            imgBusinessUserProfileImage.layer.cornerRadius = 70
            imgBusinessUserProfileImage.clipsToBounds = true
            imgBusinessUserProfileImage.layer.borderColor = UIColor.init(red: 121.0/255.0, green: 128.0/255.0, blue: 181.0/255.0, alpha: 1).cgColor
            imgBusinessUserProfileImage.layer.borderWidth = 10.0
        }
    }
    
    @IBOutlet weak var lblBusinessUserName:UILabel! {
        didSet {
            // lblBusinessUserName.text = "Allen Chandler"
            lblBusinessUserName.textColor = .white
        }
    }
    
    @IBOutlet weak var btnCall:UIButton! {
        didSet {
            btnCall.setTitleColor(.white, for: .normal)
            btnCall.setTitle("12345678", for: .normal)
            btnCall.addTarget(self, action: #selector(callMethodClick), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var btnMail:UIButton! {
        didSet {
            btnMail.setTitleColor(BUTTON_BACKGROUND_COLOR_YELLOW, for: .normal)
            btnMail.addTarget(self, action: #selector(mailMethodClick), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var clView: UICollectionView! {
        didSet {
            //collection
            clView!.dataSource = self
            clView!.delegate = self
            clView!.backgroundColor = .white
            clView.isPagingEnabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DASHBOARD_BACKGROUND_COLOR
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            if("\(person["stripeCustomerNo"]!)" == "") {
                self.create_Stripe_account_After_evs_register()
            }else{
                self.refreshPage()
            }
        }
    }
    
    
    
    @objc func create_Stripe_account_After_evs_register() {
        self.view.endEditing(true)
        
        let urlString = base_url_create_Stripe_customer
        var parameters:Dictionary<AnyHashable, Any>!
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            parameters = [
                "action"        : "createCustomer",
                "email"         : "\(person["email"]!)"
            ]
        }
        
        print("parameters-------\(String(describing: parameters))")
        
        Alamofire.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON {
            response in
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value {
                    
                    let JSON = data as! NSDictionary
                    print(JSON)
                    
                    var strSuccess : String!
                    strSuccess = JSON["status"]as Any as? String
                    
                    if strSuccess == "success" {
                        var strSuccess2 : String!
                        strSuccess2 = JSON["stripeCustomerNo"]as Any as? String
                        self.edit_profile_after_success_register_stripe_wb(strStripeCustomerNumber: strSuccess2)
                        
                        
                    }
                    else {
                        CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Something went wrong. Please try again after some time", dismissDelay: 1.5, completion:{})
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
    
    
    @objc func edit_profile_after_success_register_stripe_wb(strStripeCustomerNumber:String) {
        self.view.endEditing(true)
        
        let urlString = BASE_URL_SWIIPE
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            parameters = [
                "action"            : "editprofile",
                "userId"            : String(myString),
                "stripeCustomerNo"  : String(strStripeCustomerNumber)
            ]
            
            print("parameters-------\(String(describing: parameters))")
            
            Alamofire.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON {
                response in
                
                switch(response.result) {
                case .success(_):
                    if let data = response.result.value {
                        
                        let JSON = data as! NSDictionary
                        print(JSON)
                        
                        /*
                         status = success;
                         stripeCustomerNo = "cus_KRV17ynbdsq3bN";
                         */
                        var strSuccess : String!
                        strSuccess = JSON["status"]as Any as? String
                        
                        /*var strSuccessAlert : String!
                         strSuccessAlert = JSON["msg"]as Any as? String*/
                        
                        if strSuccess == "success" {
                            
                            ERProgressHud.sharedInstance.hide()
                            self.refreshPage()
                        }
                        else {
                            // self.indicator.stopAnimating()
                            // self.enableService()
                            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Something went wrong. Please try again after some time", dismissDelay: 1.5, completion:{})
                            ERProgressHud.sharedInstance.hide()
                            // self.dismiss(animated: true, completion: nil)
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
    
    
    @objc func refreshPage() {
        self.view.endEditing(true)
        
        let urlString = BASE_URL_SWIIPE
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            parameters = [
                "action"            : "editprofile",
                "userId"            : String(myString),
            ]
            
            print("parameters-------\(String(describing: parameters))")
            
            Alamofire.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON {
                response in
                
                switch(response.result) {
                case .success(_):
                    if let data = response.result.value {
                        
                        let JSON = data as! NSDictionary
                        print(JSON)
                        
                        var strSuccess : String!
                        strSuccess = JSON["status"]as Any as? String
                        
                        if strSuccess == "success" {
                            
                            var dict: Dictionary<AnyHashable, Any>
                            dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                            
                            let defaults = UserDefaults.standard
                            defaults.setValue(dict, forKey: "keyLoginFullData")
                            
                            ERProgressHud.sharedInstance.hide()
                            
                            self.gerServerFullData()
                            
                        }
                        else {
                            // self.indicator.stopAnimating()
                            // self.enableService()
                            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Something went wrong. Please try again after some time", dismissDelay: 1.5, completion:{})
                            ERProgressHud.sharedInstance.hide()
                            // self.dismiss(animated: true, completion: nil)
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
    
    
    
    
    
    
    
    // MARK:- GER LOGIN USER FULL DATA HERE
    @objc func gerServerFullData() {
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            // print(person)
            
            /*
             BEmail = "busi@h.com";
             BLat = "0.0";
             BName = budiness;
             BPhone = 6466565656;
             BType = "";
             Baddress = "new delhi";
             Blong = "0.0";
             address = "";
             contactNumber = 3636363652;
             device = Android;
             deviceToken = "";
             email = "testbusiness1@gmail.com";
             firebaseId = "";
             fullName = business;
             image = "http://demo2.evirtualservices.com/swiipe/site/img/uploads/users/1576137063Screenshot_2019-11-06-20-05-14.png";
             lastName = "";
             role = Vendor;
             socialId = "";
             socialType = "";
             userId = 39;
             wallet = "19.99";
             zipCode = "";
             */
            // (person["fullName"] as! String)
            
            /*
             ["zipCode": ,
             "fullName": purnima pandey,
             "firebaseId": ,
             "deviceToken": ,
             "email": pandey@gmail.com,
             "device": Android,
             "wallet": 20,
             "role": Member,
             "contactNumber": 3636365214,
             "socialType": ,
             "socialId": ,
             "lastName": ,
             "image": http://demo2.evirtualservices.com/swiipe/site/img/uploads/users/15731267811573126777250.jpg,
             "userId": 38,
             "address": ]
             */
            
            lblNavigationTitle.text = "Dashboard"
            
            // business image
            imgBusinessUserProfileImage.sd_setImage(with: URL(string: (person["image"] as! String)), placeholderImage: UIImage(named: "plainBack")) // my profile image
            
            // business name
            let test = (person["fullName"] as! String)
            lblBusinessUserName.text = test.capitalizingFirstLetter()//(person["fullName"] as! String)
            
            // business phone
            btnCall.setTitle((person["contactNumber"] as! String), for: .normal)
            
            // business email
            btnMail.setTitle((person["email"] as! String), for: .normal)
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            imgBusinessUserProfileImage.isUserInteractionEnabled = true
            imgBusinessUserProfileImage.addGestureRecognizer(tapGestureRecognizer)
            
            let x : Double = person["wallet"] as! Double
            let foo = x.rounded(digits: 2)
            self.lblTotalAmountInWallet.text = "$ "+"\(foo)"
            
            /*
             let livingArea = person["wallet"] as? Int ?? 0
             if livingArea == 0 {
             let stringValue = String(livingArea)
             self.lblTotalAmountInWallet.text = "$ "+stringValue+"     "
             }
             else
             {
             let stringValue = String(livingArea)
             self.lblTotalAmountInWallet.text = "$ "+stringValue+"     "
             }
             */
            
        }
        else
        {
            // business name
            lblBusinessUserName.text = SERVER_ISSUE_TITLE
            
            // business phone
            btnCall.setTitle(SERVER_ISSUE_TITLE, for: .normal)
            
            // business email
            btnMail.setTitle(SERVER_ISSUE_TITLE, for: .normal)
        }
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let alertController = UIAlertController(title: "View / Upload image", message: nil, preferredStyle: .actionSheet)
        
        let logoutAction = UIAlertAction(title: "View Image", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            
            let present = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OpenImageInFullViewId") as? OpenImageInFullView
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                // send business image ,
                present!.imgString = (person["image"] as! String)
            }
            self.present(present!, animated: true, completion: nil)
            
        }
        
        let okAction = UIAlertAction(title: "Upload image via Camera", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            self.openCamera()
        }
        let cameraAction = UIAlertAction(title: "Upload image via Gallery", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            self.openGallery()
        }
        
        let galleryAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("OK Pressed")
        }
        
        alertController.addAction(logoutAction)
        alertController.addAction(okAction)
        
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        
        self.present(alertController, animated: true, completion: nil)
        
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
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imgUploadYesOrNo = "1"
        
        // let indexPath = IndexPath.init(row: 0, section: 0)
        // let cell = tbleView.cellForRow(at: indexPath) as! EditProfileTableCell
        
        let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imgBusinessUserProfileImage.image = image_data // show image on image view
        let imageData:Data = image_data!.pngData()!
        imageStr = imageData.base64EncodedString()
        self.dismiss(animated: true, completion: nil)
        
        imgData = image_data!.jpegData(compressionQuality: 0.2)!
        
        editWithImage()
        
    }
    
    @objc func editWithImage() {
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            // var parameters:Dictionary<AnyHashable, Any>!
            let parameters = [
                "action"    : "editprofile",
                "userId"    : String(myString),
            ]
            
            print(parameters as Any)
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(self.imgData, withName: "image",fileName: "SwiipePersonalEditProfile.jpg", mimeType: "image/jpg")
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
                            
                            var dict: Dictionary<AnyHashable, Any>
                            dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                            
                            let defaults = UserDefaults.standard
                            defaults.setValue(dict, forKey: "keyLoginFullData")
                            
                            self.imgUploadYesOrNo = "0"
                            
                            
                            
                            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                                // business image
                                self.imgBusinessUserProfileImage.sd_setImage(with: URL(string: (person["image"] as! String)), placeholderImage: UIImage(named: "plainBack"))
                            }
                            
                            
                            
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
                }}}
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
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
    
    
    @objc func callMethodClick() {
        let url: NSURL = URL(string: "tel://8929963020")! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
    
    @objc func mailMethodClick() {
        
        let mailComposeViewController = configureMailComposer()
        if MFMailComposeViewController.canSendMail(){
            self.present(mailComposeViewController, animated: true, completion: nil)
        }else{
            print("Can't send email")
        }
    }
    func configureMailComposer() -> MFMailComposeViewController{
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(["dishantrajput88@gmail.com"])
        mailComposeVC.setSubject("I AM SUBJECT")
        mailComposeVC.setMessageBody("I AM BODY", isHTML: false)
        return mailComposeVC
    }
    //MARK: - MFMail compose method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    /*
     let mailComposeViewController = configuredMailComposeViewController()
     if MFMailComposeViewController.canSendMail() {
     self.present(mailComposeViewController, animated: true, completion: nil)
     } else {
     self.showSendMailErrorAlert()
     }
     */
    //}
    
    /*
     func configuredMailComposeViewController() -> MFMailComposeViewController {
     let mailComposerVC = MFMailComposeViewController()
     mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
     
     mailComposerVC.setToRecipients(["someone@somewhere.com"])
     mailComposerVC.setSubject("I AM SUBJECT")
     mailComposerVC.setMessageBody("I AM MESSAGE BODY", isHTML: false)
     
     return mailComposerVC
     }
     */
    
    func showSendMailErrorAlert() {
        let alert = UIAlertController(title: "Could Not Send Email", message: "You can always access your content by signing back in",         preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
            //Sign out action
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}


extension PersonalDashbaord: UICollectionViewDelegate {
    //Write Delegate Code Here
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "personalDetailsCollectionCell", for: indexPath as IndexPath) as! PersonalDetailsCollectionCell
        
        cell.lblTitle.text  = arrTitleStatic[indexPath.row]
        cell.imgTitle.image = UIImage(named:arrImageTitleStatic[indexPath.row]) // UIImage(named:"edit")
        
        cell.imgTitle.backgroundColor = .clear//NAVIGATION_BUSINESS_BACKGROUND_COLOR
        cell.imgTitle.layer.cornerRadius = 20
        cell.imgTitle.clipsToBounds = true
        
        cell.lblTitle.textColor = .black
        
        cell.backgroundColor = .clear
        
        return cell
    }
    
    //UICollectionViewDatasource methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTitleStatic.count
    }
}

extension PersonalDashbaord: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        let defaults = UserDefaults.standard
        defaults.set("", forKey: "keySideBarMenu")
        defaults.set(nil, forKey: "keySideBarMenu")
        
        if indexPath.row == 0 { // send money
            let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SendMoneyId") as? SendMoney
            self.navigationController?.pushViewController(settingsVCId!, animated: true)
        }
        else
        if indexPath.row == 1 { // cards
            let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ManageCardsId") as? ManageCards
            self.navigationController?.pushViewController(settingsVCId!, animated: true)
        }
        else
        if indexPath.row == 2 { // cashout
            let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CashoutId") as? Cashout
            self.navigationController?.pushViewController(settingsVCId!, animated: true)
            
        }
        else
        if indexPath.row == 3 { // cashout
            
            
            let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SendMoneyPersonalId") as? SendMoneyPersonal
            settingsVCId!.removePlusFromNavigation = "1"
            self.navigationController?.pushViewController(settingsVCId!, animated: true)
            
            
            
            
            
            /*
             let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SendMoneyId") as? SendMoney
             settingsVCId!.removePlusFromNavigation = "1"
             self.navigationController?.pushViewController(settingsVCId!, animated: true)
             */
            
            
            
            
            
            
            
            
            
            
            
            /*
             let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ReceiveListId") as? ReceiveList
             self.navigationController?.pushViewController(settingsVCId!, animated: true)
             */
            
        }
        else
        if indexPath.row == 4 { // transaction
            let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AllTransactionId") as? AllTransaction
            self.navigationController?.pushViewController(settingsVCId!, animated: true)
        }
        else
        if indexPath.row == 5 { // add money
            let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddMoneyId") as? AddMoney
            self.navigationController?.pushViewController(settingsVCId!, animated: true)
            /*
             
             */
            
        }
        else
        if indexPath.row == 6 { // bank account
            let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BankAccountId") as? BankAccount
            self.navigationController?.pushViewController(settingsVCId!, animated: true)
        }
        else
        if indexPath.row == 7 { // order card
            let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: strOrderNewCardId) as? OrderNewCard
            self.navigationController?.pushViewController(settingsVCId!, animated: true)
        }
        else
        if indexPath.row == 8 { // help
            let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HelpId") as? Help
            self.navigationController?.pushViewController(settingsVCId!, animated: true)
        }
        
    }
    
    @objc func pushToBusinessProfile() {
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "GetStartedNowId") as? GetStartedNow
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
        
    }
    
    @objc func pushToPersonalProfile() {
        
    }
    
}

extension PersonalDashbaord: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        var sizes: CGSize
        
        // let result = UIScreen.main.bounds.size
        //NSLog("%f",result.height)
        
        sizes = CGSize(width: 120, height: 120)
        
        /*if result.height == 480
         {
         sizes = CGSize(width: 120, height: 120)
         }
         else if result.height == 568
         {
         sizes = CGSize(width: 120, height: 120)
         }
         else if result.height == 667.000000 // 8
         {
         sizes = CGSize(width: 120, height: 120)
         }
         else if result.height == 736.000000 // 8 plus
         {
         sizes = CGSize(width: 120, height: 120)
         }
         else if result.height == 812.000000 // 11 pro
         {
         sizes = CGSize(width: 120, height: 120)
         }
         else if result.height == 896.000000 // 11 , 11 pro max
         {
         sizes = CGSize(width: 120, height: 120)
         }
         else
         {
         sizes = CGSize(width: self.view.frame.size.width, height: 350)
         }*/
        
        
        return sizes
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
                        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        /*let result = UIScreen.main.bounds.size
         //NSLog("%f",result.height)
         
         if result.height == 812 // 11 pro
         {
         return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
         }
         else
         if result.height == 667 // 11 pro
         {
         return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
         }
         else
         {
         return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
         }*/
    }
    
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}


extension Double {
    func rounded(digits: Int) -> Double {
        let multiplier = pow(10.0, Double(digits))
        return (self * multiplier).rounded() / multiplier
    }
}
