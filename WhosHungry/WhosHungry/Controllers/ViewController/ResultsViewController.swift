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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func findHighestVotedRestaurant() {
        let votes = SwipeScreenViewController.shared.voteDictionary
        for totals in votes.values {
            if totals == RestaurantController.shared.users.count {
                print(totals)
            }
        }
    }
}// End of class
