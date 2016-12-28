//
//  Cart2Cell.swift
//  PhotoDob
//
//  Created by Amit Verma  on 10/6/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit

class Cart2Cell: UITableViewCell {

    
    @IBOutlet var imgProduct: UIImageView!
    @IBOutlet var lblSizeName: UILabel!
    @IBOutlet var lblQuantity: UILabel!
    @IBOutlet var lblQty: UILabel!
    @IBOutlet var lblPrise: UILabel!
    
    
    @IBOutlet var btnPlus: UIButton!
    @IBOutlet var btnMinus: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
