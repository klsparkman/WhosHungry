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
    var playerCount = Firebase.shared.playerCount
    var restaurantVotes: [String : Int] = [:]
    let generator = UINotificationFeedbackGenerator()
    var likes: [String] = []
    var yelpURL: String?
    let currentUser = UserController.shared.currentUser
    
    // Mark: - Outlets
    @IBOutlet weak var restaurantResultLabel: UILabel!
    @IBOutlet weak var winningRestaurantYelpLabel: UILabel!
    @IBOutlet weak var winningRestaurantYelpButton: UIButton!
    @IBOutlet weak var waitForFriendsLabel: UITextView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
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
        super.viewWillAppear(animated)
        guard let user = currentUser else {return}
        if user.isGameCreator == true {
            Firebase.shared.listenForAllUsersOnResultsPage { [weak self] (result) in
                if result.count == self?.playerCount {
                    if result.contains(false) {
                        return
                    } else {
                        Firebase.shared.stopAllUsersOnResultsPageListener()
                        Firebase.shared.listenForSubmittedVotes { [weak self] (result) in
                            self?.likes = []
                            self?.likes = result
                            self?.findMatches()
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
        Firebase.shared.listenForWinningRest { [weak self] (result) in
            if result == Constants.noWinningRestaurant {
                self?.noMatchPopup()
            } else {
                self?.displayWinner(winner: result)
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
            guard let winner = restaurantVotes.keys.randomElement() else {return}
            Firebase.shared.updateWinningRestaurantField(resultString: winner) { [weak self] (result) in
                switch result {
                case .success(_):
                    self?.displayWinner(winner: winner)
                case .failure(let error):
                    print("There was an error updating the winning restaurant to Firestore: \(error.localizedDescription)")
                    self?.retryUpdatingInfoToFirestore()
                }
            }
        case 2:
            let unanimousWinner = restaurantVotes.filter { $0.value == playerCount }
            if !unanimousWinner.isEmpty {
                let winner = unanimousWinner.keys.randomElement()!
                Firebase.shared.updateWinningRestaurantField(resultString: winner) { [weak self] (result) in
                    switch result {
                    case .success(_):
                        self?.displayWinner(winner: winner)
                    case .failure(let error):
                        print("There was an error updating the winning restaurant to Firestore: \(error.localizedDescription)")
                        self?.retryUpdatingInfoToFirestore()
                    }
                }
            } else {
                Firebase.shared.updateWinningRestaurantField(resultString: Constants.noWinningRestaurant) { [weak self] (result) in
                    switch result {
                    case .success(_):
                        print("There was no winning restaurant, try again")
                        //                        self?.displayNoWinnerFound()
                        self?.noMatchPopup()
                    case .failure(let error):
                        print("There was an error updating winning restaurant field to noWinningRestaurant: \(error.localizedDescription)")
                        self?.retryUpdatingInfoToFirestore()
                    }
                }
            }
        case 3, 4, 5, 6, 7, 8, 9, 10:
            let unanimousVote = restaurantVotes.filter { $0.value == playerCount }
            let majorityVote = restaurantVotes.filter { $0.value >= playerCount!/2 + 1 }
            if !unanimousVote.isEmpty {
                guard let winner = unanimousVote.keys.randomElement() else {return}
                Firebase.shared.updateWinningRestaurantField(resultString: winner) { [weak self] (result) in
                    switch result {
                    case .success(_):
                        self?.displayWinner(winner: winner)
                    case .failure(let error):
                        print("There was an error updating the winning restaurant to Firestore: \(error.localizedDescription)")
                        self?.retryUpdatingInfoToFirestore()
                    }
                }
            } else if !majorityVote.isEmpty {
                guard let winner = majorityVote.keys.randomElement() else {return}
                Firebase.shared.updateWinningRestaurantField(resultString: winner) { [weak self] (result) in
                    switch result {
                    case .success(_):
                        self?.displayWinner(winner: winner)
                    case .failure(let error):
                        print("There was an error updating the majority winner to Firestore: \(error.localizedDescription)")
                        self?.retryUpdatingInfoToFirestore()
                    }
                }
            } else {
                Firebase.shared.updateWinningRestaurantField(resultString: Constants.noWinningRestaurant) { [weak self] (result) in
                    switch result {
                    case .success(_):
                        print("No winner was found, try again")
                        //self?.displayNoWinnerFound()
                        self?.noMatchPopup()
                    case .failure(let error):
                        print("There was an error updating winning restaurant field to noWinningRestaurant: \(error.localizedDescription)")
                        self?.retryUpdatingInfoToFirestore()
                    }
                }
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
        restaurantResultLabel.text = restaurant.name
        yelpURL = restaurant.restaurantYelpLink
        UIView.animate(withDuration: 3.0, delay: 0.2, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.0, options: .allowAnimatedContent, animations: {
            self.restaurantResultLabel.center = CGPoint(x: self.view.frame.maxX / 2, y: self.view.frame.maxY)
        }, completion: nil)
        generator.notificationOccurred(.success)
        stopRemainingListeners()
        view.setNeedsDisplay()
        view.layoutIfNeeded()
    }
    
    func noMatchPopup() {
        let alert = UIAlertController(title: "WHOOPS", message: "No match was made! Please try swiping again and be more open to possibilities.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { [weak self] (_) in
            self?.likes = []
            Firebase.shared.userOnResultPage(bool: false)
            guard let currentUser = self?.currentUser else {return}
            if currentUser.isGameCreator {
                Firebase.shared.updateWinningRestaurantField(resultString: "") { [weak self] (result) in
                    switch result {
                    case .success(_):
                        print("Just updated the winning restaurant field")
                        self?.stopRemainingListeners()
                        self?.navigationController?.popViewController(animated: true)
                    case .failure(let error):
                        self?.retryUpdatingInfoToFirestore()
                        print("There was an error updating winning restaurant field: \(error.localizedDescription)")
                    }
                }
            } else {
                self?.stopRemainingListeners()
                print("Listeners have been stopped")
                self?.navigationController?.popViewController(animated: true)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func retryUpdatingInfoToFirestore() {
        let alert = UIAlertController(title: "Error", message: "We encountered an error somewhere, please check your connection and try swiping again!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { [weak self] (_) in
            self?.likes = []
            self?.stopRemainingListeners()
            self?.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func stopRemainingListeners() {
        Firebase.shared.stopLikeListener()
        Firebase.shared.stopSubmittedVotesListener()
        Firebase.shared.stopRevoteListener()
        Firebase.shared.stopAllUsersOnResultsPageListener()
        Firebase.shared.stopListenForWinningRest()
    }
}// End of class
