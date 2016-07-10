//
//  RestaurantDetailViewController.swift
//  Project-004-FoodPin
//
//  Created by Bean on 16/7/7.
//  Copyright © 2016年 Bean. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var restaurant : Restaurant!
    @IBOutlet var restaurantImageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var ratingButton: UIButton!
    // 关闭模态框
    @IBAction func close(segue: UIStoryboardSegue) {
        if let reviewViewController = segue.sourceViewController as? ReviewViewController {
            if let rating = reviewViewController.rating {
                ratingButton.setImage(UIImage(named: rating), forState: UIControlState.Normal)
                restaurant.rating = rating
                
                if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
                    do {
                        try managedObjectContext.save()
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }


    override func viewDidLoad() {
        
        super.viewDidLoad()
        print(restaurant.name)
        // 设置navigationbar的标题
        title = restaurant.name
        
        // 设置ratingButton的样式
        if restaurant.rating != "" {
            
            ratingButton.setImage(UIImage(named: restaurant.rating!), forState: UIControlState.Normal)
        }
        // 设置表格自适应文本长度，调整宽度，同时需要设置storyboard中label的 lines 为 0
        tableView.estimatedRowHeight = 36.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // 设置tableView 的颜色还有分割线颜色
        tableView.backgroundColor = UIColor(red: 20.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.2)
        tableView.separatorColor = UIColor(red: 20.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.8)
        
        // imageView 控件展示饭店图像
        // restaurantImageView.image = UIImage(named: restaurant.image)
        restaurantImageView.image = UIImage(data: restaurant.image!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
//    
//    override func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return .LightContent
//    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! RestaurantDetailTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.fieldLabel.text = "Name"
            cell.valueLabel.text = restaurant.name
        case 1:
            cell.fieldLabel.text = "Type"
            cell.valueLabel.text = restaurant.type
        case 2:
            cell.fieldLabel.text = "Location"
            cell.valueLabel.text = restaurant.location
        case 3:
            cell.fieldLabel.text = "Phone"
            cell.valueLabel.text = restaurant.phoneNumber
        case 4:
            cell.fieldLabel.text = "Been here"
            if let isVisited = restaurant.isVisited?.boolValue {
                cell.valueLabel.text = isVisited ? "Yes,I've been here before" : "No"
            }
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
        }
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    // 地图
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showMap" {
            let destnationController = segue.destinationViewController as! MapViewController
            destnationController.restaurant = restaurant
        }
    }
    // 关闭模态框
    
}
