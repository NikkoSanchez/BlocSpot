//
//  Category+CoreDataProperties.swift
//  com.NikkoSanchez.BlocSpot
//
//  Created by Nikko on 11/19/16.
//  Copyright © 2016 Nikko. All rights reserved.
//

import Foundation
import CoreData

extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category");
    }

    @NSManaged public var color: Int16
    @NSManaged public var timeStamp: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var pins: NSSet?

}

// MARK: Generated accessors for pins
extension Category {

    @objc(addPinsObject:)
    @NSManaged public func addToPins(_ value: Pin)

    @objc(removePinsObject:)
    @NSManaged public func removeFromPins(_ value: Pin)

    @objc(addPins:)
    @NSManaged public func addToPins(_ values: NSSet)

    @objc(removePins:)
    @NSManaged public func removeFromPins(_ values: NSSet)

}
