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
    var voteCount = Firebase.shared.voteCount
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
                Firebase.shared.stopListener()
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
        findHighestVotes()
    }
    
    func findHighestVotes() {
        var agreedUponPlaces: [String] = []
        let halfVotes = playerCount % 2
        
        for (key, value) in restaurantVotes {
            if value == playerCount {
                agreedUponPlaces.append(key)
            } else {
                continue
            }
            if value < halfVotes {
                print("Need to revote?")
            }
        }
        restaurantRestultLabel.text = agreedUponPlaces.randomElement()
        print("AGREED UPON PLACES: \(agreedUponPlaces)")
    }
}// End of class
