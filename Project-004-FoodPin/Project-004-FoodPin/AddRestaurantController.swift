//
//  AddRestaurantController.swift
//  Project-004-FoodPin
//
//  Created by Bean on 16/7/8.
//  Copyright © 2016年 Bean. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

class AddRestaurantController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var typeTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var phoneNumberTextField: UITextField!
    @IBOutlet var yesButton: UIButton!
    @IBOutlet var noButton: UIButton!
    
    var restaurant: Restaurant!
    var isVisited = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func save(sender: UIBarButtonItem) {
    
        let name = nameTextField.text
        let type = typeTextField.text
        let location = locationTextField.text
        let phoneNumber = phoneNumberTextField.text
        
        if name == "" || type == "" || location == "" {
            let alertController = UIAlertController(title: "Oops", message: "We can't proceed because one of the fields is blank. Please note that all fields are required.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
 
        // 将数据存入 CoreData中
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            restaurant = NSEntityDescription.insertNewObjectForEntityForName("Restaurant", inManagedObjectContext: managedObjectContext) as! Restaurant
            restaurant.name = name!
            restaurant.type = type!
            restaurant.location = location!
            restaurant.phoneNumber = phoneNumber!
            restaurant.rating = "rating"
            if let restaurantImage = imageView.image {
                restaurant.image = UIImagePNGRepresentation(restaurantImage)
            }
            restaurant.isVisited = isVisited
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
                return 
            }
        }
        saveRecordToCloud(restaurant)
        // performSegueWithIdentifier("unwindToHomeScreen", sender: self)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func toggleBeenHereButton(sender: UIButton) {
        if sender == yesButton {
            isVisited = true
            yesButton.backgroundColor = UIColor.redColor()
            noButton.backgroundColor = UIColor.grayColor()
        } else {
            isVisited = false
            yesButton.backgroundColor = UIColor.grayColor()
            noButton.backgroundColor = UIColor.redColor()
        }
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .PhotoLibrary
                
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    func saveRecordToCloud(restaurant: Restaurant!) -> Void {
        let record = CKRecord(recordType: "Restaurant")
        record.setValue(restaurant.name, forKey: "name")
        record.setValue(restaurant.type, forKey: "type")
        record.setValue(restaurant.location, forKey: "location")
        record.setValue(restaurant.phoneNumber, forKey: "phoneNumber")
        
        // Resize the image
        let originalImage = UIImage(data: restaurant.image!)!
        let scalingFactor = (originalImage.size.width > 1024) ? 1024 / originalImage.size.width : 1.0
        let scaledImage = UIImage(data: restaurant.image!, scale: scalingFactor)!
        
        // Write the image to local file for temporary use
        let imageFilePath = NSTemporaryDirectory() + restaurant.name
        UIImageJPEGRepresentation(scaledImage, 0.8)?.writeToFile(imageFilePath, atomically: true)
        
        // Create image asset for upload
        let imageFileURL = NSURL(fileURLWithPath: imageFilePath)
        let imageAsset = CKAsset(fileURL: imageFileURL)
        record.setValue(imageAsset, forKey: "image")
        
        // Get the Public iCloud Database
        let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
        
        // Save the record to iCloud
        publicDatabase.saveRecord(record, completionHandler: {
            (record: CKRecord?, error: NSError?) -> Void in
            //Remove temp file
            do {
                try NSFileManager.defaultManager().removeItemAtPath(imageFilePath)
            } catch {
                print("Failed to save record to the cloud:\(error)")
            }
        })
    }
    
}
