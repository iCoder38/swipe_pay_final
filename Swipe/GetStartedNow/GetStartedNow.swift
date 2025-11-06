//
//  GetStartedNow.swift
//  KREASE
//
//  Created by Apple  on 16/10/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import CRNotifications

class GetStartedNow: UIViewController,UIScrollViewDelegate,UITextFieldDelegate,CLLocationManagerDelegate {
    
    enum Direction {
        case Left
        case Right
    }

    var latDouble:Double!
    var longDouble:Double!
    
    var locationManager:CLLocationManager!
    
    let indicator = UIActivityIndicatorView()
    
    var wWidth:Int!
    var wWidthBtnSignInUp:Int!
    var wWidthBtnSignUpUp:Int!
    
    var btnUpperTwoBtnX:Int!
    var btnUpperTwoBtnY:Int!
    var btnUpperTwoBtnW:Int!
    var btnUpperTwoBtnH:Int!
    
    var collectionView: UICollectionView?
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "GET STARTED NOW"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var btnSignIn:UIButton!{
        didSet {
            btnSignIn.isHidden = true
         }
    }
    
    @IBOutlet weak var btnSignUp:UIButton!{
        didSet {
            btnSignUp.isHidden = true
        }
    }
    
    @IBOutlet weak var scrollView:UIScrollView! {
        didSet {
            scrollView.isPagingEnabled = true
            scrollView.backgroundColor = .red
        }
    }
    
    @IBOutlet weak var clView: UICollectionView!
        {
        didSet
        {
            //collection
            clView!.dataSource = self
            clView!.delegate = self
            clView!.backgroundColor = .white
            clView.isPagingEnabled = true
            clView.backgroundColor = .white
        }
    }
    
    override func viewDidLoad() {
    super.viewDidLoad()

        mobileMesurements()
        mobileMesurementsTwoButtonsUp()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    
       indicator.style = .large
       indicator.color = .orange
       indicator.center = self.view.center
       self.view.addSubview(indicator)
        
        login()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    // MARK:- GET MY CURRENT LOCATION
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // scroll collection view
    @objc func signInUpperClickMethod() {
        let collectionBounds = clView.bounds
        let contentOffset = CGFloat(floor(clView.contentOffset.x - collectionBounds.size.width))
        self.moveCollectionToFrame(contentOffset: contentOffset)
    }
    
    //scroll collection view
    @objc func signUpUpperClickMethod() {
        let collectionBounds = clView.bounds
        let contentOffset = CGFloat(floor(clView.contentOffset.x + collectionBounds.size.width))
        self.moveCollectionToFrame(contentOffset: contentOffset)
    }
    
    func moveCollectionToFrame(contentOffset : CGFloat) {
        let frame: CGRect = CGRect(x : contentOffset ,y : clView.contentOffset.y ,width : clView.frame.width,height : clView.frame.height)
        clView.scrollRectToVisible(frame, animated: true)
    }
    
    @objc func tempInClickMethod() {
        // LAUNDRONEER
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
        self.view.window?.rootViewController = sw
        let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "DashboardLaundroneerId")
        let navigationController = UINavigationController(rootViewController: destinationController!)
        sw.setFront(navigationController, animated: true)
    }
    
