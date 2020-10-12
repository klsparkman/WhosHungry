//
//  Rating.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 10/9/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import Foundation
import UIKit

enum Rating: String {
    case five = "5.0"
    case fourAndAAhalf = "4.5"
    case four = "4.0"
    case threeAndAHalf = "3.5"
    case three = "3.0"
    case twoAndAHalf = "2.5"
    case two = "2.0"
    case oneAndAHalf = "1.5"
    case one = "1.0"
    case zero = "0.0"
    
//    func getImageName() -> String {
//        switch self {
//        case .five:
//            return "regular_5"
//        case .fourAndAAhalf:
//            return "regular_4_half"
//        case .four:
//            return "regular_4"
//        case .threeAndAHalf:
//            return "regular_3_half"
//        case .three:
//            return "regular_3"
//        case .twoAndAHalf:
//            return "regular_2_half"
//        case .two:
//            return "regular_2"
//        case .oneAndAHalf:
//            return "regular_1_half"
//        case .one:
//            return "regular_1"
//        case .zero:
//            return "regular_0"
//        }
//    }
    
    func getImage(rating: Double) -> String {
        switch self {
        case .five:
            return "regular_5"
        case .fourAndAAhalf:
            return "regular_4_half"
        case .four:
            return "regular_4"
        case .threeAndAHalf:
            return "regular_3_half"
        case .three:
            return "regular_3"
        case .twoAndAHalf:
            return "regular_2_half"
        case .two:
            return "regular_2"
        case .oneAndAHalf:
            return "regular_1_half"
        case .one:
            return "regular_1"
        case .zero:
            return "regular_0"
        }
    }
    
}
