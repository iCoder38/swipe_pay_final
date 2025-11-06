//
//  total_users_list.swift
//  Swipe
//
//  Created by Apple on 04/05/22.
//  Copyright © 2022 Apple . All rights reserved.
//

import UIKit
import Alamofire
import CRNotifications
import SDWebImage

class total_users_list: UIViewController {
    
    var arr_list_of_all_users:NSMutableArray! = []
    
    var page : Int! = 1
    var loadMore : Int! = 1;
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_PERSONAL_BACKGROUND_COLOR
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "USERS"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.tintColor = .white
            btnBack.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        }
    }
    
    @IBOutlet weak var btnAdd:UIButton!
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            self.tbleView.delegate = self
            self.tbleView.dataSource = self
            self.tbleView.backgroundColor = .white
            self.tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        self.total_users_list(pageNumber: 1)
    }
    
    @objc func back_click_method() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
                
        if scrollView == self.tbleView {
            let isReachingEnd = scrollView.contentOffset.y >= 0
                && scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)
            if(isReachingEnd) {
                if(loadMore == 1) {
                    loadMore = 0
                    page += 1
                    print(page as Any)
                    
                    
                        self.total_users_list(pageNumber: page)
                    
                    
                }
            }
        }
    }
    
    @objc func total_users_list(pageNumber:Int) {
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let urlString = BASE_URL_SWIIPE
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            parameters = [
                "action"    : "userlist",
                "userId"    : String(myString),
                "pageNo"    : pageNumber,
            ]
        }
        
        print("parameters-------\(String(describing: parameters))")
        
        Alamofire.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON {
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
                    
                    if strSuccess == "success" {
                        
                        var ar : NSArray!
                        ar = (JSON["data"] as! Array<Any>) as NSArray
                        self.arr_list_of_all_users.addObjects(from: ar as! [Any])
                        
                        self.tbleView.delegate = self
                        self.tbleView.dataSource = self
                        
                        self.tbleView.reloadData()
                        self.loadMore = 1
                        
                        ERProgressHud.sharedInstance.hide()
                        
                    } else {
                        
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


extension total_users_list: UITableViewDataSource , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_list_of_all_users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:total_users_list_table_cell = tableView.dequeueReusableCell(withIdentifier: "total_users_list_table_cell") as! total_users_list_table_cell
        
        cell.backgroundColor = .white
        
        let item = self.arr_list_of_all_users[indexPath.row] as? [String:Any]
        // print(item as Any)
        cell.lbl_user_name.text = (item!["userName"] as! String)
        cell.lbl_phone_number.text = (item!["contactNumber"] as! String)
        
        cell.img_profile_picture.sd_setImage(with: URL(string: (item!["userImage"] as! String)), placeholderImage: UIImage(named: "avatar"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let defaults = UserDefaults.standard
        let item = self.arr_list_of_all_users[indexPath.row] as? [String:Any]
        defaults.set(item, forKey: "key_save_total_users")
        
        self.back_click_method()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
        
    }
}


class total_users_list_table_cell: UITableViewCell {
    
    @IBOutlet weak var img_profile_picture:UIImageView!
    @IBOutlet weak var lbl_user_name:UILabel!
    @IBOutlet weak var lbl_phone_number:UILabel!
    
}