    @objc func getSignInClickMethod() {
         
        
         // USER
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
        self.view.window?.rootViewController = sw
        let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "DashboardUserId")
        let navigationController = UINavigationController(rootViewController: destinationController!)
        sw.setFront(navigationController, animated: true)
         
        
    }
    
    
        @objc func mobileMesurements() {
        let result = UIScreen.main.bounds.size
        //NSLog("%f",result.height);
        if result.height == 480
        {wWidth = 375}
        else if result.height == 568
        {wWidth = 320}
        else if result.height == 667.000000 // 8
        {wWidth = 340}
        else if result.height == 736.000000 // 8 plus
        {wWidth = 375}
        else if result.height == 812.000000 // 11 pro
        {wWidth = 340}
        else if result.height == 896.000000 // 11 , 11 pro max
        {wWidth = 375}
        else
        {wWidth = 375}
    }
    
    @objc func mobileMesurementsTwoButtonsUp() {
        btnUpperTwoBtnH = 50
        let result = UIScreen.main.bounds.size
        //NSLog("%f",result.height);
        if result.height == 480
        {wWidth = 375}
        else if result.height == 568
        {wWidth = 320}
        else if result.height == 667.000000 // 8
        {wWidth = 340
            let xAxis = 192 // x
            btnUpperTwoBtnX = xAxis
            
            // 366
            let y = 252 // y
            btnUpperTwoBtnY = y
            
            let w = 190 //w
            btnUpperTwoBtnW = w
            
            twoButtonUpperSideOfCollectionView()
        }
        else if result.height == 736.000000 // 8 plus
        {wWidth = 375
            let xAxis = 200 // x // OBLY FOR BLUE
            btnUpperTwoBtnX = xAxis
            
            let y = 320 // y
            btnUpperTwoBtnY = y
            
            let w = 220 //w
            btnUpperTwoBtnW = w
            
            twoButtonUpperSideOfCollectionView()
        }
        else if result.height == 812.000000 // 11 pro
        {wWidth = 340
            let xAxis = 200 // x // ONLY FOR BLUE
            btnUpperTwoBtnX = xAxis
            
            let y = 362 // y
            btnUpperTwoBtnY = y
            
            let w = 220 //w
            btnUpperTwoBtnW = w
            
            twoButtonUpperSideOfCollectionView()
        }
        else if result.height == 896.000000 // 11 , 11 pro max
        {wWidth = 375
            let xAxis = 200 // x // ONLY FOR BLUE
            btnUpperTwoBtnX = xAxis
            
            let y = 446 // y
            btnUpperTwoBtnY = y
            
            let w = 220 //w
            btnUpperTwoBtnW = w
            
            twoButtonUpperSideOfCollectionView()
        }
        else
        {wWidth = 375}
    }

    @objc func twoButtonUpperSideOfCollectionView() {
        
        let btnSignUpper = UIButton(frame: CGRect(x: 0, y: btnUpperTwoBtnY, width: btnUpperTwoBtnW, height: btnUpperTwoBtnH))
        btnSignUpper.setTitle("Sign In", for: .normal)
        btnSignUpper.setTitleColor(.black, for: .normal)
        btnSignUpper.layer.cornerRadius = 4
        btnSignUpper.clipsToBounds = true
        btnSignUpper.backgroundColor = .clear
        btnSignUpper.addTarget(self, action: #selector(signInUpperClickMethod), for: .touchUpInside)
        
        
        let btnSignUpUpper = UIButton(frame: CGRect(x: btnUpperTwoBtnX, y: btnUpperTwoBtnY, width: btnUpperTwoBtnW, height: btnUpperTwoBtnH))
        btnSignUpUpper.setTitle("Sign Up", for: .normal)
        btnSignUpUpper.setTitleColor(.black, for: .normal)
        btnSignUpUpper.layer.cornerRadius = 4
        btnSignUpUpper.clipsToBounds = true
        btnSignUpUpper.backgroundColor = .clear
        btnSignUpUpper.addTarget(self, action: #selector(signUpUpperClickMethod), for: .touchUpInside)

        self.view.addSubview(btnSignUpper)
        self.view.addSubview(btnSignUpUpper)
        
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
    
    //MARK:- WEBSERVICE ( REGISTRATION )
    @objc func registrationWBClickMethod() {
            
        /*
        if CLLocationManager.locationServicesEnabled() {
                   
                   switch CLLocationManager.authorizationStatus() {
                       case .notDetermined, .restricted, .denied:
                           print("No access")
                    
                           self.mapSettingPopUp()
           
                       case .authorizedAlways, .authorizedWhenInUse:
                           print("Access")
                           
                       
                       locationManager.startUpdatingLocation()
                       
                       }
                   } else {
                       print("Location services are not enabled")
               }
        */
        
        
        
        }
    
    @objc func mapSettingPopUp() {
        let alert = UIAlertController(title: "Location Service", message: "Please enable your location to register",preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Settings",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        //Sign out action
                                        self.openSetingPageInIphone()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func openSetingPageInIphone() {
        
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)") // Prints true
            })
        }
    }
    
    
    // MARK:- LOGIN WEBSERVICE
    @objc func login() {
           
           
        let urlString = BASE_URL_SWIIPE
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        let defaults = UserDefaults.standard
        let userName = defaults.string(forKey: "KeyLoginPersonal")
        if userName == "loginViaPersonal" {
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            parameters = [
                "action"        : "login",
                //"email"         : "testbusiness1@gmail.com",
                 "email"         : "pandey@gmail.com",
                "password"      : "123456"
            ]
        }
        else
        {
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            parameters = [
                "action"        : "login",
                //"email"         : "testbusiness1@gmail.com",
                "email"         : "purnimaevs@gmail.com",
                "password"      : "123456"
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
                                
                                /*
                                 data =     {
                                         address = "";
                                         contactNumber = 3636365214;
                                         device = Android;
                                         deviceToken = "";
                                         email = "pandey@gmail.com";
                                         firebaseId = "";
                                         fullName = "purnima pandey";
                                         image = "http://demo2.evirtualservices.com/swiipe/site/img/uploads/users/15731267811573126777250.jpg";
                                         lastName = "";
                                         role = Member;
                                         socialId = "";
                                         socialType = "";
                                         userId = 38;
                                         wallet = 20;
                                         zipCode = "";
                                     };
                                     msg = "Data save successfully.";
                                     status = success;
                                 }
                                 */
                                   var dict: Dictionary<AnyHashable, Any>
                                   dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                                   
                                   let defaults = UserDefaults.standard
                                   defaults.setValue(dict, forKey: "keyLoginFullData")
                                   
                                 CRNotifications.showNotification(type: CRNotifications.success, title: "Message!", message:strSuccessAlert, dismissDelay: 1.5, completion:{})
                                
                                
                                var strSuccess2 : String!
                                strSuccess2 = dict["role"] as Any as? String
                                
                                // print(strSuccess2 as Any)
                                
                                if strSuccess2 == "Member" {
                                    self.personalClick()
                                }
                                else {
                                    self.loginWBClickMethod()
                                }
                                   
                               }
                               else
                               {
                                   self.indicator.stopAnimating()
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

extension GetStartedNow: UICollectionViewDelegate {
    //Write Delegate Code Here
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "getStartedNowCollectionCell", for: indexPath as IndexPath) as! GetStartedNowCollectionCell
        
        let strTitle = "Hello user, welcome back!"
        let strTitle2 = "Login in your account"
        
        let xAxis = 16
        
        if indexPath.row == 0 {
       
            // label one
            let label = UILabel(frame: CGRect(x: xAxis, y: 10, width: wWidth, height: 21))
            label.textAlignment = .center
            label.text = strTitle
            label.textColor = .black
            label.font = UIFont(name: "OpenSans-Bold", size: 18.0)
            cell.addSubview(label)
            
            // label two
            let label2 = UILabel(frame: CGRect(x: xAxis, y: 43, width: wWidth, height: 21))
            label2.textAlignment = .center
            label2.text = strTitle2
            label2.textColor = .black
            label2.font = UIFont(name: "Avenir-Bold", size: 14)
            cell.addSubview(label2)
            
            // text field email and image
 
            let textFieldEmail = UITextField(frame: CGRect(x: xAxis, y: 75, width: wWidth, height: 50))
            textFieldEmail.delegate = self
            textFieldEmail.placeholder = PLACEHOLDER_EMAIL
            
            //let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 2.0))
            //textFieldEmail.leftView = leftView
            
            let userIcon = UIImage(named: "businessUser")
            setPaddingWithImage(image: userIcon!, textField: textFieldEmail)
            
            textFieldEmail.backgroundColor = UIColor.init(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1)
            textFieldEmail.layer.cornerRadius = 4
            textFieldEmail.clipsToBounds = true
            textFieldEmail.layer.borderColor = UIColor.black.cgColor
            textFieldEmail.layer.borderWidth = 0.80
            textFieldEmail.leftViewMode = .always
            textFieldEmail.keyboardAppearance = .dark
            cell.addSubview(textFieldEmail)
            
            
            // text field password
            let textFieldPassword = UITextField(frame: CGRect(x: xAxis, y: 131 , width: wWidth, height: 50))
            textFieldPassword.delegate = self
            textFieldPassword.placeholder = PLACEHOLDER_PASSWORD
//            let leftView2 = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 50.0, height: 2.0))
//            textFieldPassword.leftView = leftView2
            
            let userIconForPassword = UIImage(named: "businessKey")
            setPaddingWithImage(image: userIconForPassword!, textField: textFieldPassword)
            
            textFieldPassword.backgroundColor = UIColor.init(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1)
            textFieldPassword.layer.cornerRadius = 4
            textFieldPassword.clipsToBounds = true
            textFieldPassword.layer.borderColor = UIColor.black.cgColor
            textFieldPassword.layer.borderWidth = 0.80
            textFieldPassword.keyboardAppearance = .dark
            
            cell.addSubview(textFieldPassword)
            
            
            // button sign in
            
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.layer.masksToBounds = true
            imageView.isUserInteractionEnabled = true
            
            let btnUser = UIButton(frame: CGRect(x: xAxis, y: 190, width: wWidth, height: 50))
            btnUser.setTitle("Sign In", for: .normal)
            
            btnUser.layer.cornerRadius = 4
            btnUser.clipsToBounds = true
            btnUser.backgroundColor = BUTTON_BACKGROUND_COLOR_BLUE
            // btnUser.addTarget(self, action: #selector(loginWBClickMethod), for: .touchUpInside)
            cell.addSubview(btnUser)
  
            // google and facebook
            let hGF = 50
            
            let btnGoogle = UIButton(frame: CGRect(x: xAxis, y: Int(btnUser.frame.origin.y+60), width: Int(cell.frame.size.width/2-16), height: hGF))
            
            let btnFacebook = UIButton(frame: CGRect(x: Int(btnGoogle.frame.size.width+30) , y: 250, width: Int(cell.frame.size.width/2-34), height: hGF))
            
            let btnForgotPassword = UIButton(frame: CGRect(x: xAxis , y: 310, width: Int(cell.frame.size.width-34), height: hGF))
            
            let image = UIImage(named: "businessGoogle") as UIImage?
            btnGoogle.setImage(image, for: .normal)
            btnGoogle.setTitleColor(.black, for: .normal)
            btnGoogle.layer.cornerRadius = 4
            btnGoogle.clipsToBounds = true
            btnGoogle.backgroundColor = UIColor.init(red: 228.0/255.0, green: 228.0/255.0, blue: 228.0/255.0, alpha: 1)
            
            let imageFB = UIImage(named: "businessFacebook") as UIImage?
            btnFacebook.setImage(imageFB, for: .normal)
            btnFacebook.setTitleColor(.black, for: .normal)
            btnFacebook.layer.cornerRadius = 4
            btnFacebook.clipsToBounds = true
            btnFacebook.backgroundColor = UIColor.init(red: 46.0/255.0, green: 68.0/255.0, blue: 135.0/255.0, alpha: 1)
            
            btnForgotPassword.setTitleColor(.black, for: .normal)
            btnForgotPassword.layer.cornerRadius = 4
            btnForgotPassword.clipsToBounds = true
            btnForgotPassword.setTitle("Forgot Password", for: .normal)
            btnForgotPassword.setTitleColor(BUTTON_BACKGROUND_COLOR_BLUE, for: .normal)
            btnForgotPassword.backgroundColor = .clear

            cell.addSubview(btnGoogle)
            cell.addSubview(btnFacebook)
            cell.addSubview(btnForgotPassword)
            
            
            
        }
        else
        {
            let signUpTextFeildH = 40
            let y = 10
            let addY = 48
            
            if indexPath.row == 1 {
            let textFieldName = UITextField(frame: CGRect(x: xAxis, y: y, width: wWidth, height: signUpTextFeildH))
            textFieldName.delegate = self
            textFieldName.placeholder = PLACEHOLDER_NAME
            //let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 2.0))
            //textFieldName.leftView = leftView
                
            let userIcon = UIImage(named: "businessUser")
            setPaddingWithImage(image: userIcon!, textField: textFieldName)
                
            textFieldName.backgroundColor = UIColor.init(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1)
            textFieldName.layer.cornerRadius = 4
            textFieldName.clipsToBounds = true
            textFieldName.layer.borderColor = UIColor.black.cgColor
            textFieldName.layer.borderWidth = 0.80
            textFieldName.leftViewMode = .always
            textFieldName.keyboardAppearance = .dark
                        
            cell.addSubview(textFieldName)
            
            
            
            // text field email
            let textFieldEmail = UITextField(frame: CGRect(x: xAxis, y: y+addY , width: wWidth, height: signUpTextFeildH))
            textFieldEmail.delegate = self
            textFieldEmail.placeholder = PLACEHOLDER_EMAIL
            
                let userIconEmail = UIImage(named: "businessEmail")
                setPaddingWithImage(image: userIconEmail!, textField: textFieldEmail)
                
            textFieldEmail.backgroundColor = UIColor.init(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1)
            textFieldEmail.layer.cornerRadius = 4
            textFieldEmail.clipsToBounds = true
            textFieldEmail.layer.borderColor = UIColor.black.cgColor
            textFieldEmail.layer.borderWidth = 0.80
            textFieldEmail.keyboardAppearance = .dark
                textFieldEmail.leftViewMode = .always
            
            cell.addSubview(textFieldEmail)
            
            
            
            
            // text field password
            let textFieldPassword = UITextField(frame: CGRect(x: xAxis, y: y+addY+addY , width: wWidth, height: signUpTextFeildH))
            textFieldPassword.delegate = self
            textFieldPassword.placeholder = PLACEHOLDER_PASSWORD
            
                let userIconPassword = UIImage(named: "businessKey")
                setPaddingWithImage(image: userIconPassword!, textField: textFieldPassword)
                
            textFieldPassword.backgroundColor = UIColor.init(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1)
            textFieldPassword.layer.cornerRadius = 4
            textFieldPassword.clipsToBounds = true
            textFieldPassword.layer.borderColor = UIColor.black.cgColor
            textFieldPassword.layer.borderWidth = 0.80
            textFieldPassword.keyboardAppearance = .dark
            textFieldPassword.leftViewMode = .always
                
            cell.addSubview(textFieldPassword)
            
            
            
            
            // text field phone
           let textFieldPhone = UITextField(frame: CGRect(x: xAxis, y: y+addY+addY+addY , width: wWidth, height: signUpTextFeildH))
            textFieldPhone.delegate = self
           textFieldPhone.placeholder = PLACEHOLDER_PHONE
           
                let userIconPhone = UIImage(named: "businessPhone")
                setPaddingWithImage(image: userIconPhone!, textField: textFieldPhone)
                
           textFieldPhone.backgroundColor = UIColor.init(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1)
           textFieldPhone.layer.cornerRadius = 4
           textFieldPhone.clipsToBounds = true
           textFieldPhone.layer.borderColor = UIColor.black.cgColor
           textFieldPhone.layer.borderWidth = 0.80
           textFieldPhone.keyboardAppearance = .dark
           textFieldPhone.leftViewMode = .always
        
           
           cell.addSubview(textFieldPhone)
            
            
            let btnSignUp = UIButton(frame: CGRect(x: xAxis, y: y+addY+addY+addY+addY , width: wWidth, height: 50))
            btnSignUp.setTitle("Sign Up", for: .normal)
            btnSignUp.setTitleColor(.black, for: .normal)
            btnSignUp.layer.cornerRadius = 4
            btnSignUp.clipsToBounds = true
                btnSignUp.setTitleColor(.white, for: .normal)
            btnSignUp.backgroundColor = BUTTON_BACKGROUND_COLOR_BLUE
            btnSignUp.addTarget(self, action: #selector(registrationWBClickMethod), for: .touchUpInside)
            cell.addSubview(btnSignUp)
            
            
            
            
            
            
        }
            
        }
        
        cell.backgroundColor = .white
        
        return cell
        
    }
    
    @objc func personalClick() {
        ERProgressHud.sharedInstance.hide()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
        self.view.window?.rootViewController = sw
        let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "PersonalDashbaordId")
        let navigationController = UINavigationController(rootViewController: destinationController!)
        sw.setFront(navigationController, animated: true)
        
    }
    @objc func loginWBClickMethod() {
        ERProgressHud.sharedInstance.hide()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
        self.view.window?.rootViewController = sw
        let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "BusinessDashbaordId")
        let navigationController = UINavigationController(rootViewController: destinationController!)
        sw.setFront(navigationController, animated: true)
        
        /*
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BusinessDashbaordId") as? BusinessDashbaord
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
            */
    }
    
    func setPaddingWithImage(image: UIImage, textField: UITextField){
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 50))
        imageView.frame = CGRect(x: 13.0, y: 13.0, width: 24.0, height: 24.0)
        //For Setting extra padding other than Icon.
        let seperatorView = UIView(frame: CGRect(x: 50, y: 0, width: 2, height: 50))
        seperatorView.backgroundColor = UIColor(red: 80/255, green: 89/255, blue: 94/255, alpha: 1)
        view.addSubview(seperatorView)
        textField.leftViewMode = .always
        view.addSubview(imageView)
        view.backgroundColor = .clear
        textField.leftViewMode = UITextField.ViewMode.always
        textField.leftView = view
    }
    
    //UICollectionViewDatasource methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2//arrListOfDashboardItems.count
    }
    
    /*
    // add image to textfield
    func withImage(direction: Direction, image: UIImage, colorSeparator: UIColor, colorBorder: UIColor){
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 45))
        mainView.layer.cornerRadius = 5

        let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 45))
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.layer.borderWidth = CGFloat(0.5)
        view.layer.borderColor = colorBorder.cgColor
        mainView.addSubview(view)

        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 12.0, y: 10.0, width: 24.0, height: 24.0)
        view.addSubview(imageView)

        let seperatorView = UIView()
        seperatorView.backgroundColor = colorSeparator
        mainView.addSubview(seperatorView)

        if(Direction.Left == direction){ // image left
            seperatorView.frame = CGRect(x: 45, y: 0, width: 5, height: 45)
            self.leftViewMode = .always
            self.leftView = mainView
        } else { // image right
            seperatorView.frame = CGRect(x: 0, y: 0, width: 5, height: 45)
            self.rightViewMode = .always
            self.rightView = mainView
        }

        self.layer.borderColor = colorBorder.cgColor
        self.layer.borderWidth = CGFloat(0.5)
        self.layer.cornerRadius = 5
    }
    */
    
    
}

extension GetStartedNow: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
    }
}

extension GetStartedNow: UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        var sizes: CGSize
                
        //let result = UIScreen.main.bounds.size
        //NSLog("%f",result.height)
        sizes = CGSize(width: self.view.frame.size.width, height: 400.0) // done

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
    }
    
}

    

