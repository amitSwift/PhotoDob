//
//  DBManager.swift
//  PhotoDob
//
//  Created by Amit Verma  on 10/27/16.
//  Copyright © 2016 Amit. All rights reserved.
//

import UIKit
import CoreData

class DBManager: NSObject {
    
    var people = [NSManagedObject]()
    
    private struct Constants {
        static let sharedManager = DBManager()
    }
    public class var sharedManager: DBManager {
        return Constants.sharedManager
    }
    let managedContext = Header.appDelegate.managedObjectContext
    
    
    //MARK:Core Data Work
    
    
    
    //MARK: get Array from database
    
    func getSavedArrayFromDataBase( comletionHandler: @escaping (_ result: [NSManagedObject]) -> Void, andFalure failure: @escaping (_ falure: Int) -> Void) {
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        //2
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AlbumTable")
        //3
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            comletionHandler(results as! [NSManagedObject])
            
        } catch let error as NSError {
            failure (0)
            
        }

        
    }
    
    //MARK: get Array from database
    func getSavedArrayOfCartFromDataBase( comletionHandler: @escaping (_ result: [NSManagedObject]) -> Void, andFalure failure: @escaping (_ falure: Int) -> Void) {
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        //2
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartTable")
        //3
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            comletionHandler(results as! [NSManagedObject])
            
        } catch let error as NSError {
            failure (0)
            
        }
        
        
    }
    
