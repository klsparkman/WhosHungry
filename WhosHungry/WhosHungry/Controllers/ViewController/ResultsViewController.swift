//
//  ResultsViewController.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 10/27/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import UIKit
import SAConfettiView

class ResultsViewController: UIViewController {
    
    // Mark: - Properties
    static let shared = ResultsViewController()
    var likedRestDict: [String : Int] = [:]
    var result: Int?
    var playerCount = Firebase.shared.playerCount
    var voteCount = Firebase.shared.voteCount
    let currentGame = Firebase.shared.currentGame
    var restaurantVotes: [String : Int] = [:]
    let generator = UINotificationFeedbackGenerator()
    var likes: [String] = []
    var yelpURL: String?
    let displayedRestaurants = RestaurantController.shared.restaurants
    let currentUser = UserController.shared.currentUser
    var winner: String?
    
    // Mark: - Outlets
    @IBOutlet weak var restaurantRestultLabel: UILabel!
    @IBOutlet weak var winningRestaurantYelpLabel: UILabel!
    @IBOutlet weak var winningRestaurantYelpButton: UIButton!
    @IBOutlet weak var waitForFriendsLabel: UITextView!
    
    // Mark: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.playerCount == 1 {
            waitForFriendsLabel.isHidden = true
        }
        winningRestaurantYelpLabel.isHidden = true
        winningRestaurantYelpButton.isHidden = true
        for restaurant in RestaurantController.shared.restaurants {
            yelpURL?.append(restaurant.restaurantYelpLink)
        }
        guard let game = Firebase.shared.currentGame else {return}
        Firebase.shared.fetchNumberOfUsersVotes(currentGame: game) { (result) in
            if self.playerCount! == result {
                Firebase.shared.allVotesSubmitted()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Firebase.shared.listenForAllVotesSubmitted { (result) in
            if result == true {
                Firebase.shared.stopSubmittedVotesListener()
                guard let game = Firebase.shared.currentGame else {return}
                Firebase.shared.fetchAllSubmittedVotes(currentGame: game) { (result) in
                    self.likes = result
                    self.findMatches()
                }
            }
        }
    }
    
    @IBAction func yelpButtonTapped(_ sender: Any) {
        if let url = URL(string: yelpURL!) {
            UIApplication.shared.canOpenURL(url)
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func findMatches() {
        let voteValues = self.likes
        for personsVote in voteValues {
            if restaurantVotes[personsVote] != nil {
                restaurantVotes[personsVote]! += 1
            } else {
                restaurantVotes[personsVote] = 1
            }
        }
        print("VOTE DICTIONARY: \(restaurantVotes)")
        findHighestVotes()
    }
    
    func findHighestVotes() {
        var agreedUponPlaces: [String] = []
        switch playerCount {
        case 1:
            if playerCount == 1 {
                for (key, value) in restaurantVotes {
                    if value == 1 {
                        agreedUponPlaces.append(key)
                    }
                }
                if agreedUponPlaces != [] {
                    let winner = agreedUponPlaces.randomElement()
                    Firebase.shared.winningRestaurantFound(winningRest: winner!)
                    self.displayWinner(winner: winner!)
//                    generator.notificationOccurred(.success)
                }
            }
        case 2:
            if playerCount == 2 {
                for (key, value) in restaurantVotes {
                    if value >= 2 {
                        agreedUponPlaces.append(key)
                    }
                }
                if agreedUponPlaces != [] {
                    let group = DispatchGroup()
                    group.enter()
                    guard let user = self.currentUser else {return}
                    if user.isGameCreator == true {
                        let winner = agreedUponPlaces.randomElement()
                        self.winner = winner
                        Firebase.shared.winningRestaurantFound(winningRest: winner!)
                        self.displayWinner(winner: winner!)
                        group.leave()
                    } else {
                        Firebase.shared.listenForWinningRest { (result) in
                            self.displayWinner(winner: result)
                        }
                    }
                } else {
                    self.noMatchPopup()
                }
            }
        case 3:
            if playerCount == 3 {
                for (key, value) in restaurantVotes {
                    if value >= 2 {
                        agreedUponPlaces.append(key)
                    }
                }
                if agreedUponPlaces != [] {
                    let group = DispatchGroup()
                    group.enter()
                    guard let user = self.currentUser else {return}
                    if user.isGameCreator == true {
                        let winner = agreedUponPlaces.randomElement()
                        self.winner = winner
                        Firebase.shared.winningRestaurantFound(winningRest: winner!)
                        self.displayWinner(winner: winner!)
                        group.leave()
                    } else {
                        Firebase.shared.listenForWinningRest { (result) in
                            self.displayWinner(winner: result)
                        }
                    }
                } else {
                    self.noMatchPopup()
                }
            }
        case 4:
            if playerCount == 4 {
                for (key, value) in restaurantVotes {
                    if value >= 2 {
                        agreedUponPlaces.append(key)
                    }
                }
                if agreedUponPlaces != [] {
                    let group = DispatchGroup()
                    group.enter()
                    guard let user = self.currentUser else {return}
                    if user.isGameCreator == true {
                        let winner = agreedUponPlaces.randomElement()
                        self.winner = winner
                        Firebase.shared.winningRestaurantFound(winningRest: winner!)
                        self.displayWinner(winner: winner!)
                        group.leave()
                    } else {
                        Firebase.shared.listenForWinningRest { (result) in
                            self.displayWinner(winner: result)
                        }
                    }
                } else {
                    self.noMatchPopup()
                }
            }
        case 5:
            if playerCount == 5 {
                for (key, value) in restaurantVotes {
                    if value >= 3 {
                        agreedUponPlaces.append(key)
                    }
                }
                if agreedUponPlaces != [] {
                    let group = DispatchGroup()
                    group.enter()
                    guard let user = self.currentUser else {return}
                    if user.isGameCreator == true {
                        let winner = agreedUponPlaces.randomElement()
                        self.winner = winner
                        Firebase.shared.winningRestaurantFound(winningRest: winner!)
                        self.displayWinner(winner: winner!)
                        group.leave()
                    } else {
                        Firebase.shared.listenForWinningRest { (result) in
                            self.displayWinner(winner: result)
                        }
                    }
                } else {
                    self.noMatchPopup()
                }
            }
        case 6:
            if playerCount == 6 {
                for (key, value) in restaurantVotes {
                    if value >= 3 {
                        agreedUponPlaces.append(key)
                    }
                }
                if agreedUponPlaces != [] {
                    let group = DispatchGroup()
                    group.enter()
                    guard let user = self.currentUser else {return}
                    if user.isGameCreator == true {
                        let winner = agreedUponPlaces.randomElement()
                        self.winner = winner
                        Firebase.shared.winningRestaurantFound(winningRest: winner!)
                        self.displayWinner(winner: winner!)
                        group.leave()
                    } else {
                        Firebase.shared.listenForWinningRest { (result) in
                            self.displayWinner(winner: result)
                        }
                    }
                } else {
                    self.noMatchPopup()
                }
            }
        case 7:
            if playerCount == 7 {
                for (key, value) in restaurantVotes {
                    if value >= 4 {
                        agreedUponPlaces.append(key)
                    }
                }
                if agreedUponPlaces != [] {
                    let group = DispatchGroup()
                    group.enter()
                    guard let user = self.currentUser else {return}
                    if user.isGameCreator == true {
                        let winner = agreedUponPlaces.randomElement()
                        self.winner = winner
                        Firebase.shared.winningRestaurantFound(winningRest: winner!)
                        self.displayWinner(winner: winner!)
                        group.leave()
                    } else {
                        Firebase.shared.listenForWinningRest { (result) in
                            self.displayWinner(winner: result)
                        }
                    }
                } else {
                    self.noMatchPopup()
                }
            }
        case 8:
            if playerCount == 8 {
                for (key, value) in restaurantVotes {
                    if value >= 4 {
                        agreedUponPlaces.append(key)
                    }
                }
                if agreedUponPlaces != [] {
                    let group = DispatchGroup()
                    group.enter()
                    guard let user = self.currentUser else {return}
                    if user.isGameCreator == true {
                        let winner = agreedUponPlaces.randomElement()
                        self.winner = winner
                        Firebase.shared.winningRestaurantFound(winningRest: winner!)
                        self.displayWinner(winner: winner!)
                        group.leave()
                    } else {
                        Firebase.shared.listenForWinningRest { (result) in
                            self.displayWinner(winner: result)
                        }
                    }
                } else {
                    self.noMatchPopup()
                }
            }
        case 9:
            if playerCount == 9 {
                for (key, value) in restaurantVotes {
                    if value >= 5 {
                        agreedUponPlaces.append(key)
                    }
                }
                if agreedUponPlaces != [] {
                    let group = DispatchGroup()
                    group.enter()
                    guard let user = self.currentUser else {return}
                    if user.isGameCreator == true {
                        let winner = agreedUponPlaces.randomElement()
                        self.winner = winner
                        Firebase.shared.winningRestaurantFound(winningRest: winner!)
                        self.displayWinner(winner: winner!)
                        group.leave()
                    } else {
                        Firebase.shared.listenForWinningRest { (result) in
                            self.displayWinner(winner: result)
                        }
                    }
                } else {
                    self.noMatchPopup()
                }
            }
        case 10:
            if playerCount == 10 {
                for (key, value) in restaurantVotes {
                    if value >= 5 {
                        agreedUponPlaces.append(key)
                    }
                }
                if agreedUponPlaces != [] {
                    let group = DispatchGroup()
                    group.enter()
                    guard let user = self.currentUser else {return}
                    if user.isGameCreator == true {
                        let winner = agreedUponPlaces.randomElement()
                        self.winner = winner
                        Firebase.shared.winningRestaurantFound(winningRest: winner!)
                        self.displayWinner(winner: winner!)
                        group.leave()
                    } else {
                        Firebase.shared.listenForWinningRest { (result) in
                            self.displayWinner(winner: result)
                        }
                    }
                } else {
                    self.noMatchPopup()
                }
            }
        default:
            print("How did this happen? Only 10 players were allowed in the game!")
        }
    }
    
    func displayWinner(winner: String) {
        for restaurant in displayedRestaurants {
            if winner == restaurant.name {
                let confettiView = SAConfettiView(frame: self.view.bounds)
                confettiView.type = .Star
                view.addSubview(confettiView)
                confettiView.startConfetti()
                view.bringSubviewToFront(winningRestaurantYelpButton)
                waitForFriendsLabel.isHidden = true
                winningRestaurantYelpButton.isHidden = false
                winningRestaurantYelpLabel.isHidden = false
                restaurantRestultLabel.text = restaurant.name
                yelpURL = restaurant.restaurantYelpLink
                UIView.animate(withDuration: 3.0, delay: 0.2, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.0, options: .allowAnimatedContent, animations: {
                    self.restaurantRestultLabel.center = CGPoint(x: self.view.frame.maxX / 2, y: self.view.frame.maxY)
                }, completion: nil)
                generator.notificationOccurred(.success)
            }
        }
    }
    
    func noMatchPopup() {
        let alert = UIAlertController(title: "WHOOPSIE", message: "No match was made! Please try swiping again and be more open to possibilities.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { (_) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "swipeScreenVC")
            var viewcontrollers = self.navigationController!.viewControllers
            viewcontrollers.removeLast()
            viewcontrollers.append(vc)
            self.navigationController?.setViewControllers(viewcontrollers, animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}// End of class
