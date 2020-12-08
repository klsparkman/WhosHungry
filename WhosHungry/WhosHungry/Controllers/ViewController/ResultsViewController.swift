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
    var playerCount = Firebase.shared.playerCount!
    var voteCount = Firebase.shared.voteCount!
    
    @IBOutlet weak var restaurantRestultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.playerCount == self.voteCount {
            
        }
        Firebase.shared.listenForLikes { (arrOfLikes) in
            self.likes = []
            for restaurant in arrOfLikes {
                self.likes.append(restaurant)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        Firebase.shared.listenForLikes { (result) in
//            self.likes = []
//            for vote in result {
//                self.likes.append(vote)
//            }
//            if self.playerCount == self.voteCount {
//                self.findMatches()
//            } else {
//                print("Still waiting for everyone to finish swiping")
//            }
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
    }
    
    func findMatches() {
        var restaurantVotes: [String : Int] = [:]
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
}// End of class
