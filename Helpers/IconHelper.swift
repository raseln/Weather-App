//
//  IconHelper.swift
//  ProjectWinas
//
//  Created by Md. Ahsan Ullah Rasel on 27/9/19.
//  Copyright © 2019 Md. Ahsan Ullah Rasel. All rights reserved.
//

import UIKit

struct IconHelper {
    static func getIcon(icon: Icon) -> UIImage {
        switch icon {
        case .cloudy:
            return UIImage(named: "cloudy")!
            
        case .clearDay:
            return UIImage(named: "cloudy")!
            
        case .rain:
            return UIImage(named: "rain")!
            
        case .snow:
            return UIImage(named: "snow")!
            
        case .clearNight:
            return UIImage(named: "clear-night")!
            
        case .sleet:
            return UIImage(named: "sleet")!
            
        case .wind:
            return UIImage(named: "wind")!
            
        case .fog:
            return UIImage(named: "fog")!
            
        case .partlyCloudyNight:
            return UIImage(named: "partly-cloudy-night")!
            
        default:
            return UIImage(named: "partly-cloudy-day")!
        }
    }
}