//    func hnk_setImage(from url: URL, placeholder: UIImage, success successBlock: @escaping (_ image: UIImage) -> Void, failure failureBlock: @escaping (_ error: Error) -> Void) {
//    }

    
    
    
    
    //MARK:Core Data Get Saved Value
    func getSavedDatabaseValue(_ entityname:String, andCompletionHandler comletionHandler: @escaping (_ result: [NSManagedObject]) -> Void, andFalure failure: @escaping (_ falure: NSError) -> Void)
    {
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        //2
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityname)
        //3
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            people = results as! [NSManagedObject]
            
            print(people)
            comletionHandler(people)
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            failure(error)
        }
        
        
        
        
    }
    
    
    
    public func saveProductValue(productName:String,productSize:String,productStatus:String,imagesArray:NSMutableArray){
        
        //1
        
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        let entity =  NSEntityDescription.entity(forEntityName: "Product",
                                                 in:managedContext)
        let product = NSManagedObject(entity: entity!,
                                      insertInto: managedContext)
        
        //2
        
        //3
        
        product.setValue(productName, forKey: "productName")
        product.setValue(productSize, forKey: "sizeOfProduct")
        product.setValue(productStatus, forKey: "status")
        product.setValue(imagesArray, forKey: "productImages")
        
        
        
        //4
        do {
            try managedContext.save()
            print("save")
            //self.delegate?.saveToCoreDataResponse(responseStatus: true)
            //5
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
            //self.delegate?.failToSaveToCoreDataResponse(Error:error)
        }
        
    }
    //MARK:block method
    func getResponce(_ number1: Int, withNumber number2: Int, andCompletionHandler comletionHandler: @escaping (_ result: Int) -> Void, andFalure failure: @escaping (_ falure: Int) -> Void) {
        
        let result = number1 - number2
        if result > 0 {
            comletionHandler(result)
        }
        else {
            failure(0)
        }
    }
    
    
    

    //MARK:Core Data Work save product
    func saveProductValueInDataBase(_ productName:String, _ productSize:String, _ imagesArray:NSMutableArray,_ productStatus:String ,andCompletionHandler comletionHandler: @escaping (_ result: Bool) -> Void, andFalure failure: @escaping (_ falure: NSError) -> Void) {
        
        
        //1
        
        
        //2
        let entity =  NSEntityDescription.entity(forEntityName: "Product",
                                                 in:managedContext)
        let product = NSManagedObject(entity: entity!,
                                      insertInto: managedContext)
        //3
        
        product.setValue(productName, forKey: "productName")
        product.setValue(productSize, forKey: "sizeOfProduct")
        product.setValue(productStatus, forKey: "status")
        product.setValue(imagesArray, forKey: "productImages")
        
        //4
        do {
            try managedContext.save()
            print("save")
            let result = true
            comletionHandler(result)
            //5
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
            failure(error)
        }
        
        
    }
    
    //MARK:Core Data Work save product to Cart
    func saveProductValueToCart(_ productName:String, _ productSize:String, _ imagesArray:NSMutableArray,_ albumNameArray:NSMutableArray , _ count:String,_ quantity:String,_ primaryKey:String,_ amount:String, andCompletionHandler comletionHandler: @escaping (_ result: Bool) -> Void, andFalure failure: @escaping (_ falure: NSError) -> Void) {
        
        
        //1
        
        
        //2
        let entity =  NSEntityDescription.entity(forEntityName: "CartTable",
                                                 in:managedContext)
        let product = NSManagedObject(entity: entity!,
                                      insertInto: managedContext)
        //3
        
        product.setValue(productName, forKey: "productName")
        product.setValue(productSize, forKey: "sizeOfProduct")
        product.setValue(albumNameArray, forKey: "albumName")
        product.setValue(imagesArray, forKey: "productImages")
        product.setValue(count, forKey: "count")
        product.setValue(quantity, forKey: "quantity")
        product.setValue(primaryKey, forKey: "primaryKey")
        product.setValue(amount, forKey: "amount")
        
        //4
        do {
            try managedContext.save()
            print("save")
            let result = true
            comletionHandler(result)
            //5
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
            failure(error)
        }
        
        
    }
    
    
    //MARK: - Edit perticular row records in Table From DB
    
    func updateCartTableFromDB(_ primaryKey:String,_ quantity:String,_ amount:String)  {
        
        
        //2 - Create fetch Request with entity - User
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartTable")
            let predicate = NSPredicate(format: "primaryKey = %@" , primaryKey)
            fetchRequest.predicate = predicate
        
        
        //3 - Execute fetch request to receive array from DB
        
        do {
            let fetchResults = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            if fetchResults.count != 0 // Check notificationId available then not save
            {
                let managedObject = fetchResults[0]
                managedObject.setValue(quantity, forKey: "quantity")
                managedObject.setValue(amount, forKey: "amount")
                try Header.appDelegate.managedObjectContext.save()
                
            }
            // success ...
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        
    }

    

    
    
    //MARK: Save select images of product in Data Base
    
    func saveAlbumTableValueInDataBase(_ productName:String, _ productSize:String,_ albumName:String, _ selectImageIndexValue:String, _ selectImagesName:String,_ cropedImageName:String ,_ isCropedStatus:String ,andCompletionHandler comletionHandler: @escaping (_ result: Bool) -> Void, andFalure failure: @escaping (_ falure: NSError) -> Void) {
        
        
        //1
        
       
        //2
        let entity =  NSEntityDescription.entity(forEntityName: "AlbumTable",
                                                 in:managedContext)
        let product = NSManagedObject(entity: entity!,
                                      insertInto: managedContext)
        //3
        
        product.setValue(productName, forKey: "productName")
        product.setValue(productSize, forKey: "productSize")
        product.setValue(albumName, forKey: "albumName")
        product.setValue(cropedImageName, forKey: "cropedImageName")
        product.setValue(selectImageIndexValue, forKey: "selectedImageIndexValue")
        product.setValue(selectImagesName, forKey: "selectImageName")
        product.setValue(isCropedStatus, forKey: "isCroped")
        
        
        //4
        do {
            try managedContext.save()
            print("save")
            let result = true
            comletionHandler(result)
            //5
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
            failure(error)
        }
        
        
    }
    
    //MARK: Delete row from data base
    func deleteAlbumDataBaseTableRow(_ albumTable:[NSManagedObject],_ indexValue:NSIndexPath,andCompletionHandler comletionHandler: @escaping (_ result: Bool) -> Void, andFalure failure: @escaping (_ falure: NSError) -> Void) {
        
        
        //2
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AlbumTable")
        
        let predicate = NSPredicate(format: "selectImageName == %@","" )
        fetchRequest.predicate = predicate
        
        var error: NSError? = nil
        
        
        managedContext.delete(people[(indexValue as NSIndexPath).row] as NSManagedObject)
        people.remove(at: (indexValue as NSIndexPath).row)
        do {
            try managedContext.save()
        } catch _ {
        }
        
        
        
        
        
    }
    //MARK: fetch row from data base
    func fetchItemFromDB(_ imageUrl:String) -> Array<NSManagedObject> {
        //1 - Fetch App delegate instance and managed context
       
        
        //2 - Create fetch Request with entity - Item
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AlbumTable")
        
        if imageUrl != "" {
            let predicate = NSPredicate(format: "selectImageName = %@", "\(imageUrl)")
            fetchRequest.predicate = predicate
        }
        
        let latestRecordSortDescriptor = NSSortDescriptor(key: "selectImageName", ascending: false, selector: #selector(NSString.localizedStandardCompare(_:)))
        fetchRequest.sortDescriptors = [latestRecordSortDescriptor]
        
        //3 - Execute fetch request to receive array from DB
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            return fetchedResults
        }
        catch let error as NSError {
            return []
        }
    }
    
    //MARK: fetch row from data base
    func fetchImagesByProductNameFromDB(_ productName:String) -> Array<NSManagedObject> {
        //1 - Fetch App delegate instance and managed context
        
        
        //2 - Create fetch Request with entity - Item
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AlbumTable")
        
        if productName != "" {
            let predicate = NSPredicate(format: "productName = %@", "\(productName)")
            fetchRequest.predicate = predicate
        }
        
        let latestRecordSortDescriptor = NSSortDescriptor(key: "productName", ascending: false, selector: #selector(NSString.localizedStandardCompare(_:)))
        fetchRequest.sortDescriptors = [latestRecordSortDescriptor]
        
        //3 - Execute fetch request to receive array from DB
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            return fetchedResults
        }
        catch let error as NSError {
            return []
        }
    }
    
    
    //MARK: fetch row from data base
    func fetchDeatilsOfCartFromDB() -> Array<NSManagedObject> {
        //1 - Fetch App delegate instance and managed context
        
        
        //2 - Create fetch Request with entity - Item
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartTable")
        
        let latestRecordSortDescriptor = NSSortDescriptor(key: "productName", ascending: false, selector: #selector(NSString.localizedStandardCompare(_:)))
        fetchRequest.sortDescriptors = [latestRecordSortDescriptor]
        
        //3 - Execute fetch request to receive array from DB
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            return fetchedResults
        }
        catch let error as NSError {
            return []
        }
    }


    
    
    
    //MARK: fetch row from data base
    func fetchImagesBySizeFromDB(_ imageSize:String) -> Array<NSManagedObject> {
        //1 - Fetch App delegate instance and managed context
        
        
        //2 - Create fetch Request with entity - Item
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AlbumTable")
        
        if imageSize != "" {
            let predicate = NSPredicate(format: "productSize = %@", "\(imageSize)")
            fetchRequest.predicate = predicate
        }
        
        let latestRecordSortDescriptor = NSSortDescriptor(key: "productSize", ascending: false, selector: #selector(NSString.localizedStandardCompare(_:)))
        fetchRequest.sortDescriptors = [latestRecordSortDescriptor]
        
        //3 - Execute fetch request to receive array from DB
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            return fetchedResults
        }
        catch let error as NSError {
            return []
        }
    }

    
    
    
    
    
    //MARK: - fetch perticular row  in Table From DB
    func fetchAlbumImageFromDB(_ albumName:String) -> Array<NSManagedObject> {
        //1 - Fetch App delegate instance and managed context
       
        
        //2 - Create fetch Request with entity - User
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AlbumTable")
        
        if albumName != "" {
            let predicate = NSPredicate(format: "albumName = %@", "\(albumName)")
            fetchRequest.predicate = predicate
        }
        
        let latestRecordSortDescriptor = NSSortDescriptor(key: "albumName", ascending: false, selector: #selector(NSString.localizedStandardCompare(_:)))
        fetchRequest.sortDescriptors = [latestRecordSortDescriptor]
        
        //3 - Execute fetch request to receive array from DB
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            return fetchedResults
        }
        catch let error as NSError {
            return []
        }
    }
    
    
    //MARK: fetch row from data base
    func fetchItemFromCartTable(_ primaryKey:String) -> Array<NSManagedObject> {
        //1 - Fetch App delegate instance and managed context
        
        
        //2 - Create fetch Request with entity - Item
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartTable")
        
        if primaryKey != "" {
            let predicate = NSPredicate(format: "primaryKey = %@", "\(primaryKey)")
            fetchRequest.predicate = predicate
        }
        
        let latestRecordSortDescriptor = NSSortDescriptor(key: "primaryKey", ascending: false, selector: #selector(NSString.localizedStandardCompare(_:)))
        fetchRequest.sortDescriptors = [latestRecordSortDescriptor]
        
        //3 - Execute fetch request to receive array from DB
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            return fetchedResults
        }
        catch let error as NSError {
            return []
        }
    }

    
    
    
    
    //MARK: - Delete records in Table From DB
    func deleteRecordsFromDB(_ dbArray:Array<NSManagedObject>) {
        //1 - Fetch App delegate instance and managed context
       
        
        //2 - Fetch data from DB
        var arrDataFromDB = dbArray
        
        
        if arrDataFromDB.count > 0 {
            //3 - Loop through all rows of data and delete object.
            for rowNo in 0...arrDataFromDB.count - 1 {
                managedContext.delete(arrDataFromDB[rowNo] as NSManagedObject)
            }
            
            // Save data in managed object context.
            do {
                try Header.appDelegate.managedObjectContext.save()
            }
            catch {
                fatalError("Failure to save context: \(error)")
            }
        }
    }
    
    
    //MARK: - Edit perticular row records in Table From DB
    
    func updateAlbumTableFromDB(_ albumName:String,_ indexValue:String,_ cropImageUrl:String)  {
        
        
        
        //2 - Create fetch Request with entity - User
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AlbumTable")
        
        if albumName != "" {
            
            let predicate = NSPredicate(format: "albumName = %@ AND selectedImageIndexValue = %@", "\(albumName)","\(indexValue)")
            
            fetchRequest.predicate = predicate
        }
        
        
        //3 - Execute fetch request to receive array from DB
        
        do {
            let fetchResults = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            if fetchResults.count != 0 // Check notificationId available then not save
            {
                let managedObject = fetchResults[0]
                managedObject.setValue(cropImageUrl, forKey: "cropedImageName")
                managedObject.setValue("1", forKey: "isCroped")
                
                try Header.appDelegate.managedObjectContext.save()
                
            }
            // success ...
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        
    }

    


}
