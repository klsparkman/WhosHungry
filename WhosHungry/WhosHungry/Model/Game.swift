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
    
    init(uid: String = UUID().uuidString, users: [User]) {
        self.uid = uid
        self.users = users
    }
}
