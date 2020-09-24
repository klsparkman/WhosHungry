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
    
    // Mark: - Properties
    static let shared = Firebase()
    let db = Firestore.firestore()
    var userInviteCode: [Any] = []
    var navigationController: UINavigationController?
    
    func createGame(game: Game, completion: @escaping (Result<Game, Error>) -> Void) {
        let gameUID = UUID().uuidString
        let gameDictionary: [String : Any] = [Constants.inviteCode : game.inviteCode,
                                              Constants.users : game.users,
                                              Constants.city : game.city,
                                              Constants.radius : game.radius,
                                              Constants.mealType : game.category,
                                              Constants.creatorID : game.creatorID]
        
        db.collection(Constants.gameContainer).document(gameUID).setData(gameDictionary) { (error) in
            if let error = error {
                print("There was an error creating a game: \(error)")
                return
            } else {
                print("Successfully created a game!")
                //Segue to UserListTableViewController
            }
        }
    }
    
    func createUser(with user: User, completion: @escaping (Result<User?, Error>) -> Void) {
        let userDictionary: [String : Any] = [Constants.firstName : user.firstName,
                                              Constants.lastName : user.lastName,
                                              Constants.email : user.email,
                                              Constants.uid : user.uid]

        db.collection(Constants.userContainer).addDocument(data: userDictionary) { (error) in
            if let error = error {
                print("There was an error creating a user: \(error)")
                return
            } else {
                print("Successfully created a user!")
            }
        }
    }
    
    func fetchUser(withID id: String, completion: @escaping (Result<User?, Error>) -> Void) {
        db.collection(Constants.userContainer).whereField(Constants.uid, isEqualTo: id).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                print("Error getting documents: \(error)")
            } else if let firstDocument = querySnapshot?.documents.first {
                let user = User(dictionary: firstDocument.data())
                completion(.success(user))
            } else {
                let user = User(dictionary: <#T##[String : Any]#>)
                completion(.success(user))
            }
        }
    }
    
//    func getUserCollection() {
//        getInviteCodeDocument()
//        db.collection(Constants.gameContainer).whereField(Constants.inviteCode, isEqualTo: userInviteCode)
//            .getDocuments { (querySnapshot, error) in
//                if let error = error {
//                    print("Error getting documents: \(error)")
//                } else {
//                    guard let snapshot = querySnapshot else {return}
//                    for document in snapshot.documents {
//                        let data = document.data()
//                        let firstName = data[Constants.firstName] as? String ?? "Who dis?"
//                        let lastName = data[Constants.lastName] as? String ?? ""
//
//                        let user = UserInfo(firstName: firstName, lastName: lastName)
//                        RestaurantController.shared.users.append(user)
//                    }
//                }
//        }
//    }
    
//    private func getInviteCodeDocument() {
//        db.collection(Constants.userContainer).document(Constants.user).getDocument { (document, error) in
//            if let document = document, document.exists {
//                guard let code = document.get(Constants.inviteCode) else {return}
//                self.userInviteCode.append(code)
//            } else {
//                print("Document doesn not exist")
//            }
//        }
//    }
}//End of Class
