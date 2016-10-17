//
//  SelectSizeVC.swift
//  PhotoDob
//
//  Created by Khushboo on 9/26/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit


class SelectSizeVC: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource{

    
    var selectASizeDic = NSMutableDictionary()
    var productImage = NSMutableArray()
    var sizeName = NSMutableArray()

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Select A Size"
        print(selectASizeDic)
        productImage = (selectASizeDic["SlectASize"]as! NSMutableDictionary)["imagesForSelectASize"]as! NSMutableArray
        sizeName = (selectASizeDic["SlectASize"]as! NSMutableDictionary)["sizeName"]as! NSMutableArray
        
        
        //add left navigation  button
        var image = UIImage(named: "back")
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(SelectSizeVC.returntoView))
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func returntoView() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return productImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let parallaxCell = collectionView.dequeueReusableCell(withReuseIdentifier: parallaxCellIdentifier, for: indexPath) as! ParallaxCollectionViewCell
        
        parallaxCell.image = UIImage(named: productImage[indexPath.row] as! String)!
        parallaxCell.cellButton.setTitle(sizeName[indexPath.row] as? String, for: UIControlState.normal)

        parallaxCell.frame = CGRect(x: 5, y: 170*indexPath.row+5, width: Int(self.view.frame.size.width-10), height: 170-5)
        
        
        return parallaxCell
    }
    //used
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        guard let collectionView = self.collectionView else {return}
        guard let visibleCells = collectionView.visibleCells as? [ParallaxCollectionViewCell] else {return}
        for parallaxCell in visibleCells {
            let yOffset = ((collectionView.contentOffset.y - parallaxCell.frame.origin.y) / ImageHeight) * OffsetSpeed
            parallaxCell.offset(CGPoint(x: 0.0, y: yOffset))
            
        }
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        let pageControllerVC = storyBoard.instantiateViewController(withIdentifier: "PageControllerVC") as! PageControllerVC
        self.navigationController?.pushViewController(pageControllerVC, animated: true)
        
      
    }
    
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
