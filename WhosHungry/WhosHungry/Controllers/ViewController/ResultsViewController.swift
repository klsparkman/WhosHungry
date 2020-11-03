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

    override func viewDidLoad() {
        super.viewDidLoad()
        findHighestVotedRestaurant()
    }
    
    private func findHighestVotedRestaurant() {
        for totals in self.voteDict.values {
            if totals == RestaurantController.shared.users.count {
                print("TOTALS: \(voteDict.keys) : \(totals)")
            }
        }
    }
}// End of class
