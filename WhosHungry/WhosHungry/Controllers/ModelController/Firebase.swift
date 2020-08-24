//
//  Firebase.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 7/3/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import UIKit
import Firebase
import AuthenticationServices

class Firebase {
    
    static let shared = Firebase()
    let db = Firestore.firestore()
    
    func createGame(game: Game) {
        let gameUID = UUID().uuidString
        let gameDictionary: [String : Any] = ["uid" : game.uid,
                                             "users" : game.users,
                                             "city" : game.city,
                                             "radius" : game.radius,
                                             "mealType" : game.category]
        
        db.collection("gameContainer").document(gameUID).setData(gameDictionary)
    }
    
    func createUser(user: User) {
        let userDictionary: [String : Any] = ["id" : user.id,
                                              "firstName" : user.firstName,
                                              "lastName" : user.lastName,
                                              "email" : user.email]
        
        db.collection("userContainer").document("user").setData(userDictionary)
    }
    
//    func fetchUser(user: User) {
//        db.collection("userContainer").getDocuments { (querySnapshot, error) in
//            if let error = error {
//                print("Error getting users: \(error)")
//            } else {
//                var userArray: [User] = []
//                for document in querySnapshot!.documents {
//                    let user = User(credentials: credentials.user)
//                }
//            }
//            
//        }
//    }
}//End of Class
