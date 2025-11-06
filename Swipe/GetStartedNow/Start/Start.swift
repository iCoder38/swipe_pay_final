//
//  Start.swift
//  Swipe
//
//  Created by Apple  on 25/10/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit

class Start: UIViewController {

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
    
    @IBOutlet weak var clView: UICollectionView!
        {
        didSet
        {
            //collection
            clView!.dataSource = self
            clView!.delegate = self
            clView!.backgroundColor = .white
            clView.isPagingEnabled = true
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.backgroundColor = .black
        
        
        // TEMPORARY
        let defaults = UserDefaults.standard
        defaults.setValue("", forKey: "keyLoginFullData")
        defaults.setValue(nil, forKey: "keyLoginFullData")
        
        defaults.setValue("", forKey: "KeyLoginPersonal")
        defaults.setValue(nil, forKey: "KeyLoginPersonal")
        
        
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            print(countryCode)
        }
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension Start: UICollectionViewDelegate {
    //Write Delegate Code Here
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "startCollectionCell", for: indexPath as IndexPath) as! StartCollectionCell
        
        
        
        
        if indexPath.row == 0 {
            cell.imgProfile.image = UIImage(named:"business")
        }
        else
        if indexPath.row == 1 {
            cell.imgProfile.image = UIImage(named:"personal")
        }
        
        cell.backgroundColor = .clear
        
        return cell
        
        
        
        
        
    }
    
    //UICollectionViewDatasource methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2//arrListOfDashboardItems.count
    }
}

extension Start: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if indexPath.row == 0 {
            pushToBusinessProfile()
        }
        else
        if indexPath.row == 1 {
            pushToPersonalProfile()
        }
    }
    
    @objc func pushToBusinessProfile() {
        
        UserDefaults.standard.set("", forKey: "KeyLoginPersonal")
        UserDefaults.standard.set(nil, forKey: "KeyLoginPersonal")
        
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "GetStartedNowNewId") as? GetStartedNowNew
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
        /*
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "GetStartedNowId") as? GetStartedNow
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
 */
    }
    @objc func pushToPersonalProfile() {
        
        UserDefaults.standard.set("loginViaPersonal", forKey: "KeyLoginPersonal")
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "GetStartedNowNewId") as? GetStartedNowNew
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
        
        /*
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "GetStartedNowId") as? GetStartedNow
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
         */
        
    }
    
    
}

extension Start: UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        var sizes: CGSize
                
        let result = UIScreen.main.bounds.size
        //NSLog("%f",result.height)

        if result.height == 480
        {
            sizes = CGSize(width: self.view.frame.size.width, height: 350)
        }
        else if result.height == 568
        {
            sizes = CGSize(width: self.view.frame.size.width, height: 350)
        }
        else if result.height == 667.000000 // 8
        {
            sizes = CGSize(width: self.view.frame.size.width, height: 300)
        }
        else if result.height == 736.000000 // 8 plus
        {
            sizes = CGSize(width: self.view.frame.size.width, height: 340)
        }
        else if result.height == 812.000000 // 11 pro
        {
            sizes = CGSize(width: self.view.frame.size.width, height: 350)
        }
        else if result.height == 896.000000 // 11 , 11 pro max
        {
            sizes = CGSize(width: self.view.frame.size.width, height: 380)
        }
        else
        {
            sizes = CGSize(width: self.view.frame.size.width, height: 350)
        }
        
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
