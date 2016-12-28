//
//  PhotoBookCell.swift
//  PhotoDob
//
//  Created by Amit Verma  on 11/12/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit

class PhotoBookCell: UITableViewCell {

    //MARK: Outlet
    
    @IBOutlet var backImage: UIImageView!
    @IBOutlet var btnLeft: UIButton!
    @IBOutlet var btnRight: UIButton!
    
    @IBOutlet var leftImage: UIImageView!
    @IBOutlet var rightImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
