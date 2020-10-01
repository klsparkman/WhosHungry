//
//  FirebaseError.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 9/28/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import Foundation

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
