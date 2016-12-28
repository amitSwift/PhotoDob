//
//  PrintingAlbumVC.swift
//  PhotoDob
//
//  Created by Amit Verma  on 10/7/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit

class PrintingAlbumVC: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,WebServiceDelegate{
    
     //MARK:Outlets
    
    @IBOutlet var collectionView: UICollectionView!
    
    //MARK: Varialbes
    
    
    var imageArr = NSArray()
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Select A Image"
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
        
        
        
        AppManager.sharedManager.delegate=self
        AppManager.sharedManager.activateView(self.view, loaderText: "Loading")
        let params: [String: AnyObject] = [:]
        
        AppManager.sharedManager.postDataOnserver(params: params as AnyObject, postUrl: Header.KGetFotoliaImages as NSString)
        
        
        
        //add navigation  button
        var image = UIImage(named: "back")
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(PrintingAlbumVC.returntoView))
        
        
        //add right navigation  button
      /*  var imageInfo = UIImage(named: "tick")
        imageInfo = imageInfo?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: imageInfo, style: UIBarButtonItemStyle.plain, target: self, action: #selector(PrintingAlbumVC.clickOnTick))*/
        
        
   
        
    }
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    func returntoView() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cameraAction(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Alert", message: "Under process!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }


    
    @IBAction func fotoliaAction(_ sender: AnyObject) {
      /*  let alert = UIAlertController(title: "Alert", message: "Under process!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil) */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:webservice delegate
    
    func serverReponse(responseDict: NSDictionary,serviceurl:NSString)
    {
        AppManager.sharedManager.inActivateView(self.view)
        if serviceurl as String == Header.KGetFotoliaImages {
            
            print(responseDict.value(forKey: "images") as! NSArray)
            let result=responseDict.value(forKey: "result")as! Bool
            
            
            if result == true{
                
                imageArr = responseDict.value(forKey: "images")as! NSArray
                collectionView.reloadData()
            }
            else{
                let alert = UIAlertController(title: "Alert", message: responseDict.value(forKey: "error")as? String, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                UserDefaults.standard.set(false, forKey: "isLogedIn")
            }
            
            
            
        }
        
        
    }
    
    func failureRsponseError(failureError:NSError)
    {
        AppManager.sharedManager.inActivateView(self.view)
        let alert = UIAlertController(title: "Error!", message: "Something went wrong!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return 5
        return imageArr.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //UIView.setAnimationsEnabled(false)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.accessibilityIdentifier = "photo_cell_\(indexPath.item)"
        
        
        
        //cell.backgroundColor = UIColor.red
        cell.frame.size.width = screenWidth / 3
        cell.frame.size.height = screenWidth / 3
        cell.btnCheck.tag = indexPath.row
        
        //cell.activitiView.stopAnimating()
        cell.activitiView.startAnimating()
        
        if UserDefaults.standard.value(forKey: "savedImageUrlString") != nil{
            if ((self.imageArr[indexPath.row] as! NSDictionary).value(forKey: "src") as! String) == UserDefaults.standard.value(forKey: "savedImageUrlString")as! String{
                cell.btnCheck.isSelected = true
            }
            else{
                cell.btnCheck.isSelected = false
            }
        }
        
        
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
            
            //cell.activitiView.startAnimating()
            
            //cell.imageView.hnk_setImage(from: URL(string: (self.imageArr[indexPath.row] as AnyObject).value(forKey: "src") as! String))
            
            DispatchQueue.main.async {
                print("This is run on the main queue, after the previous code in outer block")
                // cell.activitiView.stopAnimating()
                cell.imageView.hnk_setImage(from: URL(string: (self.imageArr[indexPath.row] as AnyObject).value(forKey: "src") as! String))
            }
        }
        
        
        
        
        
        
        
        
        
        
        //cell.imageView.imageURL = URL(string: "https://s.ftcdn.net/r/v2010/d42a432d185126c9a3c3b30a18254fae3e6cb7d1/pics/all/fader/65423201-1000-391-rounded.jpg")
        
        
        
        UIView.setAnimationsEnabled(true)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let cell = collectionView.cellForItem(at: indexPath)as! PhotoCell
        cell.btnCheck.isSelected = true
        
        UserDefaults.standard.set((self.imageArr[indexPath.row] as! NSDictionary).value(forKey: "src") as! String, forKey: "savedImageUrlString")
        
        UserDefaults.standard.setValue(Header.appDelegate.ProductName, forKey: "ProductName")
        UserDefaults.standard.setValue(Header.appDelegate.SizeName, forKey: "SizeName")
        
        
        let fotolia = storyBoard.instantiateViewController(withIdentifier: "ConfirmRollerBlind")as! ConfirmRollerBlind
        fotolia.imageUrl =  (self.imageArr[indexPath.row] as! NSDictionary).value(forKey: "src") as! String
        self.navigationController?.pushViewController(fotolia, animated: true)
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
    {
        
        
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
