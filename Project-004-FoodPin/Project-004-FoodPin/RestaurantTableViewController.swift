//
//  RestaurantTableViewController.swift
//  Project-004-FoodPin
//
//  Created by Bean on 16/7/6.
//  Copyright © 2016年 Bean. All rights reserved.
//

import UIKit
import CoreData

class RestaurantTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {

  
    var restaurants:[Restaurant] = []
    var fetchResultController: NSFetchedResultsController!
    var searchController: UISearchController!
    var searchResults: [Restaurant] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Remove the title of the back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
            
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        // fetchResultController
        let fetchRequest = NSFetchRequest(entityName: "Restaurant")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                restaurants = fetchResultController.fetchedObjects as! [Restaurant]
            } catch {
                print(error)
            }
        }
        
        // UISearchBar
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let hasViewedWalkthrough = defaults.boolForKey("hasViewedWalkthrough")
        if hasViewedWalkthrough {
            return
        }
        if let pageViewController = storyboard?.instantiateViewControllerWithIdentifier("WalkthroughController") as? WalkthroughPageViewController {
            presentViewController(pageViewController, animated: true, completion: nil)
        }
    }
//    override func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return .LightContent
//    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! RestaurantTableViewCell
        
        let restaurant = (searchController.active) ? searchResults[indexPath.row] : restaurants[indexPath.row]
//        
//        cell.nameLabel?.text = restaurants[indexPath.row].name
//        cell.locationLabel?.text = restaurants[indexPath.row].location
//        cell.typeLabel?.text = restaurants[indexPath.row].type
        cell.nameLabel.text = restaurant.name
        cell.locationLabel.text = restaurant.location
        cell.thumbnailImageView.image = UIImage(data: restaurant.image!)
        cell.typeLabel.text = restaurant.type
        // 不使用 CoreData 时加载图像用图像名称
      //  cell.thumbnailImageView.image = UIImage(named: restaurants[indexPath.row].image)
        // 使用 CoreData 时加载图像
//        cell.thumbnailImageView.image = UIImage(data: restaurants[indexPath.row].image!)
//        cell.thumbnailImageView.layer.cornerRadius = 30.0
//        cell.thumbnailImageView.clipsToBounds = true
        // 使用 CoreData 时 bool 类型换成了 NSNumber 类型
//        if restaurants[indexPath.row].isVisited {
//            cell.accessoryType = .Checkmark
//        } else {
//            cell.accessoryType = .None
//        }
        if let isVisited = restaurant.isVisited?.boolValue {
            cell.accessoryType = isVisited ? .Checkmark : .None
        }
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if searchController.active {
            return false
        } else {
            return true
        }
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active {
            return searchResults.count
        } else {
            return restaurants.count
        }
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        let optionMenu = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: .Alert)
//        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
//        
//        let callActionHandler = { (action: UIAlertAction!) -> Void in
//            let alertMessage = UIAlertController(title: "Service Unavailable", message: "Sorry, the call feature is not available yet. Please retry later.", preferredStyle: .Alert)
//            alertMessage.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//            self.presentViewController(alertMessage, animated: true, completion: nil)
//        }
//        
//        let callAction = UIAlertAction(title: "Call " + restaurants[indexPath.row].phoneNumber!, style: UIAlertActionStyle.Default, handler: callActionHandler)
//       // if !restaurants[indexPath.row].isVisited {
//        if let isVisited = restaurants[indexPath.row].isVisited?.boolValue {
//            if !isVisited {
//                let isVisitedAction = UIAlertAction(title: "I've been here", style: .Default, handler: {
//                    (action: UIAlertAction!) -> Void in
//                    let cell = tableView.cellForRowAtIndexPath(indexPath)
//                    cell?.accessoryType = .Checkmark
//                    self.restaurants[indexPath.row].isVisited = true
//                })
//        
//                optionMenu.addAction(isVisitedAction)
//            } else {
//                let isVisitedAction = UIAlertAction(title: "I've not been here", style: .Default, handler: {
//                    (action: UIAlertAction!) -> Void in
//                    let cell = tableView.cellForRowAtIndexPath(indexPath)
//                    cell?.accessoryType = .None
//                    self.restaurants[indexPath.row].isVisited = false
//                })
//                optionMenu.addAction(isVisitedAction)
//            }
//        }
//        optionMenu.addAction(callAction)
//        optionMenu.addAction(cancelAction)
//        
//        self.presentViewController(optionMenu, animated: true, completion: nil)
//        tableView.deselectRowAtIndexPath(indexPath, animated: false)
//    }
   /*
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            restaurants.removeAtIndex(indexPath.row)
        }
       // tableView.reloadData()
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    */
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Share", handler: {
            (action,indexPath) -> Void in
            let defaultText = "Just checking in at " + self.restaurants[indexPath.row].name
            if let imageToShare = UIImage(data: self.restaurants[indexPath.row].image!) {
                let activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
                self.presentViewController(activityController, animated: true, completion: nil)
            }
        })
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler: {
            (action, indexPath) -> Void in
            // 没有 CoreData情况下删除一条显示数据
//            self.restaurants.removeAtIndex(indexPath.row)
//
//            
//            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            // Delete the row from the database
            if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
                let restaurantToDelete = self.fetchResultController.objectAtIndexPath(indexPath) as! Restaurant
                managedObjectContext.deleteObject(restaurantToDelete)
                
                do {
                    try managedObjectContext.save()
                } catch {
                    print(error)
                }
            }
        })
        
        shareAction.backgroundColor = UIColor(red: 28.0/255.0, green: 165.0/255.0, blue: 253.0/255.0, alpha: 1.0)
        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        return [deleteAction, shareAction]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRestaurantDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destinationViewController as! RestaurantDetailViewController
                //destinationController.restaurant = restaurants[indexPath.row]
                destinationController.restaurant = (searchController.active) ? searchResults[indexPath.row] : restaurants[indexPath.row]
                
            }
        }
    }
    
    @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
    }
    
    // NSFetchedResultsControllerDelegate Protocol
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            if let _newIndexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([_newIndexPath], withRowAnimation: .Fade)
            }
        case .Delete:
            if let _indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([_indexPath], withRowAnimation: .Fade)
            }
        case .Update:
            if let _indexPath = indexPath {
                tableView.reloadRowsAtIndexPaths([_indexPath], withRowAnimation: .Fade)
            }
        default:
            tableView.reloadData()
        }
        
        restaurants = controller.fetchedObjects as! [Restaurant]
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }

    // 搜索策略
    func filterContentForSearchText(searchText: String) {
        searchResults = restaurants.filter({(restaurant: Restaurant) -> Bool in
            let nameMatch = restaurant.name.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            let locationMatch = restaurant.location.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return nameMatch != nil || locationMatch != nil
        })
    }
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContentForSearchText(searchText)
            tableView.reloadData()
        }
    }
}

