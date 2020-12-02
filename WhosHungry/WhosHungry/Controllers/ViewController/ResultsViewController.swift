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
    var likes: [String] = []
    var result: Int?
    
    @IBOutlet weak var restaurantRestultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Firebase.shared.listenForLikes { (result) in
            self.likes = []
            self.result = result.count
            print("RESULT COUNT: \(result.count)")
            for vote in result {
                self.likes.append(vote)
            }
            print("LIKES: \(self.likes)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
        let players = Firebase.shared.playerCount
        if players ==  result {
            self.findMatches()
        } else {
            print("Still waiting for everyone to finish swiping")
        }
    }
    
    func findMatches() {
        var restaurantVotes: [String : Int] = [:]
        let voteValues = self.likes
//        let voteValues = [Firebase.shared.votes]
        
        for personsVotes in voteValues {
//            for restaurant in personsVotes {
                if restaurantVotes[personsVotes] != nil {
                    restaurantVotes[personsVotes]! += 1
                } else {
                    restaurantVotes[personsVotes] = 1
                }
//            }
        }
        print("VOTE DICTIONARY: \(restaurantVotes)")
    }
}// End of class
