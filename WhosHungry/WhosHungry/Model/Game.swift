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
    let users: [User]
    let city: String
    let radius: Double
    let mealType: String
    let submittedVotes: [Dictionary<String, Int>]
    let uid: String
//    let creatorID: String
    
    init(inviteCode: String, users: [User], city: String, radius: Double, mealType: String, submittedVotes: [Dictionary<String, Int>], uid: String = UUID().uuidString) {
        self.inviteCode = inviteCode
        self.users = users
        self.city = city
        self.radius = radius
        self.mealType = mealType
        self.submittedVotes = submittedVotes
        self.uid = uid
        
//        self.creatorID = creatorID
    }
}

extension Game {
    init?(inviteCode: String) {
        let inviteCode = inviteCode
        self.init(inviteCode: inviteCode)
    }
    
//    init?(dictionary: [String : Any]) {
//        guard let inviteCode = dictionary[Constants.inviteCode] as? String
//        else {return}
//        self.init(dictionary: inviteCode)
//    }
}
