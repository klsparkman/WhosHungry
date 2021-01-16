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
    let currentUser = UserController.shared.currentUser
    var winner: String?
    var currentVoteCount = 0
    let group = DispatchGroup()
    
    // Mark: - Outlets
    @IBOutlet weak var restaurantRestultLabel: UILabel!
    @IBOutlet weak var winningRestaurantYelpLabel: UILabel!
    @IBOutlet weak var winningRestaurantYelpButton: UIButton!
    @IBOutlet weak var waitForFriendsLabel: UITextView!
    
    // Mark: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        winningRestaurantYelpLabel.isHidden = true
        winningRestaurantYelpButton.isHidden = true
        if self.playerCount == 1 {
            waitForFriendsLabel.isHidden = true
        }
        if currentUser?.isGameCreator == false {
            Firebase.shared.listenForWinningRest { (result) in
                self.displayWinner(winner: result)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let user = currentUser else {return}
        if user.isGameCreator {
            Firebase.shared.listenForAllVotesSubmitted { (result) in
                //Both users are hit this point at the same time
                //LABLE.TEXT = RESULT.COUNT
                self.likes = result
                self.findMatches()
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
                }
            }
        case 2:
            for (key, value) in restaurantVotes {
                if value >= 2 {
                    agreedUponPlaces.append(key)
                }
            }
            if agreedUponPlaces != [] {
                guard let winner = agreedUponPlaces.randomElement() else {return}
                Firebase.shared.winningRestaurantFound(winningRest: winner)
                self.displayWinner(winner: winner)
            } else {
                self.noMatchPopup()
            }
        case 3:
            for (key, value) in restaurantVotes {
                if value >= 2 {
                    agreedUponPlaces.append(key)
                }
            }
            if agreedUponPlaces != [] {
                guard let winner = agreedUponPlaces.randomElement() else {return}
                Firebase.shared.winningRestaurantFound(winningRest: winner)
                self.displayWinner(winner: winner)
            } else {
                self.noMatchPopup()
            }
            
        case 4:
            for (key, value) in restaurantVotes {
                if value >= 2 {
                    agreedUponPlaces.append(key)
                }
            }
            if agreedUponPlaces != [] {
                guard let winner = agreedUponPlaces.randomElement() else {return}
                Firebase.shared.winningRestaurantFound(winningRest: winner)
                self.displayWinner(winner: winner)
            } else {
                self.noMatchPopup()
            }
        case 5:
            for (key, value) in restaurantVotes {
                if value >= 3 {
                    agreedUponPlaces.append(key)
                }
            }
            if agreedUponPlaces != [] {
                guard let winner = agreedUponPlaces.randomElement() else {return}
                Firebase.shared.winningRestaurantFound(winningRest: winner)
                self.displayWinner(winner: winner)
            } else {
                self.noMatchPopup()
            }
        case 6:
            for (key, value) in restaurantVotes {
                if value >= 3 {
                    agreedUponPlaces.append(key)
                }
            }
            if agreedUponPlaces != [] {
                guard let winner = agreedUponPlaces.randomElement() else {return}
                Firebase.shared.winningRestaurantFound(winningRest: winner)
                self.displayWinner(winner: winner)
            } else {
                self.noMatchPopup()
            }
        case 7:
            for (key, value) in restaurantVotes {
                if value >= 4 {
                    agreedUponPlaces.append(key)
                }
            }
            if agreedUponPlaces != [] {
                guard let winner = agreedUponPlaces.randomElement() else {return}
                Firebase.shared.winningRestaurantFound(winningRest: winner)
                self.displayWinner(winner: winner)
            } else {
                self.noMatchPopup()
            }
        case 8:
            for (key, value) in restaurantVotes {
                if value >= 4 {
                    agreedUponPlaces.append(key)
                }
            }
            if agreedUponPlaces != [] {
                guard let winner = agreedUponPlaces.randomElement() else {return}
                Firebase.shared.winningRestaurantFound(winningRest: winner)
                self.displayWinner(winner: winner)
            } else {
                self.noMatchPopup()
            }
        case 9:
            for (key, value) in restaurantVotes {
                if value >= 5 {
                    agreedUponPlaces.append(key)
                }
            }
            if agreedUponPlaces != [] {
                guard let winner = agreedUponPlaces.randomElement() else {return}
                Firebase.shared.winningRestaurantFound(winningRest: winner)
                self.displayWinner(winner: winner)
            } else {
                self.noMatchPopup()
            }
        case 10:
            for (key, value) in restaurantVotes {
                if value >= 5 {
                    agreedUponPlaces.append(key)
                }
            }
            if agreedUponPlaces != [] {
                guard let winner = agreedUponPlaces.randomElement() else {return}
                Firebase.shared.winningRestaurantFound(winningRest: winner)
                self.displayWinner(winner: winner)
            } else {
                self.noMatchPopup()
            }
        default:
            print("How did this happen? Only 10 players were allowed in the game!")
        }
    }
    
    func displayWinner(winner: String) {
        guard let restaurant = RestaurantController.shared.restaurant(withName: winner) else {return}
        let confettiView = SAConfettiView(frame: self.view.bounds)
        confettiView.type = .Confetti
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
    
    func noMatchPopup() {
        let alert = UIAlertController(title: "WHOOPSIE", message: "No match was made! Please try swiping again and be more open to possibilities.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { (_) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "swipeScreenVC")
            var viewcontrollers = self.navigationController!.viewControllers
            viewcontrollers.removeLast()
            viewcontrollers.append(vc)
            self.navigationController?.setViewControllers(viewcontrollers, animated: true)
            self.likes = []
            Firebase.shared.allVotesSubmitted()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}// End of class
