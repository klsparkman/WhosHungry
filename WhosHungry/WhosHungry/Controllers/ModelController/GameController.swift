//
//  GameController.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 10/1/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import Foundation
import Firebase

class GameController: NSObject {
    
    // Mark: - Properties
    static var shared = GameController()
    var currentGame: Game?
    let db = Firestore.firestore()
 
    private override init() {
        super.init()
    }
    
    func addUserToGame(inviteCode: String) {
        //Go to Firestore and see if the invite code matches a game
        Firebase.shared.fetchGame(withinviteCode: inviteCode) { (result) in
            switch result {
            //If it doesn't match a game, show an error
            case .failure(let error):
                print("There was an error fetching the game in Firestore: \(error)")
            //If there is a game that matches, add the user to the [User] in the game
            case .success(_):
                guard let currentUser = UserController.shared.currentUser?.firstName else {return}
                self.db.collection(Constants.gameContainer).document(Constants.users).updateData([Constants.users : currentUser])
            }
        }
    }
}//End of Class
