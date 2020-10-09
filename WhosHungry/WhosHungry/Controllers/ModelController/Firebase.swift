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
    var users: [User] = []
    
    func createGame(game: Game, completion: @escaping (Result<Game, Error>) -> Void) {
        let gameUID = UUID().uuidString
        let gameDictionary: [String : Any] = [Constants.inviteCode : game.inviteCode,
                                              Constants.users : game.users,
                                              Constants.city : game.city,
                                              Constants.radius : game.radius,
                                              Constants.mealType : game.mealType]
//                                              Constants.creatorID : game.creatorID
        
        db.collection(Constants.gameContainer).document(gameUID).setData(gameDictionary) { (error) in
            if let error = error {
                print("There was an error creating a game: \(error)")
                completion(.failure(error))
            } else {
                print("Successfully created a game!")
                completion(.success(game))
            }
        }
    }
    
    func createUser(with firstName: String, lastName: String, email: String, uid: String, completion: @escaping (Result<User?, UserError>) -> Void) {
        let userDictionary: [String : Any] = [Constants.firstName : firstName,
                                              Constants.lastName : lastName,
                                              Constants.email : email,
                                              Constants.uid : uid]

        db.collection(Constants.userContainer).addDocument(data: userDictionary) { (error) in
            if let error = error {
                print("There was an error creating a user: \(error)")
                completion(.failure(.firebaseError(error)))
            } else {
                let user = User(dictionary: userDictionary)
                completion(.success(user))
            }
        }
    }
    
    func fetchUser(withID id: String, completion: @escaping (Result<User?, FirebaseError>) -> Void) {
        db.collection(Constants.userContainer).whereField(Constants.uid, isEqualTo: id).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(.failure(.fbError(error)))
            } else if let firstDocument = querySnapshot?.documents.first {
                guard let user = User(dictionary: firstDocument.data()) else {return}
                completion(.success(user))
            } else {
                completion(.success(nil))
            }
        }
    }
    
    func fetchGame(withinviteCode inviteCode: String, completion: @escaping (Result<Game?, GameError>) -> Void) {
        db.collection(Constants.gameContainer).whereField(Constants.inviteCode, isEqualTo: inviteCode).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(.failure(.firebaseError(error)))
            } else {
//                guard let game = Game(inviteCode: inviteCode) else {return}
                completion(.success(nil))
            }
        }
    }
    
    func getUserCollection() {
        db.collection(Constants.gameContainer).whereField(Constants.users, isEqualTo: true)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    guard let snapshot = querySnapshot else {return}
                    for document in snapshot.documents {
                        let user = User(firstName: (document.data()[Constants.firstName] as? String ?? ""),
                                        lastName: (document.data()[Constants.lastName] as? String ?? ""),
                                        email: (document.data()[Constants.email] as? String ?? ""),
                                        uid: (document.data()[Constants.uid] as? String ?? ""))

                        RestaurantController.shared.users.append(user)
                    }
                }
        }
    }
    
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
