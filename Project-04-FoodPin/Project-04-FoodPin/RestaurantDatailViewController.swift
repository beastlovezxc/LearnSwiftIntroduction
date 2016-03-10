//
//  RestaurantDatailViewController.swift
//  Project-04-FoodPin
//
//  Created by Bean on 16/3/10.
//  Copyright © 2016年 Bean. All rights reserved.
//

import UIKit

class RestaurantDatailViewController: UIViewController {
    @IBOutlet var restaurantImageView: UIImageView!
    @IBOutlet var restaurantNameLabel: UILabel!
    @IBOutlet var restaurantLocationLabel: UILabel!
    @IBOutlet var restaurantTypeLabel: UILabel!
    var restaurantImage = ""
    var restaurantName = ""
    var restaurantLocation = ""
    var restaurantType = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantNameLabel.text = restaurantName
        restaurantLocationLabel.text = restaurantLocation
        restaurantTypeLabel.text = restaurantType
        restaurantImageView.image = UIImage(named: restaurantImage)
    }
}
