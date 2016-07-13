//
//  DiscoverTableViewController.swift
//  Project-004-FoodPin
//
//  Created by Bean on 16/7/12.
//  Copyright © 2016年 Bean. All rights reserved.
//

import UIKit
import CloudKit

class DiscoverTableViewController: UITableViewController {
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var restaurants:[CKRecord] = []
    var imageCache: NSCache = NSCache()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getRecordsFromCloud()
        
        // spinner : activity indicator by code
//        var spinner:UIActivityIndicatorView = UIActivityIndicatorView()
//        spinner.activityIndicatorViewStyle = .Gray
//        spinner.center = view.center
//        spinner.hidesWhenStopped = true
//        view.addSubview(spinner)
//        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Pull to Refresh Control
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.whiteColor()
        refreshControl?.tintColor = UIColor.grayColor()
        refreshControl?.addTarget(self, action: "getRecordsFromCloud", forControlEvents: UIControlEvents.ValueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return restaurants.count
    }

    // convience API  适合小数据的提取 Operational API 适合大数据  定制提取
    
    func getRecordsFromCloud() {
        
        // Fetch data using Convenience API
        let cloudContainer = CKContainer.defaultContainer()
        let publicDatabase = cloudContainer.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        
        // Create the query operation with the query   同时加载name 和 image
//        let queryOperation = CKQueryOperation(query: query)
//        queryOperation.desiredKeys = ["name", "image"]
//        queryOperation.queuePriority = .VeryHigh
//        queryOperation.resultsLimit = 50
//        queryOperation.recordFetchedBlock = {
//            (record: CKRecord!) -> Void in
//            if let restaurantRecord = record {
//                self.restaurants.append(restaurantRecord)
//            }
//        }
        //  优化用户体验，先加载文字消息，后加载图片
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.desiredKeys = ["name"]
        queryOperation.queuePriority = .VeryHigh
        queryOperation.resultsLimit = 50
        queryOperation.recordFetchedBlock = {
            (record: CKRecord!) -> Void in
            if let restaurantRecord = record {
                self.restaurants.append(restaurantRecord)
            }
        }
        queryOperation.queryCompletionBlock = {
            (cursor: CKQueryCursor?, error: NSError?) -> Void in
            if(error != nil) {
                print("Failed to get data from iCloud -\(error!.localizedDescription)")
                return
            }
            
            print("Successfully retrieve the data from iCloud")
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                self.spinner.stopAnimating()
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
        //Execute the query
        publicDatabase.addOperation(queryOperation)
//        publicDatabase.performQuery(query, inZoneWithID: nil, completionHandler: {
//            (results, error) -> Void in
//            if error != nil {
//                print(error)
//                return
//            }
//            
//            if let results = results {
//                print("Completed the download of Restaurant data")
//                self.restaurants = results
//               
//                // 将ui刷新放入线程队列，一旦数据加载完成即可刷新ui，大幅度减少载入速度
//                //self.tableView.reloadData()
//                NSOperationQueue.mainQueue().addOperationWithBlock() {
//                    self.tableView.reloadData()
//                }
//            }
//        })
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let restaurant = restaurants[indexPath.row]
        cell.textLabel?.text = restaurant.objectForKey("name") as? String
        
//        if let image = restaurant.objectForKey("image") {
//            let imageAsset = image as! CKAsset
//            cell.imageView?.image = UIImage(data: NSData(contentsOfURL: imageAsset.fileURL)!)
//        }
        cell.imageView?.image = UIImage(named: "photoalbum")
        // Fetch Image from Cloud in background
        if let imageFileURL = imageCache.objectForKey(restaurant.recordID) as? NSURL {
            print("Get image from cache")
            cell.imageView?.image = UIImage(data: NSData(contentsOfURL: imageFileURL)!)
        } else {
            let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
            let fetchRecordImageOperation = CKFetchRecordsOperation(recordIDs: [restaurant.recordID])
            fetchRecordImageOperation.desiredKeys = ["image"]
            fetchRecordImageOperation.queuePriority = .VeryHigh
            
            fetchRecordImageOperation.perRecordCompletionBlock = {
                (record: CKRecord?, recordID: CKRecordID?, error: NSError?) -> Void in
                if(error != nil) {
                    print("Failed to get restaurant image:\(error!.localizedDescription)")
                    return
                }
            
                if let restaurantRecord = record {
                    NSOperationQueue.mainQueue().addOperationWithBlock() {
                        if let imageAsset = restaurantRecord.objectForKey("image") as? CKAsset {
                            cell.imageView?.image = UIImage(data: NSData(contentsOfURL: imageAsset.fileURL)!)
                            self.imageCache.setObject(imageAsset.fileURL, forKey: restaurant.recordID)
                        }
                    }
                }
            }
            publicDatabase.addOperation(fetchRecordImageOperation)
        // Configure the cell...
        }
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
