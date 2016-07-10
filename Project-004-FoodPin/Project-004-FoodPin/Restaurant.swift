//
//  Restaurant.swift
//  Project-004-FoodPin
//
//  Created by Bean on 16/7/7.
//  Copyright © 2016年 Bean. All rights reserved.
//

import Foundation
import CoreData

class Restaurant: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var type: String
    @NSManaged var location: String
    @NSManaged var image: NSData?
    @NSManaged var phoneNumber: String?
    @NSManaged var isVisited: NSNumber?
    @NSManaged var rating: String?
    
//    init(name: String, type: String, location: String, phoneNumber: String, image: NSData, isVisited: NSNumber) {
//        self.name = name
//        self.type = type
//        self.location = location
//        self.image = image
//        self.isVisited = isVisited
//        self.phoneNumber = phoneNumber
//    }
}
