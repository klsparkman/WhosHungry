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
        let gameDictionary: [String : Any] = [Constants.inviteCode : game.inviteCode,
                                              Constants.users : game.users,
                                              Constants.city : game.city,
                                              Constants.radius : game.radius,
                                              Constants.mealType : game.category]
        
        db.collection(Constants.gameContainer).document(gameUID).setData(gameDictionary)
    }
    
    func createUser(user: User) {
        let userDictionary: [String : Any] = [Constants.id : user.id,
                                              Constants.firstName : user.firstName,
                                              Constants.lastName : user.lastName,
                                              Constants.email : user.email,
                                              Constants.inviteCode : user.inviteCode]
        
        db.collection(Constants.userContainer).document(Constants.user).setData(userDictionary)
    }
    
    func getUserCollection() {
        getInviteCodeDocument()
        db.collection(Constants.gameContainer).whereField(Constants.inviteCode, isEqualTo: userInviteCode)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    guard let snapshot = querySnapshot else {return}
                    for document in snapshot.documents {
                        let data = document.data()
                        let firstName = data[Constants.firstName] as? String ?? "Who dis?"
                        let lastName = data[Constants.lastName] as? String ?? ""

                        let user = UserInfo(firstName: firstName, lastName: lastName)
                        RestaurantController.shared.users.append(user)
                    }
                }
        }
    }
    
    private func getInviteCodeDocument() {
        db.collection(Constants.userContainer).document(Constants.user).getDocument { (document, error) in
            if let document = document, document.exists {
                guard let code = document.get(Constants.inviteCode) else {return}
                self.userInviteCode.append(code)
            } else {
                print("Document doesn not exist")
            }
        }
    }
}//End of Class
