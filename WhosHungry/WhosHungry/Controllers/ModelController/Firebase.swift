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
//    var navigationController: UINavigationController?
    
    func createGame(game: Game) {
        let gameUID = UUID().uuidString
        let gameDictionary: [String : Any] = [Constants.inviteCode : game.inviteCode,
                                              Constants.users : game.users,
                                              Constants.city : game.city,
                                              Constants.radius : game.radius,
                                              Constants.mealType : game.category,
                                              Constants.creatorID : game.creatorID]
        
        db.collection(Constants.gameContainer).document(gameUID).setData(gameDictionary)
    }
    
//    func findIfUserExists(user: User) {
//        let user = Auth.auth().currentUser
////        var credential: AuthCredential!
//        let credential = OAuthProvider.credential(withProviderID: "apple.com", , rawNonce: <#T##String?#>)
//        guard let users = user else {return}
//        
//        db.collection(Constants.userContainer).whereField(Constants.uid, isEqualTo: users.uid).getDocuments { (result, error) in
//            if error != nil {
//                print("No user exists")
//                return
//            } else {
//                user?.reauthenticate(with: credential, completion: { (result, error) in
//                    if error != nil {
//                        print("There was an error reauthenticating the user.")
//                        return
//                    } else {
//                        print("The user was reauthenticated.")
//                    }
//                })
//            }
//        }
        
//        db.collection(Constants.userContainer).whereField(Constants.uid, isEqualTo: user.uid).getDocuments { (querySnapshot, error) in
//            if let error = error {
//                print("No user exists yet. \(error)")
//            } else {
//                //segue to GameChoiceVC
//                print("This user exists: \(user.firstName + user.lastName)")
//            }
//        }
//    }
    
//    func createUser(user: User) {
//        let userDictionary: [String : Any] = [Constants.uid : user.uid,
//                                              Constants.firstName : user.firstName,
//                                              Constants.lastName : user.lastName,
//                                              Constants.email : user.email,
//                                              Constants.inviteCode : user.inviteCode]
//
//        self.db.collection(Constants.userContainer).document(Constants.user).setData(userDictionary)
//    }
    
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
