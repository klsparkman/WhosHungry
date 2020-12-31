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
    //    var voteCount = Firebase.shared.voteCount?
    var restaurantVotes: [String : Int] = [:]
    let generator = UINotificationFeedbackGenerator()
    
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
            let voteCount = Firebase.shared.voteCount
            if self.playerCount == voteCount {
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
        switch playerCount {
        case 1:
            if playerCount == 1 {
                for (key, value) in restaurantVotes {
                    if value == 1 {
                        agreedUponPlaces.append(key)
                    }
                }
                if agreedUponPlaces != [] {
                    restaurantRestultLabel.text = agreedUponPlaces.randomElement()
                    generator.notificationOccurred(.success)
                }
            }
        case 2:
            if playerCount == 2 {
                for (key, value) in restaurantVotes {
                    if value == 2 {
                        agreedUponPlaces.append(key)
                    } else {
                        if value == 1 {
                            noMatchPopup()
                        }
                    }
                }
                if agreedUponPlaces != [] {
                    restaurantRestultLabel.text = agreedUponPlaces.randomElement()
                    generator.notificationOccurred(.success)
                }
            }
        case 3:
            if playerCount == 3 {
                for (key, value) in restaurantVotes {
                    if value >= 2 {
                        agreedUponPlaces.append(key)
                    } else {
                        if value == 1 {
                            self.noMatchPopup()
                        }
                    }
                }
                if agreedUponPlaces != [] {
                    restaurantRestultLabel.text = agreedUponPlaces.randomElement()
                    generator.notificationOccurred(.success)
                }
            }
        case 4:
            if playerCount == 4 {
                for (key, value) in restaurantVotes {
                    if value >= 2 {
                        agreedUponPlaces.append(key)
                    } else {
                        if value < 2 {
                            self.noMatchPopup()
                        }
                    }
                }
                if agreedUponPlaces != [] {
                    restaurantRestultLabel.text = agreedUponPlaces.randomElement()
                    generator.notificationOccurred(.success)
                }
            }
        case 5:
            if playerCount == 5 {
                for (key, value) in restaurantVotes {
                    if value >= 3 {
                        agreedUponPlaces.append(key)
                    } else {
                        if value <= 2 {
                            self.noMatchPopup()
                        }
                    }
                }
                if agreedUponPlaces != [] {
                    restaurantRestultLabel.text = agreedUponPlaces.randomElement()
                    generator.notificationOccurred(.success)
                }
            }
        case 6:
            if playerCount == 6 {
                for (key, value) in restaurantVotes {
                    if value >= 3 {
                        agreedUponPlaces.append(key)
                    } else {
                        if value <= 2 {
                            self.noMatchPopup()
                        }
                    }
                }
                if agreedUponPlaces != [] {
                    restaurantRestultLabel.text = agreedUponPlaces.randomElement()
                    generator.notificationOccurred(.success)
                }
            }
        case 7:
            if playerCount == 7 {
                for (key, value) in restaurantVotes {
                    if value >= 4 {
                        agreedUponPlaces.append(key)
                    } else {
                        if value <= 3 {
                            self.noMatchPopup()
                        }
                    }
                }
                if agreedUponPlaces != [] {
                    restaurantRestultLabel.text = agreedUponPlaces.randomElement()
                    generator.notificationOccurred(.success)
                }
            }
        case 8:
            if playerCount == 8 {
                for (key, value) in restaurantVotes {
                    if value >= 4 {
                        agreedUponPlaces.append(key)
                    } else {
                        if value <= 3 {
                            self.noMatchPopup()
                        }
                    }
                }
                if agreedUponPlaces != [] {
                    restaurantRestultLabel.text = agreedUponPlaces.randomElement()
                    generator.notificationOccurred(.success)
                }
            }
        case 9:
            if playerCount == 9 {
                for (key, value) in restaurantVotes {
                    if value >= 5 {
                        agreedUponPlaces.append(key)
                    } else {
                        if value <= 4 {
                            self.noMatchPopup()
                        }
                    }
                }
                if agreedUponPlaces != [] {
                    restaurantRestultLabel.text = agreedUponPlaces.randomElement()
                    generator.notificationOccurred(.success)
                }
            }
        case 10:
            if playerCount == 10 {
                for (key, value) in restaurantVotes {
                    if value >= 5 {
                        agreedUponPlaces.append(key)
                    } else {
                        if value <= 4 {
                            self.noMatchPopup()
                        }
                    }
                }
                if agreedUponPlaces != [] {
                    restaurantRestultLabel.text = agreedUponPlaces.randomElement()
                    generator.notificationOccurred(.success)
                }
            }
        default:
            print("You should not have reached this part...? ")
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
