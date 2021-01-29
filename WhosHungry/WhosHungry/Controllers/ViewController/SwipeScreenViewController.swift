//
//  SwipeScreenViewController.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 4/17/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import UIKit
import CoreLocation
import SafariServices
import Firebase

class SwipeScreenViewController: UIViewController, CLLocationManagerDelegate {
    
    // Mark: - Outlets
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var cuisineLabel: UILabel!
    
    // Mark: - Properties
    var divisor: CGFloat!
    var currentCardIndex: Int = 0
    var city: String?
    var radius: Double?
    var category: String?
    var yelpURL: String?
    var displayedRestaurants: [String] = []
    var restaurantVote: [Bool] = []
    var voteDictionary: [String : Int] = [:]
    var likedRestaurants: [String] = []
    let db = Firestore.firestore()
    
    // Mark: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        divisor = (view.frame.width / 2) / 0.61
        fetchRestaurants()
        card.layer.borderWidth = 1
        card.layer.borderColor = UIColor.white.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        restaurantImageView.layer.cornerRadius = 20
        restaurantImageView.clipsToBounds = true
        navigationController?.setNavigationBarHidden(true, animated: false)
        resetVoting()
    }
    
    func fetchRestaurants() {
        guard let game = Firebase.shared.currentGame else {return}
        let city = game.city
        let radius = game.radius * 1600
        let category = game.mealType
        RestaurantController.shared.fetchRestaurants(searchTerm: city, radius: Int(radius), category: category) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    //                     Start showing cards
                    //                    guard let firstRestaurant = RestaurantController.shared.restaurants.first
                    //                    else {return}
                    self?.resetVoting()
                //                    self?.populateCard(with: firstRestaurant)
                case .failure(let error):
                    print(error, error.localizedDescription)
                }
            }
        }
    }
    
    private func populateCard(with restaurant: Restaurant) {
        guard let restaurantName = restaurant.name else {return}
        displayedRestaurants.append(restaurantName)
        restaurantNameLabel.text = restaurant.name
        cuisineLabel.text = restaurant.cuisineList
        reviewCountLabel.text = "\(restaurant.reviewCount ?? 0) Reviews"
        restaurantImageView.image = restaurant.image ?? UIImage(named: "unavailable")
        yelpURL = restaurant.restaurantYelpLink
        let ratingString = RestaurantController.shared.setStarRating(rating: restaurant.rating ?? 0)
        ratingImageView.image = UIImage(named: ratingString)
    }
    
    private func resetVoting() {
        restaurantVote = []
        displayedRestaurants = []
        likedRestaurants = []
        voteDictionary = [:]
        resetCard()
        currentCardIndex = 0
        guard let firstRestaurant = RestaurantController.shared.restaurants.first else {return}
        self.populateCard(with: firstRestaurant)
    }
    
    @IBAction func yelpButtonTapped(_ sender: Any) {
        guard let yelpURL = yelpURL else {return}
        if let url = URL(string: yelpURL) {
            UIApplication.shared.canOpenURL(url)
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    private func showNextCard() {
        if RestaurantController.shared.restaurants.count == currentCardIndex + 1 {
            compareArray()
            if likedRestaurants.isEmpty {
                noRestaurantVote()
            } else {
                Firebase.shared.createUserVoteCollection(userVote: likedRestaurants) { [weak self] (result) in
                    switch result {
                    case .success(let userVote):
                        guard let game = Firebase.shared.currentGame else {return}
                        guard let user = UserController.shared.currentUser else {return}
                        self?.db.collection(Constants.gameContainer).document(game.uid).collection(Constants.usersVotes).document("\(user.firstName + " " + user.lastName)").updateData([Constants.submittedVotes : userVote])
                    case .failure(let error):
                        print("Error updating user vote collection: \(error)")
                    }
                }
                let seconds = 2.0
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                    if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "resultsVC") as? ResultsViewController {
                        if let navigator = self.navigationController {
                            navigator.pushViewController(viewController, animated: true)
                            viewController.likes.append(contentsOf: self.likedRestaurants)
                        }
                    }
                }
            }
        } else {
            resetCard()
            currentCardIndex += 1
            let restaurant = RestaurantController.shared.restaurants[currentCardIndex]
            populateCard(with: restaurant)
        }
    }
    
    @IBAction func panCard(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        let scale = min(100/abs(xFromCenter), 1)
        card.transform = CGAffineTransform(rotationAngle: xFromCenter/divisor).scaledBy(x: scale, y: scale)
        if xFromCenter > 0 {
            thumbImageView.image = #imageLiteral(resourceName: "Untitled")
            thumbImageView.tintColor = .green
        } else {
            thumbImageView.image = #imageLiteral(resourceName: "UntitledXImage")
            thumbImageView.tintColor = .red
        }
        thumbImageView.alpha = abs(xFromCenter) / view.center.x
        
        if sender.state == UIGestureRecognizer.State.ended {
            if card.center.x < 75 {
                // Move off to the left side of the screen
                restaurantVote.append(false)
                UIView.animate(withDuration: 0.3, animations: {
                    //                    card.center = self.view.center
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 75)
                    card.alpha = 0
                }) { (success) in
                    if success {
                        self.showNextCard()
                    }
                }
                return
            } else if card.center.x > (view.frame.width - 75) {
                //Move off to the right side of the screen
                restaurantVote.append(true)
                UIView.animate(withDuration: 0.3, animations:  {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
                    card.alpha = 0
                }) { (success) in
                    if success {
                        self.showNextCard()
                    }
                }
                return
            }
            UIView.animate(withDuration: 0.2) {
                card.center = self.view.center
                self.thumbImageView.alpha = 0
            }
        }
    }
    
    func resetCard() {
        self.thumbImageView.alpha = 0
        self.card.alpha = 0
        UIView.animate(withDuration: 0.2, animations: {
            self.card.center = self.view.center
            self.card.transform = .identity
        }) { (success) in
            UIView.animate(withDuration: 0.5, animations: {
                self.card.alpha = 1
                self.thumbImageView.alpha = 0
            })
        }
    }
    
    private func compareArray() {
        for i in 0 ..< displayedRestaurants.count {
            if restaurantVote[i] == true {
                let name = displayedRestaurants[i]
                likedRestaurants.append(name)
                if let _ = voteDictionary[name] {
                    // case 1: the key already exists
                    voteDictionary[name]! += 1
                } else {
                    // case 2: we're adding a key for the first time
                    voteDictionary[name] = 1
                }
            }
        }
    }
    
    private func noRestaurantVote() {
        let alert = UIAlertController(title: "Don't be so picky...", message: "You must swipe right on at least one restaurant", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { (_) in
            self.resetVoting()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
