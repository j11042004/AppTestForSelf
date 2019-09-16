//
//  Car+CoreDataProperties.swift
//  CoreDataTest
//
//  Created by Uran on 2018/1/24.
//  Copyright © 2018年 Uran. All rights reserved.
//
//

import Foundation
import CoreData


extension Car {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Car> {
        return NSFetchRequest<Car>(entityName: "Car")
    }

    @NSManaged public var plate: String?
    @NSManaged public var belongto: UserData?

}
