//
//  Help.swift
//  Swipe
//
//  Created by evs_SSD on 1/16/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit
import MessageUI

class Help: UIViewController,MFMailComposeViewControllerDelegate {

    @IBOutlet weak var imgLogo:UIImageView! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "HELP"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var btnBack:UIButton!
    
    @IBOutlet weak var btnCall:UIButton! {
        didSet {
            btnCall.setTitleColor(.white, for: .normal)
            btnCall.setTitle("206-591-8818", for: .normal)
            btnCall.addTarget(self, action: #selector(callMethodClick), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var btnMail:UIButton! {
        didSet {
            btnMail.setTitleColor(BUTTON_BACKGROUND_COLOR_YELLOW, for: .normal)
            btnMail.addTarget(self, action: #selector(mailMethodClick), for: .touchUpInside)
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
            
            self.imgLogo.image = UIImage(named: "new_personal_logo")
            navigationBar.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
             self.view.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
        }
        else {
            self.imgLogo.image = UIImage(named: "logo")
            
            navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
            self.view.backgroundColor = BUTTON_BACKGROUND_COLOR_BLUE
        }
        
     // self.gerServerFullData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let defaults = UserDefaults.standard
        if let name = defaults.string(forKey: "keySideBarMenu") {
            // print(name)
            if name == "dSideBar" {
                btnBack.setImage(UIImage(named: "menuWhite"), for: .normal)
                sideBarMenuClick()
            }
            else {
                btnBack.setImage(UIImage(named: "backs"), for: .normal)
                btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
            }
        }
        else {
            btnBack.setImage(UIImage(named: "backs"), for: .normal)
            btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
        
        // sideBarMenuClick()
    }

    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
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
            let url: NSURL = URL(string: "tel://2065918818")! as NSURL
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
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
    
            mailComposerVC.setToRecipients(["support@swiipepay.com"])
            mailComposerVC.setSubject("")
            mailComposerVC.setMessageBody("", isHTML: false)
    
            return mailComposerVC
        }
    
        func showSendMailErrorAlert() {
            let alert = UIAlertController(title: "Could Not Send Email", message: "You can always access your content by signing back in",         preferredStyle: UIAlertController.Style.alert)

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
