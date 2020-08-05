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
    let users: [User]
    let city: String
    let radius: Double
    let mealType: String
    
    init(uid: String = UUID().uuidString, users: [User], city: String, radius: Double, mealType: String) {
        self.uid = uid
        self.users = users
        self.city = city
        self.radius = radius
        self.mealType = mealType
    }
}
