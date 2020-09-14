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
    var userInviteCode: [Any] = []
    
    func createGame(game: Game) {
        let gameUID = UUID().uuidString
        let gameDictionary: [String : Any] = ["inviteCode" : game.inviteCode,
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
                                              "email" : user.email,
                                              "inviteCode" : user.inviteCode]
        
        db.collection("userContainer").document("user").setData(userDictionary)
    }
    
    func getUserCollection() {
        getInviteCodeDocument()
        db.collection("gameContainer").whereField("inviteCode", isEqualTo: userInviteCode)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    for users in querySnapshot!.documents {
                        let user = User(inviteCode: users.data())
                        print("\(users.documentID) => \(users.data())")
                        RestaurantController.shared.users.append(user)
                    }
                }
        }
    }
    
    private func getInviteCodeDocument() {
        db.collection("userContainer").document("user").getDocument { (document, error) in
            if let document = document, document.exists {
                guard let code = document.get("inviteCode") else {return}
                self.userInviteCode.append(code)
            } else {
                print("Document doesn not exist")
            }
        }
    }
}//End of Class
