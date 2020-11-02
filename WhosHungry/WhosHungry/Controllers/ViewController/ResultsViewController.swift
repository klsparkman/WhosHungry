//
//  ResultsViewController.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 10/27/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    
    let restaurant = SwipeScreenViewController.shared.displayedRestaurants
    let vote = SwipeScreenViewController.shared.restaurantVotes
    var voteDictionary = SwipeScreenViewController.shared.voteDictionary

    override func viewDidLoad() {
        super.viewDidLoad()
        compareArray(restaurant: restaurant, vote: vote)
    }
    
    private func compareArray(restaurant: [String], vote: [Bool]) {
        for i in 0 ..< restaurant.count {
            if vote[i] == true {
                let name = restaurant[i]
                if let _ = voteDictionary[name] {
                    // case 1: the key already exists
                    voteDictionary[name]! += 1
                } else {
                    // case 2: we're adding a key for the first time
                    voteDictionary[name] = 1
                }
                print("Votes: \(voteDictionary)")
            }
        }
    }

}// End of class
