//
//  Restaurant.swift
//  Project-04-FoodPin
//
//  Created by Bean on 16/3/10.
//  Copyright © 2016年 Bean. All rights reserved.
//

import Foundation

class Restaurant {
    var name = ""
    var type = ""
    var location = ""
    var image = ""
    var isVisited = false
    var phoneNumber = ""
    var rating = ""
    init(name: String, type: String, location: String, phoneNumber: String, image: String, isVisited: Bool) {
        self.name = name
        self.type = type
        self.location = location
        self.phoneNumber = phoneNumber
        self.image = image
        self.isVisited = isVisited
    }
}