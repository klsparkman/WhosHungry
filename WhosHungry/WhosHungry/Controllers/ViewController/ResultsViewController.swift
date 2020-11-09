//
//  ResultsViewController.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 10/27/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    
    static let shared = ResultsViewController()
    var voteDict: [String : Int] = [:]
    var snapshotListenerData: [String : Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        comparingSubmittedVotes()
    }
    
    //    private func findHighestVotedRestaurant() {
    //        for totals in self.voteDict.values {
    //            if totals != 0 {
    //                if totals == RestaurantController.shared.users.count {
    //                    print("TOTALS: \(voteDict.keys) : \(totals)")
    //                }
    //            } else {
    //                if totals == 0 {
    //                    noRestaurantVote()
    //                }
    //            }
    //        }
    //    }
    
    func comparingSubmittedVotes() {
        guard let gameUID = Firebase.shared.currentGame?.uid else {return}
        guard let game = Firebase.shared.currentGame else {return}
        
        Firebase.shared.listenForSubmittedVotes(gameUID: gameUID) { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(_):
                Firebase.shared.fetchGame(withinviteCode: game.inviteCode) { (result) in
                    switch result {
                    case .success(let game):
                        if let game = game {
                            print("Here are the submitted votes: \(game.submittedVotes)")
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
//                print("Here are the submitted votes: \(game.submittedVotes.count)")
            }
        }
    }
    
    private func noRestaurantVote() {
        let alert = UIAlertController(title: "You didn't like any of these options?", message: "You must swipe right on at least 1 restaurant", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Nevery mind", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}// End of class
