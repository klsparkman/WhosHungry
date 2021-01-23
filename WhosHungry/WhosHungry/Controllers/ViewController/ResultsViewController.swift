//
//  ResultsViewController.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 10/27/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import UIKit
import SAConfettiView

protocol ResultsViewControllerDelegate: AnyObject {
    func isRevoteHappening(_ sender: Bool)
}

class ResultsViewController: UIViewController {
    
    // Mark: - Properties
    static let shared = ResultsViewController()
    var playerCount = Firebase.shared.playerCount
    var restaurantVotes: [String : Int] = [:]
    let generator = UINotificationFeedbackGenerator()
    var likes: [String] = []
    var yelpURL: String?
    let currentUser = UserController.shared.currentUser
    weak var delegate: ResultsViewControllerDelegate?
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
        delegate?.isRevoteHappening(false)
        winningRestaurantYelpLabel.isHidden = true
        winningRestaurantYelpButton.isHidden = true
        if self.playerCount == 1 {
            waitForFriendsLabel.isHidden = true
        }
        if currentUser?.isGameCreator == false {
            Firebase.shared.listenForAllUsersOnResultsPage { (result) in
                if result.count == self.playerCount{
                    if result.contains(false) {
                        return
                    } else {
                        Firebase.shared.listenForWinningRest { (result) in
                            switch result {
                            case .success(let winner):
                                guard let winner = winner else {return}
                                if winner != "" {
                                    self.displayWinner(winner: winner)
                                } else {
                                    self.noMatchPopup()
                                    Firebase.shared.userOnResultPage(bool: false)
                                }
                            case .failure(let error):
                                print("There was an error listening for a winning restaurant: \(error)")
                            }
                        }
                    }
                }
            }
        } else {
            Firebase.shared.listenForWinningRest { (result) in
                switch result {
                case .success(let winner):
                    guard let winner = winner else {return}
                    if winner != " " {
                        self.displayWinner(winner: winner)
                    } else {
                        self.noMatchPopup()
                    }
                case .failure(let error):
                    print("There was an error listening for a winning restaurant: \(error)")
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let user = currentUser else {return}
        if user.isGameCreator {
            Firebase.shared.listenForAllUsersOnResultsPage { (result) in
                if result.count == self.playerCount {
                    if result.contains(false) {
                        return
                    } else {
                        Firebase.shared.listenForSubmittedVotes { (result) in
                            self.likes = result
                            self.findMatches()
                            Firebase.shared.stopSubmittedVotesListener()
                            Firebase.shared.stopAllUsersOnResultsPageListener()
                        }
                    }
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
            Firebase.shared.winningRestaurantFound(winningRest: winner!)
            displayWinner(winner: winner!)
        case 2:
            let unanimousWinner = restaurantVotes.filter { $0.value == playerCount }
            if !unanimousWinner.isEmpty {
                let winner = unanimousWinner.keys.randomElement()!
                Firebase.shared.winningRestaurantFound(winningRest: winner)
                //                Firebase.shared.listenForWinningRest { (result) in
                //                    self.displayWinner(winner: result)
                //                }
            } else {
                //                Firebase.shared.startRevote()
                Firebase.shared.userOnResultPage(bool: false)
                noMatchPopup()
            }
        case 3, 4, 5, 6, 7, 8, 9, 10:
            let unanimousVote = restaurantVotes.filter { $0.value == playerCount }
            let majorityVote = restaurantVotes.filter { $0.value >= playerCount!/2 + 1 }
            if !unanimousVote.isEmpty {
                let winner = unanimousVote.keys.randomElement()!
                Firebase.shared.winningRestaurantFound(winningRest: winner)
                //                Firebase.shared.listenForWinningRest { (result) in
                //                    self.displayWinner(winner: result)
                //                }
            } else if !majorityVote.isEmpty {
                let winner = majorityVote.keys.randomElement()!
                Firebase.shared.winningRestaurantFound(winningRest: winner)
            } else {
                //                Firebase.shared.startRevote()
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
        let alert = UIAlertController(title: "WHOOPSIE", message: "No match was made! Please try swiping again and be more open to possibilities.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { (_) in
            self.likes = []
            //            if self.currentUser?.isGameCreator == false {
            //                if self.revoteCount == 0 {
            //                    self.revoteCount = 1
            //                } else {
            //                    self.revoteCount += 1
            //                }
            //            }
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
