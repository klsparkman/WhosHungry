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
    var likedRestDict: [String : Int] = [:]
    
    @IBOutlet weak var restaurantRestultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
        Firebase.shared.startListener {
            guard let game = Firebase.shared.currentGame else {return}
            if game.submittedVotes.count + 1 == game.users.count {
                //                _ = Firebase.shared.finishedVotes
                self.findMatches()
            } else {
                print("Still waiting for everyone to finish")
            }
        }
    }
    
    func findMatches() {
        var voteDict: [String : Int] = [:]
        let testVoteValues = [Firebase.shared.votes]
        print("TEST VOTE VALUES: \(testVoteValues)")
        
        for personsVotes in testVoteValues {
            for restaurant in personsVotes {
                if voteDict[restaurant] != nil {
                    voteDict[restaurant]! += 1
                } else {
                    voteDict[restaurant] = 1
                }
            }
            print("VOTE DICTIONARY: \(voteDict)")
        }
    }
}// End of class

/*
 
 VOTE VALUES: ["[\"The Park Café\", \"Pulp Lifestyle Kitchen-Downtown\", \"Bruges Belgian Bistro\", \"The Original Pancake House - Sugarhouse\", \"Hruska\\\'s Kolaches\", \"Even Stevens Sandwiches\"]"]
 */
