//
//  Game.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 7/3/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import Foundation

struct Game {
    let uid: String
    let inviteCode: String
    let city: String
    let radius: Double
    let mealType: String
    let users: [String]
    var gameHasBegun: Bool
    var allVotesSubmitted: Bool
    var winningRestaurant: String
    var numberOfRevotes: Int
    
    init(uid: String = UUID().uuidString, inviteCode: String, city: String, radius: Double, mealType: String, users: [String], gameHasBegun: Bool = false, allVotesSubmitted: Bool = false, winningRestaurant: String = "", numberOfRevotes: Int = 0) {
        self.uid = uid
        self.inviteCode = inviteCode
        self.city = city
        self.radius = radius
        self.mealType = mealType
        self.users = users
        self.gameHasBegun = gameHasBegun
        self.allVotesSubmitted = allVotesSubmitted
        self.winningRestaurant = winningRestaurant
        self.numberOfRevotes = numberOfRevotes
    }
}

extension Game {
    init?(dictionary: [String : Any]) {
        guard let uid = dictionary[Constants.uid] as? String,
              let inviteCode = dictionary[Constants.inviteCode] as? String,
              let city = dictionary[Constants.city] as? String,
              let radius = dictionary[Constants.radius] as? Double,
              let mealType = dictionary[Constants.mealType] as? String,
              let users = dictionary[Constants.users] as? [String]
//              let creatorID = dictionary[Constants.creatorID] as? String
        else {return nil}
        self.init(uid: uid, inviteCode: inviteCode, city: city, radius: radius, mealType: mealType, users: users)
    }
}
