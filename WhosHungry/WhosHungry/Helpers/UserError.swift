//
//  UserDefaults.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 7/18/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import Foundation

enum UserError: LocalizedError {
    
    case noData
    case firebaseError(Error)
    
    var errorDescription: String? {
        switch self {
        case .noData:
            return "Server responded with no data."
        case .firebaseError(let error):
            return ("Firebase returned with an error: \(error)")
        }
    }
}


