//
//  RestaurantDatailViewController.swift
//  Project-04-FoodPin
//
//  Created by Bean on 16/3/10.
//  Copyright © 2016年 Bean. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var restaurantImageView: UIImageView!
    @IBOutlet var restaurantNameLabel: UILabel!
    @IBOutlet var restaurantLocationLabel: UILabel!
    @IBOutlet var restaurantTypeLabel: UILabel!
    @IBOutlet var tableView: UITableView!
//    var restaurantImage = ""
//    var restaurantName = ""
//    var restaurantLocation = ""
//    var restaurantType = ""
    var restaurant: Restaurant!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        restaurantNameLabel.text = restaurantName
//        restaurantLocationLabel.text = restaurantLocation
//        restaurantTypeLabel.text = restaurantType
//        restaurantImageView.image = UIImage(named: restaurantImage)
     //   restaurantNameLabel.text = restaurant.name
       // restaurantLocationLabel.text = restaurant.location
       // restaurantTypeLabel.text = restaurant.type
        restaurantImageView.image = UIImage(named: restaurant.image)
        tableView.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.2)
        // 去除没有内容的表格分割线
        tableView.tableFooterView = UIView(frame: CGRectZero)
        // 为分割线调整颜色
        tableView.separatorColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.8)
        title = restaurant.name
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
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
            cell.valueLabel.text = restaurant.phone
        case 4:
            cell.fieldLabel.text = "Been here"
            cell.valueLabel.text = (restaurant.isVisited) ? "Yes,I've been here before" : "No"
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
        }
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
}
