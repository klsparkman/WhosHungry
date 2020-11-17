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

@objc protocol VotesSubmittedListener: AnyObject {
    func allVotesAreSubmitted(isSubmitted: Bool)
}

class Firebase {
    
    // Mark: - Properties
    static let shared = Firebase()
    let db = Firestore.firestore()
    var navigationController: UINavigationController?
    var users: [User] = []
    var currentGame: Game?
    private var listener: ListenerRegistration?
    var finishedVotes: [String] = []
    
    // Mark: - CRUD
    func createGame(game: Game, completion: @escaping (Result<Game, Error>) -> Void) {
        let gameDictionary: [String : Any] = [Constants.uid : game.uid,
                                              Constants.inviteCode : game.inviteCode,
                                              Constants.city : game.city,
                                              Constants.radius : game.radius,
                                              Constants.mealType : game.mealType,
                                              Constants.users : game.users,
                                              Constants.submittedVotes : game.submittedVotes,
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
                completion(.success(game))
            }
        }
    }
    
    // Mark: - Listener
    func startListener(completion: @escaping () -> Void) {
        guard let currentGame = currentGame else {return}
        
        db.collection(Constants.gameContainer).document(currentGame.uid).addSnapshotListener { (documentSnapshot, error) in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document was empty")
                return
            }
            
//            for _ in data {
//
//                var values = data.values
//                var restaurants = values[Constants.submittedVotes]
//
//                let likedRestaurants = data[Constants.submittedVotes]
//                let voteSet = Set([likedRestaurants])
//                print("LIKED RESTAURANTS: \(likedRestaurants)")
//            }
            
            let voteValues = data[Constants.submittedVotes] as? [String]
            let voteSet = Set(voteValues!)
            
//            let voteSet: Set = voteValues as? Set<String> ?? [""]
            print("VOTE SET: \(voteSet)")
            self.finishedVotes.append(contentsOf: voteSet)
            completion()
        }
    }
        
            
            //            let voteDict = data.compactMap( { $0.key } )
            //            print("Vote Dictionary: \(voteDict)")
//            print("VOTE VALUES: \(voteValues)")
//            guard let submittedRestVotes = data.removeValue(forKey: Constants.submittedVotes) else {return}
            
//            let peoplesVotes = submittedRestVotes as? [[String]]
//            let peoplesVotes = submittedRestVotes as? String
//            let voteSet = Set(arrayLiteral: peoplesVotes.map {$0})
//            for votes in submittedRestVotes {
//                print("Here are the votes in the voteSet \(votes)")
//                self.finishedSubVotes = votes
//            }
//            print("current data: \(voteSet)")
//            print(voteSet.count + 1)
            
//
//        db.collection(Constants.gameContainer).document(currentGame.uid).collection("\(currentGame.submittedVotes)").addSnapshotListener { (documentSnapshot, error) in
//            guard let document = documentSnapshot else {
//                print("Error fetching submittedVotes: \(error!)")
//                return
//            }
//            guard let data = document.data() else {
//                print("Document data was empty.")
//                return
//            }
//            completion()
//        }
    
    func stopListener() {
        guard let listener = listener else {return}
        listener.remove()
        print("Firebase.swift stopped listening")
    }
    
}//End of Class




//    func getUserCollection(currentGame: Game) {
//        let docRef = db.collection(Constants.gameContainer).document(currentGame.uid)
//        docRef.getDocument(source: .cache) { (document, error) in
//            if let document = document, document.exists {
//                let property = document.get(Constants.users)
//                print("Document data: \(property!)")
//            } else {
//                print("Document does not exist in cache")
//            }
//        }
//    }

//    func fetchUsersWithListeners(game: Game, completion: @escaping (Result<User?, UserError>) -> Void) {
//        db.collection(Constants.gameContainer).document(game.uid).addSnapshotListener { (documentSnapshot, error) in
//            guard let document = documentSnapshot else {
//                print("Error fetching document: \(String(describing: error))")
//                completion(.failure(.firebaseError(error!)))
//                return
//            }
//            guard let data = document.data() else {
//                completion(.failure(.noData))
//                return
//            }
////            let user = data
////            print("Current data: \(data)")
//            completion(.success(nil))
//        }
//    }

//    func listenForSubmittedVotes(gameUID: String, completion: @escaping (Result<Game?, GameError>) -> Void) {
//        db.collection(Constants.gameContainer).document(gameUID).addSnapshotListener { (documentSnapshot, error) in
//            guard let document = documentSnapshot else {
//                print("There was an error fetching document: \(error!)")
//
//                return completion(.failure(.firebaseError(error!)))
//            }
//            guard let data = document.data() else {
//                print("The document data was empty")
//                return completion(.failure(.noData))
//            }
//            ResultsViewController.shared.snapshotListenerData = data
//            return completion(.success(nil))
//            //            print("Current data: \(data)")
//        }
//    }
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




//current data: ["submittedVotes": <__NSArrayM 0x283b04cf0>(["UTOG Brewing", "Sonora Grill", "Tona", "Aroy-D Thai Cuisine", "Hanamaru", "The Yes Hell"]),
//
//"inviteCode": A5DmsA2Stc,
//
//"mealType": dinner,
//
//"radius": 5,
//
//"users": <__NSArrayM 0x283b046c0>(Kelsey Sparkman),
//
//"uid": F8CE868C-48E4-4C2E-869B-C9AAFCB67748,
//
//"city": Ogden, UT, USA]
