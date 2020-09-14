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
    let category: String
    
    init(inviteCode: String, users: [User], city: String, radius: Double, category: String) {
        self.inviteCode = inviteCode
        self.users = users
        self.city = city
        self.radius = radius
        self.category = category
    }
}
