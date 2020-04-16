//
//  RestaurantError.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 4/15/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import Foundation

enum RestaurantError: LocalizedError {
   
    case invalidURL
    case thrown(Error)
    case noData
    case unableToDecode
    
    // What the user sees
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Unable to reach server."
        case .thrown(let error):
            return error.localizedDescription
        case .noData:
            return "Server responded with no data."
        case .unableToDecode:
            return "Server responded with bad data"
        }
    }
    
}
