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
    var playerCount = Firebase.shared.playerCount
    var restaurantVotes: [String : Int] = [:]
    let generator = UINotificationFeedbackGenerator()
    var likes: [String] = []
    var yelpURL: String?
    let currentUser = UserController.shared.currentUser
    var revoteCount = 0
    
    // Mark: - Outlets
    @IBOutlet weak var restaurantRestultLabel: UILabel!
    @IBOutlet weak var winningRestaurantYelpLabel: UILabel!
    @IBOutlet weak var winningRestaurantYelpButton: UIButton!
    @IBOutlet weak var waitForFriendsLabel: UITextView!
    
    // Mark: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        Firebase.shared.userOnResultPage(bool: true)
        winningRestaurantYelpLabel.isHidden = true
        winningRestaurantYelpButton.isHidden = true
        if self.playerCount == 1 {
            waitForFriendsLabel.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let user = currentUser else {return}
        if user.isGameCreator == true {
            Firebase.shared.listenForAllUsersOnResultsPage { (result) in
                if result.count == self.playerCount {
                    if result.contains(false) {
                        return
                    } else {
                        Firebase.shared.stopAllUsersOnResultsPageListener()
                        Firebase.shared.listenForSubmittedVotes { (result) in
                            self.likes = []
                            self.likes = result
                            self.findMatches()
                            Firebase.shared.stopSubmittedVotesListener()
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let user = currentUser else {return}
        if user.isGameCreator == false {
            Firebase.shared.listenForAllUsersOnResultsPage { (result) in
                if result.count == self.playerCount {
                    if result.contains(false) {
                        return
                    } else {
                        self.listenForWinningRestaurant()
                    }
                }
            }
        } else if user.isGameCreator == true {
            self.listenForWinningRestaurant()
        }
    }
    
    @IBAction func yelpButtonTapped(_ sender: Any) {
        if let url = URL(string: yelpURL!) {
            UIApplication.shared.canOpenURL(url)
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func listenForWinningRestaurant() {
        Firebase.shared.listenForWinningRest { (result) in
            if result == Constants.noWinningRestaurant {
                self.noMatchPopup()
            } else {
                self.displayWinner(winner: result)
                Firebase.shared.stopListenForWinningRest()
                Firebase.shared.stopAllUsersOnResultsPageListener()
            }
        }
    }
    
    func findMatches() {
        for personsVote in self.likes {
            if restaurantVotes[personsVote] != nil {
                restaurantVotes[personsVote]! += 1
            } else {
                restaurantVotes[personsVote] = 1
            }
        }
        findHighestVotes()
    }
    
    func findHighestVotes() {
        switch playerCount {
        case 1:
            let winner = restaurantVotes.keys.randomElement()
            Firebase.shared.updateWinningRestaurantField(resultString: winner!)
            displayWinner(winner: winner!)
        case 2:
            let unanimousWinner = restaurantVotes.filter { $0.value == playerCount }
            if !unanimousWinner.isEmpty {
                let winner = unanimousWinner.keys.randomElement()!
                Firebase.shared.updateWinningRestaurantField(resultString: winner)
            } else {
                Firebase.shared.updateWinningRestaurantField(resultString: Constants.noWinningRestaurant)
                noMatchPopup()
            }
        case 3, 4, 5, 6, 7, 8, 9, 10:
            let unanimousVote = restaurantVotes.filter { $0.value == playerCount }
            let majorityVote = restaurantVotes.filter { $0.value >= playerCount!/2 + 1 }
            if !unanimousVote.isEmpty {
                let winner = unanimousVote.keys.randomElement()!
                Firebase.shared.updateWinningRestaurantField(resultString: winner)
            } else if !majorityVote.isEmpty {
                let winner = majorityVote.keys.randomElement()!
                Firebase.shared.updateWinningRestaurantField(resultString: winner)
            } else {
                Firebase.shared.updateWinningRestaurantField(resultString: Constants.noWinningRestaurant)
                noMatchPopup()
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
        let alert = UIAlertController(title: "WHOOPS", message: "No match was made! Please try swiping again and be more open to possibilities.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { (_) in
            self.likes = []
            self.performSegue(withIdentifier: "unwindToSwipeScreen", sender: self)
            Firebase.shared.userOnResultPage(bool: false)
            guard let currentUser = self.currentUser else {return}
            if currentUser.isGameCreator {
                Firebase.shared.updateWinningRestaurantField(resultString: "")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}// End of class
