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
//            if game.submittedVotes.count + 1 == game.users.count {
//                //                _ = Firebase.shared.finishedVotes
//                self.findMatches()
//            } else {
//                print("Still waiting for everyone to finish")
//            }
        }
    }
    
    func findMatches() {
        var restaurantVotes: [String : Int] = [:]
        let voteValues = [Firebase.shared.votes]
        
        for personsVotes in voteValues {
            for restaurant in personsVotes {
                if restaurantVotes[restaurant] != nil {
                    restaurantVotes[restaurant]! += 1
                } else {
                    restaurantVotes[restaurant] = 1
                }
            }
        }
        print("VOTE DICTIONARY: \(restaurantVotes)")
    }
}// End of class

/*
 
 RESULTSVC VOTE VALUES: [["[\"The Park Café\", \"Pulp Lifestyle Kitchen-Downtown\", \"Bruges Belgian Bistro\", \"The Original Pancake House - Sugarhouse\", \"Hruska\\\'s Kolaches\", \"Even Stevens Sandwiches\"]", "[\"The Park Café\", \"Sweet Lake Biscuits & Limeade\", \"Pig & a Jelly Jar\", \"Bruges Belgian Bistro\", \"Hruska\\\'s Kolaches\"]"]]
 
 
 PERSONS VOTES: ["[\"The Park Café\", \"Pulp Lifestyle Kitchen-Downtown\", \"Bruges Belgian Bistro\", \"The Original Pancake House - Sugarhouse\", \"Hruska\\\'s Kolaches\", \"Even Stevens Sandwiches\"]", "[\"The Park Café\", \"Sweet Lake Biscuits & Limeade\", \"Pig & a Jelly Jar\", \"Bruges Belgian Bistro\", \"Hruska\\\'s Kolaches\"]"]
 
 
 RESTAURANT: ["The Park Café", "Pulp Lifestyle Kitchen-Downtown", "Bruges Belgian Bistro", "The Original Pancake House - Sugarhouse", "Hruska\'s Kolaches", "Even Stevens Sandwiches"]
 
 
 RESTAURANT: ["The Park Café", "Sweet Lake Biscuits & Limeade", "Pig & a Jelly Jar", "Bruges Belgian Bistro", "Hruska\'s Kolaches"]
 */
