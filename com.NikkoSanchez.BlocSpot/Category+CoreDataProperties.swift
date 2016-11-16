//
//  Category+CoreDataProperties.swift
//  com.NikkoSanchez.BlocSpot
//
//  Created by Nikko on 11/15/16.
//  Copyright © 2016 Nikko. All rights reserved.
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category");
    }

    @NSManaged public var title: String?
    @NSManaged public var color: Int16
    @NSManaged public var timeStamp: NSDate?

}
