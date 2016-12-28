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
        self.title = "Products"
        
        
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
        
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Arial", size: 22)!, NSForegroundColorAttributeName: UIColor(red: 211/255, green: 89/255, blue: 135/255, alpha: 1.0)]
        
        
        
        //add navigation  button
        var image = UIImage(named: "back")
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(ProductVC.returntoView))
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Fetch value from PList
        plistValues = readPropertyList()
        
        imageArryFromPlist = plistValues["ImageArray"]as! NSMutableArray
        productName = plistValues["ProductName"]as! NSMutableArray
        
        print(imageArryFromPlist)
        print(productName)
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
        
        //used for give product value globly
        Header.appDelegate.ProductName = productName[indexPath.row] as! String;
        
      /*  if(UserDefaults.standard.value(forKey: "ProductName") != nil){
            
            if(Header.appDelegate.ProductName != UserDefaults.standard.value(forKey: "ProductName") as! String){
                
                let alert = UIAlertController(title: "Alert", message: "You want to change Product!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil));
                //event handler with closure
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
                    
                     UserDefaults.standard.removeObject(forKey: "ProductName")
                     UserDefaults.standard.removeObject(forKey: "SizeName")
                    
                    //need to work for remove saved value in database
                    
                    
                    if indexPath.row == 5{
                        
                        let pageControllerVC = storyBoard.instantiateViewController(withIdentifier: "PrintingPageController") as! PrintingPageController
                        self.navigationController?.pushViewController(pageControllerVC, animated: true)
                    }else{
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let selectSizeVC = storyBoard.instantiateViewController(withIdentifier: "SelectSizeVC") as! SelectSizeVC
                        selectSizeVC.selectASizeDic = plistValues[productName[0]] as! NSMutableDictionary
                        self.navigationController?.pushViewController(selectSizeVC, animated: true)
                    }
                    
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
                
            }
            else{
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

            
        }
        else{*/
            if indexPath.row == 5 {
                
                let pageControllerVC = storyBoard.instantiateViewController(withIdentifier: "PrintingPageController") as! PrintingPageController
                self.navigationController?.pushViewController(pageControllerVC, animated: true)
            }else{
                
                if indexPath.row == 3 || indexPath.row == 6 || indexPath.row == 7{
                    
                    let printingVC = storyBoard.instantiateViewController(withIdentifier: "PrintingVC") as! PrintingVC
                    if indexPath.row == 3 {
                        printingVC.productType = "tshirtPrintind"}
                    else  if indexPath.row == 6 {
                        printingVC.productType = "cusionsPrinted"}
                    else  if indexPath.row == 7 {
                        printingVC.productType = "toteBagPrinted"}
                    self.navigationController?.pushViewController(printingVC, animated: true)
                    
                }
                else{
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let selectSizeVC = storyBoard.instantiateViewController(withIdentifier: "SelectSizeVC") as! SelectSizeVC
                    selectSizeVC.selectASizeDic = plistValues[productName[0]] as! NSMutableDictionary
                    self.navigationController?.pushViewController(selectSizeVC, animated: true)
                }
                
               
            }
            
      //  }

        
        
        
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
