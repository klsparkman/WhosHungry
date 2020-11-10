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
    var submittedVoteArray: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        comparingSubmittedVotes()
        submittedVoteArray = SwipeScreenViewController.shared.likedRestaurants
        print(submittedVoteArray)
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
                            
                            for votes in game.submittedVotes {
                                
                            }
                            
                            print("Here are the submitted votes: \(game.submittedVotes)")
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    
    
}// End of class
