//
//  GameError.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 10/1/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import Foundation

enum GameError: LocalizedError {
    
    case noGameExists
    case firebaseError(Error)
    
    var errorDescription: String? {
        
        switch self {
        case .noGameExists:
            return("There is no game that matches that invite code")
        case .firebaseError(let error):
            return("Firebase returned with an error: \(error.localizedDescription)")
        }
    }
}
