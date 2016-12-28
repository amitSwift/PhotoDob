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
    var sizeDic = NSMutableDictionary()

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Select a Size"
        print(selectASizeDic)
        productImage = (selectASizeDic["SlectASize"]as! NSMutableDictionary)["imagesForSelectASize"]as! NSMutableArray
        sizeName = (selectASizeDic["SlectASize"]as! NSMutableDictionary)["sizeName"]as! NSMutableArray
        sizeDic = (selectASizeDic["SlectASize"]as! NSMutableDictionary)["ActualSizeRatio"]as! NSMutableDictionary
        
        print(sizeDic)
        //add left navigation  button
        var image = UIImage(named: "back")
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(SelectSizeVC.returntoView))
        
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        if DeviceType.IS_IPHONE_6P{
            layout.itemSize = CGSize(width: self.view.frame.size.width, height: 200)
        }
        else  if DeviceType.IS_IPHONE_6{
            layout.itemSize = CGSize(width: self.view.frame.size.width, height: 200)
        }
        else  if DeviceType.IS_IPHONE_5{
            layout.itemSize = CGSize(width: self.view.frame.size.width, height: 170)
        }
        else  if DeviceType.IS_IPHONE_4_OR_LESS{
            layout.itemSize = CGSize(width: self.view.frame.size.width, height: 170)
        }
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
        
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

        if DeviceType.IS_IPHONE_6P{
            parallaxCell.frame = CGRect(x: 5, y: 200*indexPath.row+5, width: Int(self.view.frame.size.width-10), height: 200-5)
            
        }
        else  if DeviceType.IS_IPHONE_6{
            parallaxCell.frame = CGRect(x: 5, y: 200*indexPath.row+5, width: Int(self.view.frame.size.width-10), height: 200-5)
            
        }
        else  if DeviceType.IS_IPHONE_5{
            parallaxCell.frame = CGRect(x: 5, y: 170*indexPath.row+5, width: Int(self.view.frame.size.width-10), height: 170-5)
            
        }
        else  if DeviceType.IS_IPHONE_4_OR_LESS{
            parallaxCell.frame = CGRect(x: 5, y: 170*indexPath.row+5, width: Int(self.view.frame.size.width-10), height: 170-5)
            
        }

        
        
        return parallaxCell
    }
    //used
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        guard let collectionView = self.collectionView else {return}
        guard let visibleCells = collectionView.visibleCells as? [ParallaxCollectionViewCell] else {return}
        for parallaxCell in visibleCells {
            if DeviceType.IS_IPHONE_6P{
                let yOffset = ((collectionView.contentOffset.y - parallaxCell.frame.origin.y) / ImageHeight) * OffsetSpeed
                parallaxCell.offset(CGPoint(x: 0.0, y: yOffset))
            }
            else  if DeviceType.IS_IPHONE_6{
                let yOffset = ((collectionView.contentOffset.y - parallaxCell.frame.origin.y) / ImageHeight) * OffsetSpeed
                parallaxCell.offset(CGPoint(x: 0.0, y: yOffset))
            }
            else  if DeviceType.IS_IPHONE_5{
                let yOffset = ((collectionView.contentOffset.y - parallaxCell.frame.origin.y) / 200) * OffsetSpeed
                parallaxCell.offset(CGPoint(x: 0.0, y: yOffset))
            }
            else  if DeviceType.IS_IPHONE_4_OR_LESS{
                let yOffset = ((collectionView.contentOffset.y - parallaxCell.frame.origin.y) / 200) * OffsetSpeed
                parallaxCell.offset(CGPoint(x: 0.0, y: yOffset))
            }

            
        }
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        //give size of product globly
         Header.appDelegate.SizeName = sizeName[indexPath.row] as! String;
       
        
        
       /* if(UserDefaults.standard.value(forKey: "SizeName") != nil){
            
            if(Header.appDelegate.SizeName != UserDefaults.standard.value(forKey: "SizeName") as! String){
                
                let alert = UIAlertController(title: "Alert", message: "You currently have \(UserDefaults.standard.value(forKey: "SizeName") as! String) selected.Are you sure want to change to \(Header.appDelegate.SizeName) Prints?", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil));
                //event handler with closure
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
                    
                    
                    
                    //need to work for remove saved value in database
                    let arr = DBManager.sharedManager.fetchImagesBySizeFromDB(UserDefaults.standard.value(forKey: "SizeName") as! String)//remove value from database by size when changed size
                    print(arr)
                    DBManager.sharedManager.deleteRecordsFromDB(arr)
                    
                    UserDefaults.standard.removeObject(forKey: "SizeName")
                    
                    
                    let pageControllerVC = storyBoard.instantiateViewController(withIdentifier: "PageControllerVC") as! PageControllerVC
                    self.navigationController?.pushViewController(pageControllerVC, animated: true)
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
                
            }
            else{
                let pageControllerVC = storyBoard.instantiateViewController(withIdentifier: "PageControllerVC") as! PageControllerVC
                self.navigationController?.pushViewController(pageControllerVC, animated: true)
            
        }
       
        }
      
    
        else{
         */
            let pageControllerVC = storyBoard.instantiateViewController(withIdentifier: "PageControllerVC") as! PageControllerVC
            pageControllerVC.imageWidth = (sizeDic.value(forKey: (sizeName[indexPath.row] as? String)!) as! NSDictionary).value(forKey: "width") as! String
            pageControllerVC.imageHeight = (sizeDic.value(forKey: (sizeName[indexPath.row] as? String)!) as! NSDictionary).value(forKey: "height") as! String
            self.navigationController?.pushViewController(pageControllerVC, animated: true)
       // }
    
    
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
