//
//  PhotoCell.swift
//  PhotoDob
//
//  Created by Amit Verma  on 10/10/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit
import Photos

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet var btnCheck: UIButton!
    @IBOutlet var imageView: UIImageView!
    
     var asset: PHAsset?
    
    @IBAction func btnCheckAction(_ sender: UIButton) {
        
        
        if btnCheck.isSelected == true {
            btnCheck.isSelected = false
            
        }
        else{
            btnCheck.isSelected = true

        }
    }
    
    
}
