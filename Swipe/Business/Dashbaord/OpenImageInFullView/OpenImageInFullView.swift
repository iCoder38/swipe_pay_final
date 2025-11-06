//
//  OpenImageInFullView.swift
//  Swipe
//
//  Created by evs_SSD on 1/10/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit

class OpenImageInFullView: UIViewController {

    @IBOutlet weak var btnDismiss:UIButton!
    @IBOutlet weak var img:UIImageView!
    
    var imgString:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnDismiss.addTarget(self, action: #selector(dismissPresentViewwController), for: .touchUpInside)
        
        print(imgString as Any)
        
        if imgString == "" {
            print("oops")
        }
        else
        if imgString == nil {
            print("oops")
        }
        else
        {
        
        // image
        img.sd_setImage(with: URL(string: imgString), placeholderImage: UIImage(named: "plainBack")) // my profile image
        }
    }
    @objc func dismissPresentViewwController() {
        self.dismiss(animated: true, completion: nil)
    }
}
