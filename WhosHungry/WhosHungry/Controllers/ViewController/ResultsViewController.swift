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
                _ = Firebase.shared.finishedVotes
//                print("FINAL VOTES: \(votes)")
//                self.findMatchingRestaurants()
                self.findMatches()
            } else {
                print("Still waiting for everyone to finish")
            }
        }
    }
    
    func findMatches() {
        guard let voteSet: Set = Firebase.shared.finishedVotes else {return}
//        var voteDict: [String : Int] = [:]
        print("Vote set: \(voteSet)")
//        let firstSet = voteSet.remove(at: voteSet.index(after: Set<voteSet>[1]))
        
        let firstIntersect = voteSet.intersection(voteSet)
        print("FIRST INTERSECTION: \(firstIntersect)")
        
//        for restaurants in voteSet {
//            let array = restaurants
//            var counts: [String : Int] = [:]
//
//            for restaurant in array {
//
//                var arrayOfLetters = restaurant[0].map(String.init)
//
//                counts[restaurant] = (counts[restaurant] ?? 0) + 1
//            }
//        }
        
//        for restaurant in voteSet {
//            if restaurant == restaurant {
//                voteDict[restaurant] = 1
//            } else {
//                voteDict[restaurant]! += 1
//            }
//            print("VOTE DICTIONARY: \(voteDict)")
//        }
    }
    
//    func findMatchingRestaurants() {
//        let arr = Firebase.shared.finishedVotes
//        var counts: [String : Int] = [:]
//
//        for item in arr {
//            counts[item] = (counts[item] ?? 0) + 1
//        }
//
//        for (key, value) in counts {
//            print("\(key) occurs \(value) time(s)")
//        }
//    }
    
    
//    private func compareArray() {
//        for i in 0 ..< displayedRestaurants.count {
//            if restaurantVote[i] == true {
//                let name = displayedRestaurants[i]
//                likedRestaurants.append(name)
//                if let _ = voteDictionary[name] {
//                    // case 1: the key already exists
//                    voteDictionary[name]! += 1
//                } else {
//                    // case 2: we're adding a key for the first time
//                    voteDictionary[name] = 1
//                }
//            }
////            print("Votes: \(voteDictionary)")
//        }
//    }
    
    
//    func comparingSubmittedVotes() {
//        guard let gameUID = Firebase.shared.currentGame?.uid else {return}
//        guard let game = Firebase.shared.currentGame else {return}
//        
//        Firebase.shared.listenForSubmittedVotes(gameUID: gameUID) { (result) in
//            switch result {
//            case .failure(let error):
//                print(error.localizedDescription)
//            case .success(_):
//                Firebase.shared.fetchGame(withinviteCode: game.inviteCode) { (result) in
//                    switch result {
//                    case .success(let game):
//                        if let game = game {
//                            
//                            if game.submittedVotes.count == game.users.count {
//                                
//                                let arrays = game.submittedVotes
//                                print(arrays)
//                                //                            for subarray in arrays {
//                                //                                for element in subarray {
//                                //                                    print(element)
//                                //                                }
//                                //                            }
//                            }
//                            
//                            
//                        }
//                    case .failure(let error):
//                        print(error.localizedDescription)
//                    }
//                }
//            }
//        }
//    }
    
    
    
    
}// End of class
