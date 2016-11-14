//
//  CategoryColorEnum.swift
//  com.NikkoSanchez.BlocSpot
//
//  Created by Nikko on 11/13/16.
//  Copyright © 2016 Nikko. All rights reserved.
//

import Foundation
import UIKit

enum CategoryColorEnum: Int {
    case red = 0
    case blue = 1
    case cyan = 2
    case green = 3
    case yellow = 4
    
    func colorFor(category: CategoryColorEnum) -> UIColor {
        switch category {
        case .red:
            return UIColor.red
        case .blue:
            return UIColor.blue
        case .cyan:
            return UIColor.cyan
        case .green:
            return UIColor.green
        case .yellow:
            return UIColor.yellow
        }
    }
    
    func colorFor(lastColor: CategoryColorEnum) -> Int {
        switch lastColor {
        case .red:
            return CategoryColorEnum.red.rawValue
        case .blue:
            return CategoryColorEnum.blue.rawValue
        case .cyan:
            return CategoryColorEnum.cyan.rawValue
        case .green:
            return CategoryColorEnum.green.rawValue
        case .yellow:
            return CategoryColorEnum.yellow.rawValue
        }
    }
}
