//
//  FrameCell.swift
//  PhotoDob
//
//  Created by Amit Verma  on 10/3/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit

class FrameCell: UITableViewCell {

    @IBOutlet var backImage: UIImageView!
    @IBOutlet var tapPhotoToCrop: UIButton!
    
    @IBOutlet var btnUp: UIButton!
    @IBOutlet var btnDown: UIButton!
    @IBOutlet var lblQuantity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
