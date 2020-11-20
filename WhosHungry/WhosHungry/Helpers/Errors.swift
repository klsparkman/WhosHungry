//
//  Errors.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 11/20/20.
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

enum GameError: LocalizedError {
    
    case noGameExists
    case firebaseError(Error)
    case noData
    
    var errorDescription: String? {
        
        switch self {
        case .noGameExists:
            return("There is no game that matches that invite code")
        case .firebaseError(let error):
            return("Firebase returned with an error: \(error.localizedDescription)")
        case .noData:
            return("There was no data")
        }
    }
}

enum FirebaseError: LocalizedError {
    
    case fbError(Error)
    case noPreviousUser
    
    var errorDescription: String? {
        
        switch self {
        case .fbError(let error):
            return "Firebase returned an error: \(error.localizedDescription)"
        case .noPreviousUser:
            return "There was no match in Firebase for a previously signed in user."
        }
    }
}

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
