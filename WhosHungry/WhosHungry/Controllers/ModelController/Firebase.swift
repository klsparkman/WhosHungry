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
    var currentGame: Game?
    
    func createGame(game: Game, completion: @escaping (Result<Game, Error>) -> Void) {
//        let gameUID = UUID().uuidString
        let gameDictionary: [String : Any] = [Constants.inviteCode : game.inviteCode,
                                              Constants.users : game.users,
                                              Constants.city : game.city,
                                              Constants.radius : game.radius,
                                              Constants.mealType : game.mealType,
                                              Constants.submittedVotes : game.submittedVotes]
        //                                              Constants.creatorID : game.creatorID
        
        db.collection(Constants.gameContainer).document(game.uid).setData(gameDictionary) { (error) in
            if let error = error {
                print("There was an error creating a game: \(error)")
                completion(.failure(error))
            } else {
                print("Successfully created a game!")
                self.currentGame = game
//                self.gameUID = gameUID
                completion(.success(game))
            }
        }
    }
    
    func addUserToGame(inviteCode: String) {
        //Go to Firestore and see if the invite code matches a game
        Firebase.shared.fetchGame(withinviteCode: inviteCode) { (result) in
            switch result {
            //If it doesn't match a game, show an error
            case .failure(let error):
                print("There was an error fetching the game in Firestore: \(error)")
            //If there is a game that matches, add the user to the [User] in the game
            case .success(let game):
                print("We found a game that matches that invite code")
                //Get the documentID that matches the game with the given inviteCode
                guard let currentUser = UserController.shared.currentUser else {return}
                guard let game = game else {return}
                let userRef = self.db.collection(Constants.gameContainer).document("\(game.uid)")
                userRef.updateData([Constants.users : FieldValue.arrayUnion(["\(currentUser.firstName + " " + currentUser.lastName)"])
                ])
            }
        }
    }
                
                
                
            //                self.fetchGame(withinviteCode: inviteCode) { (result) in
            //                    switch result {
            //                    case .failure(let error):
            //                        print("There was an error fetching this game: \(error.localizedDescription)")
            //                    case .success(let game):
            //
            //                    }
            //                }
                
//                Firebase.shared.getGameUID(inviteCode: inviteCode) { (result) in
//                    switch result {
//                    //There was an error getting the documentID
//                    case .failure(let error):
//                        print("Error: \(error)")
//                    //Successfully grabbed the documentID, add to the users field within the given document
//                    case .success(let gameUID):
////                        SwipeScreenViewController.shared.gameUID?.append(gameUID)
//                        SwipeScreenViewController.shared.gameUID = gameUID
//                        guard let currentUser = UserController.shared.currentUser else {return}
//                        let userRef = self.db.collection(Constants.gameContainer).document(gameUID)
//                        userRef.updateData([Constants.users : FieldValue.arrayUnion(["\(currentUser.firstName + " " + currentUser.lastName)"])
//                        ])
//                    }
//                }
    
    // Mark: - Get a game with an invite code, no need for gameUID
//    func getGameUID(inviteCode: String, completion: @escaping (Result<String, GameError>) -> Void) {
//        self.db.collection(Constants.gameContainer).whereField(Constants.inviteCode, isEqualTo: inviteCode).getDocuments { (querySnapshot, error) in
//            if let error = error {
//                print("There was an error getting the gameUID: \(error.localizedDescription)")
//                completion(.failure(.firebaseError(error)))
//            } else {
//                for document in querySnapshot!.documents {
//                    let gameUID = document.documentID
//                    //take data from snapshot and turn into game
//                    //Should complete with a game
//                    completion(.success(gameUID))
//                }
//            }
//        }
//    }
    
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
                completion(.success(nil))
            }
        }
    }
    
    func getUserCollection() {
        let docRef = db.collection(Constants.gameContainer).document("76D04883-709C-4E67-BB1A-E37CB652A899")
        
        docRef.getDocument(source: .cache) { (document, error) in
            if let document = document, document.exists {
                let property = document.get(Constants.users)
                print("Document data: \(property)")
            } else {
                print("Document does not exist in cache")
            }
        }
    }
    
    //    func getUsersField() {
    //        db.collection(Constants.gameContainer).document(Constants.users).getDocument { (querySnapshot, error) in
    //            if let error = error {
    //                print("There was an error getting the users list: \(error)")
    //            } else {
    //                for document in querySnapshot! {
    //
    //                }
    //            }
    //        }
    //    }
    
}//End of Class
