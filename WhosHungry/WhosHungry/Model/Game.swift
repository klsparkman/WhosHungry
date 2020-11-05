//
//  Game.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 7/3/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import Foundation

struct Game {
    let inviteCode: String
    let users: [String]
    let city: String
    let radius: Double
    let mealType: String
    let submittedVotes: [String]
    let uid: String = UUID().uuidString
    
    init(inviteCode: String, users: [String], city: String, radius: Double, mealType: String, submittedVotes: [String]) {
        self.inviteCode = inviteCode
        self.users = users
        self.city = city
        self.radius = radius
        self.mealType = mealType
        self.submittedVotes = submittedVotes

    }
}

extension Game {
    init?(dictionary: [String : Any]) {
        guard let inviteCode = dictionary[Constants.inviteCode] as? String,
              let users = dictionary[Constants.users] as? [String],
              let city = dictionary[Constants.city] as? String,
              let radius = dictionary[Constants.radius] as? Double,
              let mealType = dictionary[Constants.mealType] as? String,
              let submittedVotes = dictionary[Constants.submittedVotes] as? [String]
//              let uid = dictionary[Constants.uid] as? String
        else {return nil}
        self.init(inviteCode: inviteCode, users: users, city: city, radius: radius, mealType: mealType, submittedVotes: submittedVotes)
    }
}
