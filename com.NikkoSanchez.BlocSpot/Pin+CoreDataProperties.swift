//
//  Pin+CoreDataProperties.swift
//  com.NikkoSanchez.BlocSpot
//
//  Created by Nikko on 11/19/16.
//  Copyright © 2016 Nikko. All rights reserved.
//

import Foundation
import CoreData

extension Pin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin> {
        return NSFetchRequest<Pin>(entityName: "Pin");
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var title: String?
    @NSManaged public var category: Category?

}
