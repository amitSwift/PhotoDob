//
//  PrintingPageController.swift
//  PhotoDob
//
//  Created by Amit Verma  on 10/7/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit

class PrintingPageController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource{

    //MARK: outlets
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var lblSize: UILabel!
    @IBOutlet var pageControler: UIPageControl!
    
    
    @IBOutlet var btn20x30: UIButton!
    @IBOutlet var btn40x60: UIButton!
    @IBOutlet var btn70x80: UIButton!
    @IBOutlet var btn70x90: UIButton!
    
    
    @IBOutlet var infoView: UIView!
    @IBOutlet var customSizeView: UIView!
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Printing"
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        // Do any additional setup after loading the view, typically from a nib
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: screenWidth , height: screenWidth / 2)
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.register(PagecontrollerCell.self, forCellWithReuseIdentifier: pageCell)
        collectionView!.collectionViewLayout = layout
        
        
        if DeviceType.IS_IPHONE_6{
            collectionView.frame = CGRect(x: 0, y: 64, width: Int(self.view.frame.size.width), height: 278)
            pageControler.frame = CGRect(x: Int(self.view.frame.size.width)/2-20, y: 250, width: Int(pageControler.frame.size.width), height: Int(pageControler.frame.size.height))
            
        }
        else  if DeviceType.IS_IPHONE_6P{
            collectionView.frame = CGRect(x: 0, y: 64, width: Int(self.view.frame.size.width), height: 278)
            pageControler.frame = CGRect(x: Int(self.view.frame.size.width)/2-20, y: 290, width: Int(pageControler.frame.size.width), height: Int(pageControler.frame.size.height))
            
        }
        else  if DeviceType.IS_IPHONE_5{
            collectionView.frame = CGRect(x: 0, y: 64, width: Int(self.view.frame.size.width), height: 258)
            pageControler.frame = CGRect(x: Int(self.view.frame.size.width)/2-20, y: 190, width: Int(pageControler.frame.size.width), height: Int(pageControler.frame.size.height))
            
        }
        else  if DeviceType.IS_IPHONE_4_OR_LESS{
            collectionView.frame = CGRect(x: 0, y: 64, width: Int(self.view.frame.size.width), height: 258)
            pageControler.frame = CGRect(x: Int(self.view.frame.size.width)/2-20, y: 190, width: Int(pageControler.frame.size.width), height: Int(pageControler.frame.size.height))
            
        }
        
        
        collectionView.isPagingEnabled = true
        self.view.addSubview(collectionView!)
        
        
        
        //uork on page controller
        pageControler.numberOfPages = 4
        pageControler.currentPage = 0
        pageControler.center = self.view.center
        
        
        self.view.bringSubview(toFront: pageControler)
        
        //add navigation  button
        var image = UIImage(named: "back")
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(PrintingPageController.returntoView))
        
        
        //add right navigation  button
        var imageInfo = UIImage(named: "question-mark")
        imageInfo = imageInfo?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: imageInfo, style: UIBarButtonItemStyle.plain, target: self, action: #selector(PrintingPageController.showInfoView))
        
        self.showInfoView()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    func returntoView() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func showInfoView() {
        
        infoView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.addSubview(infoView)
    }
    
    @IBAction func sizeRadioBtnAction(_ sender: UIButton) {
        
        if sender.tag == 0 {
            if btn20x30.isSelected == true {
                btn20x30.isSelected = false
                btn40x60.isSelected = false
                btn70x80.isSelected = false
                btn70x90.isSelected = false
            }
            else{
                btn20x30.isSelected = true
                btn40x60.isSelected = false
                btn70x80.isSelected = false
                btn70x90.isSelected = false
            }
        }
        else if sender.tag == 1{
            if btn40x60.isSelected == true {
                btn40x60.isSelected = false
                btn20x30.isSelected = false
                btn70x80.isSelected = false
                btn70x90.isSelected = false
            }
            else{
                btn40x60.isSelected = true
                btn20x30.isSelected = false
                btn70x80.isSelected = false
                btn70x90.isSelected = false
            }
        }
        else if sender.tag == 2{
            if btn70x80.isSelected == true {
                btn70x80.isSelected = false
                btn20x30.isSelected = false
                btn40x60.isSelected = false
                btn70x90.isSelected = false
            }
            else{
                btn70x80.isSelected = true
                btn20x30.isSelected = false
                btn40x60.isSelected = false
                btn70x90.isSelected = false
            }
        }
        else if sender.tag == 3{
            if btn70x90.isSelected == true {
                btn70x90.isSelected = false
                btn20x30.isSelected = false
                btn40x60.isSelected = false
                btn70x80.isSelected = false
            }
            else{
                btn70x90.isSelected = true
                btn20x30.isSelected = false
                btn40x60.isSelected = false
                btn70x80.isSelected = false
            }
        }

    }
    
    
    
    
    

    @IBAction func custonSizeAction(_ sender: AnyObject) {
        
        customSizeView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.addSubview(customSizeView)
    }
    
    
    
    @IBAction func makeRollerAction(_ sender: AnyObject) {
        
        let printingAlbumVC = storyBoard.instantiateViewController(withIdentifier: "PrintingAlbumVC") as! PrintingAlbumVC
        self.navigationController?.pushViewController(printingAlbumVC, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let pCell = collectionView.dequeueReusableCell(withReuseIdentifier: pageCell, for: indexPath) as! PagecontrollerCell
        
        let imageName = "image"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 0, y: -54, width: Int(self.view.frame.size.width), height: 278)
        pCell.contentView.addSubview(imageView)
        
        
        
        return pCell
    }
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell: UICollectionViewCell in collectionView.visibleCells {
            let indexPath = collectionView.indexPath(for: cell)!
            print("\(indexPath)")
            pageControler.currentPage = indexPath.row
        }
    }
    
    @IBAction func selectAction(_ sender: AnyObject) {
        
        let albumVC = storyBoard.instantiateViewController(withIdentifier: "AlbumVC") as! AlbumVC
        self.navigationController?.pushViewController(albumVC, animated: true)
        
    }
    
    @IBAction func closeAction(_ sender: AnyObject) {
        
        infoView.removeFromSuperview()
        customSizeView.removeFromSuperview()
    }
    
    @IBAction func customSizeAction(_ sender: AnyObject) {
        
        infoView.removeFromSuperview()
        customSizeView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.addSubview(customSizeView)
        
        
    }
    @IBAction func doneAction(_ sender: AnyObject) {
        infoView.removeFromSuperview()
        customSizeView.removeFromSuperview()
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
