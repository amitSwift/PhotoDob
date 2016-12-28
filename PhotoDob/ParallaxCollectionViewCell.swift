//
//  ParallaxCollectionViewCell.swift
//  MBParallaxScrollView
//
//  Created by Michael Babiy on 7/9/14.
//  Copyright (c) 2014 Michael Babiy. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

let ImageHeight: CGFloat = 230.0
let OffsetSpeed: CGFloat = 25.0

class ParallaxCollectionViewCell: UICollectionViewCell
{
    // AspectFill; 200 points.
    
    @IBOutlet weak var cellButton: UIButton!
    
    @IBOutlet weak var imageView1: UIImageView!
    var image: UIImage = UIImage() {
        didSet {
            imageView1.image = image
        }
    }
    
   /* override var bounds: CGRect {
        didSet {
            super.bounds = bounds
            contentView.frame = bounds
            contentView.frame = CGRect(origin: CGPoint(x:0,y :0), size: CGSize(width: 400, height: 160))
        }
    }*/
    
    
    
    
    func offset(_ offset: CGPoint)
    {
        imageView1.frame = self.imageView1.bounds.offsetBy(dx: offset.x, dy: offset.y)
    }
}
