//
//  BusinessDashbaord.swift
//  Swipe
//
//  Created by Apple  on 26/10/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit
import MessageUI
import SDWebImage

class BusinessDashbaord: UIViewController,MFMailComposeViewControllerDelegate {
    
    var arrTitleStatic = ["Send Money","Cards","Add Money","Invoice","Transaction","Process Card","Cashout","Bank Account","Help"]
    var arrImageTitleStatic = ["1",
                               "2",
                               "3",
                               "5",
                               "6",
                               "6",
                               "5",
                               "4",
                               "8"]
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "Dashboard"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var btnBack:UIButton!
    
    var myPhoneNumberIs:String!
    
    @IBOutlet weak var lblTotalAmountInWallet:UILabel!
    
    @IBOutlet weak var lblAmountLeftInAccoun:UILabel! {
        didSet {
            // lblAmountLeftInAccoun.text = "500$"
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
        // self.view.backgroundColor = BUTTON_BACKGROUND_COLOR_BLUE
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
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
        
    }
    
    // MARK:- GER LOGIN USER FULL DATA HERE
    @objc func gerServerFullData() {
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            //              print(person)
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
            
            lblNavigationTitle.text = "Dashboard"
            
            // business image
            imgBusinessUserProfileImage.sd_setImage(with: URL(string: (person["image"] as! String)), placeholderImage: UIImage(named: "plainBack")) // my profile image
            
            // business name
            // lblBusinessUserName.text = (person["fullName"] as! String)
            let test = (person["fullName"] as! String)
            lblBusinessUserName.text = test.capitalizingFirstLetter()//(person["fullName"] as! String)
            
            // business phone
            btnCall.setTitle((person["contactNumber"] as! String), for: .normal)
            
            myPhoneNumberIs = (person["contactNumber"] as! String)
            
            // business email
            btnMail.setTitle((person["email"] as! String), for: .normal)
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            imgBusinessUserProfileImage.isUserInteractionEnabled = true
            imgBusinessUserProfileImage.addGestureRecognizer(tapGestureRecognizer)
            
            //             self.lblTotalAmountInWallet.text = (person["wallet"] as! String)
            
            // let x : NSNumber = person["wallet"] as! NSNumber
            // self.lblTotalAmountInWallet.text = "$ "+"\(x)"
            
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
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        
        let present = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OpenImageInFullViewId") as? OpenImageInFullView
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            // send business image ,
            present!.imgString = (person["image"] as! String)
        }
        self.present(present!, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        sideBarMenuClick()
        
        self.gerServerFullData()
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
        if let url = URL(string: "tel://\(myPhoneNumberIs!)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        /*
         let url: NSURL = URL(string: "tel://\(myPhoneNumberIs)")! as NSURL
         UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
         */
    }
    
    @objc func mailMethodClick() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["someone@somewhere.com"])
        mailComposerVC.setSubject("I AM SUBJECT")
        mailComposerVC.setMessageBody("I AM MESSAGE BODY", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        
        let alert = UIAlertController(title: "Could Not Send Email",
                                      message: "You can always access your content by signing back in",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
            //Sign out action
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension BusinessDashbaord: UICollectionViewDelegate {
    //Write Delegate Code Here
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "businessDashboardCollectionCell", for: indexPath as IndexPath) as! BusinessDashboardCollectionCell
        
        cell.lblTitle.text  = arrTitleStatic[indexPath.row]
        cell.imgTitle.image = UIImage(named:arrImageTitleStatic[indexPath.row]) // UIImage(named:"edit")
        
        cell.imgTitle.backgroundColor = .clear//NAVIGATION_BUSINESS_BACKGROUND_COLOR
        // cell.imgTitle.layer.cornerRadius = 40
        // cell.imgTitle.clipsToBounds = true
        
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

extension BusinessDashbaord: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        let defaults = UserDefaults.standard
        defaults.set("", forKey: "keySideBarMenu")
        defaults.set(nil, forKey: "keySideBarMenu")
        
        if indexPath.row == 0 {
            let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SendMoneyId") as? SendMoney
            self.navigationController?.pushViewController(settingsVCId!, animated: true)
        }
        else
        if indexPath.row == 1 {
            let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ManageCardsId") as? ManageCards
            self.navigationController?.pushViewController(settingsVCId!, animated: true)
        }
        else
        if indexPath.row == 2 {
            let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddMoneyId") as? AddMoney
            self.navigationController?.pushViewController(settingsVCId!, animated: true)
        }
        else
        if indexPath.row == 3 {
            let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "InvoiceId") as? Invoice
            self.navigationController?.pushViewController(settingsVCId!, animated: true)
        }
        else
        if indexPath.row == 4 {
            let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AllTransactionId") as? AllTransaction
            self.navigationController?.pushViewController(settingsVCId!, animated: true)
        }
        else
        if indexPath.row == 5 {
            let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProcessCardPageTwoId") as? ProcessCardPageTwo
            self.navigationController?.pushViewController(settingsVCId!, animated: true)
        }
        else
        if indexPath.row == 6 {
            let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CashoutId") as? Cashout
            self.navigationController?.pushViewController(settingsVCId!, animated: true)
        }
        else
        if indexPath.row == 7 {
            let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BankAccountId") as? BankAccount
            self.navigationController?.pushViewController(settingsVCId!, animated: true)
        }
        else
        if indexPath.row == 8 {
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

extension BusinessDashbaord: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        var sizes: CGSize
        
        let result = UIScreen.main.bounds.size
        NSLog("%f",result.height)
        
        
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
        // let result = UIScreen.main.bounds.size
        //NSLog("%f",result.height)
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        /*if result.height == 812 // 11 pro
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
