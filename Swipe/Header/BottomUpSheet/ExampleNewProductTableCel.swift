//
//  ExampleNewProductTableCel.swift
//  RiteVet
//
//  Created by evs_SSD on 12/27/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit

class ExampleNewProductTableCel: UITableViewCell {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblCardNumber:UILabel!
    
    @IBOutlet weak var img:UIImageView! {
        didSet {
            img.layer.cornerRadius = 30
            img.clipsToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
