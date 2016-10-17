//
//  ProductVC.swift
//  PhotoDob
//
//  Created by Khushboo on 9/24/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit

var plistValues = NSDictionary()
var imageArryFromPlist = NSMutableArray()
var productName = NSMutableArray()

let parallaxCellIdentifier = "parallaxCell"

class ProductVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = false
        self.title = "Product"
        
        
        
        //Fetch value from PList
        plistValues = readPropertyList()
       
        imageArryFromPlist = plistValues["ImageArray"]as! NSMutableArray
        productName = plistValues["ProductName"]as! NSMutableArray
    
        print(imageArryFromPlist)
        print(productName)
        
        //add navigation  button
        var image = UIImage(named: "back")
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(ProductVC.returntoView))
        

        // Do any additional setup after loading the view.
    }
    
    func returntoView() {
        _ = navigationController?.popViewController(animated: true)
    }

    //fetch value from plist by method
    func readPropertyList() ->NSDictionary{
        var propertyListForamt =  PropertyListSerialization.PropertyListFormat.xml //Format of the Property List.
        var plistData: [String: AnyObject] = [:] //Our data
        let plistPath: String? = Bundle.main.path(forResource: "ImageList", ofType: "plist")! //the path of the data
        let plistXML = FileManager.default.contents(atPath: plistPath!)!
        do {//convert the data to a dictionary and handle errors.
            plistData = try PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &propertyListForamt) as! [String:AnyObject]
            return plistData as NSDictionary;
            
        } catch {
            print("Error reading plist: \(error), format: \(propertyListForamt)")
            return error as! NSDictionary
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return imageArryFromPlist.count
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let parallaxCell = collectionView.dequeueReusableCell(withReuseIdentifier: parallaxCellIdentifier, for: indexPath) as! ParallaxCollectionViewCell
        let imageName = imageArryFromPlist[indexPath.row] as! String
        parallaxCell.image = UIImage(named: imageName)!
       
        parallaxCell.cellButton.setTitle(productName[indexPath.row] as? String, for: UIControlState.normal)
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
        
        if indexPath.row == 5{
            let pageControllerVC = storyBoard.instantiateViewController(withIdentifier: "PrintingPageController") as! PrintingPageController
            self.navigationController?.pushViewController(pageControllerVC, animated: true)
        }else{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let selectSizeVC = storyBoard.instantiateViewController(withIdentifier: "SelectSizeVC") as! SelectSizeVC
            selectSizeVC.selectASizeDic = plistValues[productName[0]] as! NSMutableDictionary
            self.navigationController?.pushViewController(selectSizeVC, animated: true)
        }
            
        
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
