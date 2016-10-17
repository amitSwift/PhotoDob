//
//  PhotoCollectionViewDataSource.swift
//  PhotoDob
//
//  Created by Amit Verma  on 10/10/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit
import Photos


class PhotoCollectionViewDataSource: NSObject {
    
    
    var selections = [PHAsset]()
    var fetchResult: PHFetchResult<PHAsset>
    
    var imageSize: CGSize = CGSize.zero
    
    fileprivate let photoCellIdentifier = "photoCellIdentifier"
    fileprivate let photosManager = PHCachingImageManager.default()
    fileprivate let imageContentMode: PHImageContentMode = .aspectFill
    
    
    init(fetchResult: PHFetchResult<PHAsset>, selections: PHFetchResult<PHAsset>? = nil) {
        self.fetchResult = fetchResult
        if let selections = selections {
            var selectionsArray = [PHAsset]()
            selections.enumerateObjects({ (asset, idx, stop) in
                selectionsArray.append(asset)
            })
            
            self.selections = selectionsArray
        }
        
        super.init()
    }


}
