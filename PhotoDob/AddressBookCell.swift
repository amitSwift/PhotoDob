//
//  AddressBookCell.swift
//  PhotoDob
//
//  Created by Amit Verma  on 11/10/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit

class AddressBookCell: UITableViewCell {

    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblAddress1: UILabel!
    @IBOutlet var lblAddress2: UILabel!
    @IBOutlet var lblState: UILabel!
    @IBOutlet var lblCountry: UILabel!
    @IBOutlet var btnEdit: UIButton!
    
    
    
    
    @IBOutlet var selectEditBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnSlectkAction(_ sender: UIButton) {
        
        
        if selectEditBtn.isSelected == true {
            selectEditBtn.isSelected = false
            
        }
        else{
            selectEditBtn.isSelected = true
            
        }
    }


}
