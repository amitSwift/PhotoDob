//
//  AlbumCell.swift
//  PhotoDob
//
//  Created by Amit Verma  on 10/6/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit

class AlbumCell: UITableViewCell {

    
    @IBOutlet var lblAlbumName: UILabel!
    @IBOutlet var imageAlbum: UIImageView!
    
    @IBOutlet var lblCountImage: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
