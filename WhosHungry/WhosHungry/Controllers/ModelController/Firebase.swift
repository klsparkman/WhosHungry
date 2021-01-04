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
    var navigationController: UINavigationController?
    var users: [User] = []
    var currentGame: Game?
    private var listener: ListenerRegistration?
    var votes: [String] = []
    var playerCount: Int?
    var voteCount: Int?
    
    // Mark: - CRUD
    func createGame(game: Game, completion: @escaping (Result<Game, Error>) -> Void) {
        let gameDictionary: [String : Any] = [Constants.uid : game.uid,
                                              Constants.inviteCode : game.inviteCode,
                                              Constants.city : game.city,
                                              Constants.radius : game.radius,
                                              Constants.mealType : game.mealType,
                                              Constants.users : game.users,
                                              Constants.gameHasBegun : game.gameHasBegun
        ]
        
        db.collection(Constants.gameContainer).document(game.uid).setData(gameDictionary) { (error) in
            if let error = error {
                print("There was an error creating a game: \(error)")
                completion(.failure(error))
            } else {
                print("Successfully created a game!")
                self.currentGame = game
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
    
    func updateUserList(inviteCode: String) {
        //Go to Firestore and see if the invite code matches a game
        Firebase.shared.fetchGame(withinviteCode: inviteCode) { (result) in
            switch result {
            //If it doesn't match a game, show an error
            case .failure(let error):
                print("There was an error fetching the game in Firestore: \(error)")
            //If there is a game that matches, add the user to the [User] in the game
            case .success(let game):
                //Get the documentID that matches the game with the given inviteCode
                guard let currentUser = UserController.shared.currentUser else {return}
                guard let game = game else {return}
                self.currentGame = game
                let userRef = self.db.collection(Constants.gameContainer).document("\(game.uid)")
                userRef.updateData([Constants.users : FieldValue.arrayUnion(["\(currentUser.firstName + " " + currentUser.lastName)"])
                ])
            }
        }
    }
                
    // Mark: - Fetches
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
            } else if let snapshot = querySnapshot?.documents.first {
                guard let game = Game(dictionary: snapshot.data()) else {return}
                self.currentGame = game
                completion(.success(game))
            }
        }
    }
    
    // Mark: - Listener
    func listenForLikes(completion: @escaping ([String]) -> Void) {
        guard let currentGame = currentGame else {return}
        guard let user = UserController.shared.currentUser else {return}
        listener = db.collection(Constants.gameContainer).document(currentGame.uid).collection(Constants.usersVotes).document(user.firstName + " " + user.lastName).addSnapshotListener { (documentSnapshot, error) in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document was empty")
                return
            }
                        
            let voteValues = data[Constants.submittedVotes]
            let votes = voteValues as? [String] ?? []
            
            if self.voteCount != nil {
                self.voteCount! += 1
            } else {
                self.voteCount = 1
            }
            print("Vote Count: \(self.voteCount!)")
            
            completion(votes)
        }
    }
    
    func listenForUsers(completion: @escaping ([String]) -> Void) {
        guard let game = currentGame else {return}
        listener = db.collection(Constants.gameContainer).document(game.uid).addSnapshotListener { (documentSnapshot, error) in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty")
                return
            }
            let result = data[Constants.users]
            let players = result as? [String] ?? []
            
            if self.playerCount != nil {
                self.playerCount! += 1
            } else {
                self.playerCount = 1
            }
            completion(players)
//            print("Player count: \(self.playerCount!)")
        }
    }
    
    func stopListener() {
        guard let listener = listener else {return}
        listener.remove()
        print("Firebase.swift stopped listening")
    }

    func createUserVoteCollection(userVote: [String], completion: @escaping (Result<[String], FirebaseError>) -> Void) {
        guard let game = currentGame else {return}
        let voteDictionary: [String : Any] = [Constants.submittedVotes : userVote]
        guard let user = UserController.shared.currentUser else {return}
        db.collection(Constants.gameContainer).document(game.uid).collection(Constants.usersVotes).document("\(user.firstName + " " + user.lastName)").setData(voteDictionary) { (error) in
            if let error = error {
                print("There was an error saving users votes to Firestore: \(error.localizedDescription)")
                completion(.failure(.fbError(error)))
            } else {
                print("Successfully saved users votes!")
                completion(.success(userVote))
            }
        }
    }
    
    func checkGameStatus(completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let game = currentGame else {return}
        db.collection(Constants.gameContainer).document(game.uid).getDocument { (documentSnapshot, error) in
            if let error = error {
                print("Error fetching the document data: \(error.localizedDescription)")
            } else {
                guard let snapshot = documentSnapshot?.data() else {return}
                let gameStatus = snapshot[Constants.gameHasBegun] as! Bool
                if gameStatus == true {
                    completion(.success(true))
                } else {
                    completion(.success(false))
                }
            }
        }
    }
    
    func startGame() {
        guard let game = currentGame else {return}
        db.collection(Constants.gameContainer).document(game.uid).getDocument { (documentSnapshot, error) in
            if let error = error {
                print("There was an error fetching the current document data: \(error.localizedDescription)")
            } else {
                let beginGame = self.db.collection(Constants.gameContainer).document(game.uid)
                guard let snapshot = documentSnapshot?.data() else {return}
                let gameBool = snapshot[Constants.gameHasBegun] as! Bool
                if gameBool == false {
                    beginGame.updateData([Constants.gameHasBegun : true])
                }
            }
        }
    }
    
    func listenForStartGame(completion: @escaping (Bool) -> Void) {
        guard let game = currentGame else {return}
        listener = db.collection(Constants.gameContainer).document(game.uid).addSnapshotListener { (documentSnapshot, error) in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty")
                return
            }
            let result = data[Constants.gameHasBegun]
            let startGame = result as! Bool
            completion(startGame)
        }
    }
    
    func stopGame() {
        guard let game = currentGame else {return}
        db.collection(Constants.gameContainer).document(game.uid).getDocument { (documentSnapshot, error) in
            if let error = error {
                print("There was an error fetching the current document data: \(error.localizedDescription)")
            } else {
                let beginGame = self.db.collection(Constants.gameContainer).document(game.uid)
                guard let snapshot = documentSnapshot?.data() else {return}
                let gameBool = snapshot[Constants.gameHasBegun] as! Bool
                if gameBool == true {
                    beginGame.updateData([Constants.gameHasBegun : false])
                }
            }
        }
    }
}//End of Class
