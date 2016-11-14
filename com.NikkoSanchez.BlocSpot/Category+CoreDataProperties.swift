//
//  Category+CoreDataProperties.swift
//  com.NikkoSanchez.BlocSpot
//
//  Created by Nikko on 11/11/16.
//  Copyright © 2016 Nikko. All rights reserved.
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category");
    }

    @NSManaged public var title: String?
    @NSManaged public var color: NSObject?

}
