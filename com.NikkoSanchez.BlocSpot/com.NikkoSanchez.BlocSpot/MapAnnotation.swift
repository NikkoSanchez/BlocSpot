//
//  MapAnnotation.swift
//  com.NikkoSanchez.BlocSpot
//
//  Created by Nikko on 11/1/16.
//  Copyright © 2016 Nikko. All rights reserved.
//

import UIKit
import MapKit

class MapAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?

    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title
    }
}
