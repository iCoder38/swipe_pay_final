//
//  StartNew.swift
//  Swipe
//
//  Created by evs_SSD on 1/28/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit

class StartNew: UIViewController {

    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BUSINESS_BACKGROUND_COLOR
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "CREATE ACCOUNT"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            // btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var imgBusinessImage:UIImageView!
    @IBOutlet weak var imgpersonalImage:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
           imgBusinessImage.isUserInteractionEnabled = true
           imgBusinessImage.addGestureRecognizer(tapGestureRecognizer)
        
        
        let tapGestureRecognizerPersonal = UITapGestureRecognizer(target: self, action: #selector(imageTapped2(tapGestureRecognizerPersonal:)))
        imgpersonalImage.isUserInteractionEnabled = true
        imgpersonalImage.addGestureRecognizer(tapGestureRecognizerPersonal)
        
        
        // print(type(of: String(format: "%.2f", myDouble)))
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        UserDefaults.standard.set("", forKey: "KeyLoginPersonal")
        UserDefaults.standard.set(nil, forKey: "KeyLoginPersonal")
        
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "GetStartedNowNewId") as? GetStartedNowNew
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
    }
    @objc func imageTapped2(tapGestureRecognizerPersonal: UITapGestureRecognizer) {
        UserDefaults.standard.set("loginViaPersonal", forKey: "KeyLoginPersonal")
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "GetStartedNowNewId") as? GetStartedNowNew
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
    }
    

}
