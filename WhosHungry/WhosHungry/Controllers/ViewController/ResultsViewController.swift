//
//  ResultsViewController.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 10/27/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    
    // Mark: - Properties
    static let shared = ResultsViewController()
    var likedRestDict: [String : Int] = [:]
    var likes: [String] = []
    var result: Int?
    var playerCount = Firebase.shared.playerCount!
    var voteCount = Firebase.shared.voteCount!
    var restaurantVotes: [String : Int] = [:]
    
    // Mark: - Outlets
    @IBOutlet weak var restaurantRestultLabel: UILabel!
    
    // Mark: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        Firebase.shared.listenForLikes { (arrOfLikes) in
            self.likes = []
            for restaurant in arrOfLikes {
                self.likes.append(restaurant)
            }
            if self.playerCount == self.voteCount {
                self.findMatches()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
    }
    
    func findMatches() {
        let voteValues = self.likes
        
        for personsVotes in voteValues {
            if restaurantVotes[personsVotes] != nil {
                restaurantVotes[personsVotes]! += 1
            } else {
                restaurantVotes[personsVotes] = 1
            }
        }
        print("VOTE DICTIONARY: \(restaurantVotes)")
    }
    
    func findHighestVotes() {
        let halfVotes = playerCount % 2
        for (key, value) in restaurantVotes {
            if value == playerCount {
                print("Everyone voted for this restaurant: \(key)")
                
            }
            if value == halfVotes {
                print("Half of the players voted for these places: \(key)")
            }
            if value < playerCount {
                print("Need to revote!")
            }
        }
    }
    
}// End of class
