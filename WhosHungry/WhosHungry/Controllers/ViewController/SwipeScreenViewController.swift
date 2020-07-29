//
//  SwipeScreenViewController.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 4/17/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import UIKit
import CoreLocation

class SwipeScreenViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var cuisineLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    static var shared = SwipeScreenViewController()
    
    var divisor: CGFloat!
//    let restaurantService = RestaurantService()
    var restaurant: Restaurant?
    var location: CLLocation?
    var currentCardIndex: Int = 0
    var user: [Int] = []
    var liked: [Restaurant] = []
    var city: String?
    var radius: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        divisor = (view.frame.width / 2) / 0.61
        fetchRestaurants()
//        matchRestaurants()
    }
    
    func fetchRestaurants() {
//        guard let location = location else {return}
        guard let city = city else {return}
        guard let radius = radius else {return}

        RestaurantController.shared.fetchRestaurants(searchTerm: city, radius: radius) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    // Start showing cards
                    guard let firstRestaurant = RestaurantController.shared.restaurants.first
                        else { return }
                    self.populateCard(with: firstRestaurant)
                case .failure(let error):
                    print(error, error.localizedDescription)
                }
            }
        }
    }
    
    private func populateCard(with restaurant: Restaurant) {
        self.restaurantImageView.image = restaurant.image ?? UIImage(named: "unavailable")
        self.restaurantNameLabel.text = restaurant.name
//        self.cuisineLabel.text = restaurant.cuisines
//        self.ratingLabel.text = restaurant.rating?.rating
    }
    
    private func showNextCard() {
        guard RestaurantController.shared.restaurants.count > currentCardIndex + 1
            else { return }
        resetCard()
        currentCardIndex += 1
        let restaurant = RestaurantController.shared.restaurants[currentCardIndex]
        populateCard(with: restaurant)
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
                UIView.animate(withDuration: 0.3, animations: {
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
                UIView.animate(withDuration: 0.3, animations:  {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
                    card.alpha = 0
                }) { (success) in
                    if success {
                        self.showNextCard()
                    }
                }
                self.restaurant?.isLiked = true
//                self.likeList()
                print("card was liked")
                guard let restaurant = restaurant else {return}
                if self.restaurant?.isLiked == true {
                    liked.append(restaurant)
                           print("restaurant has been added")
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
    
//    func matchRestaurants() {
//        for restaurant in liked {
//            if liked.count == restaurantService.players.count {
//                restaurantPicked(manager: restaurantService, restaurantString: "\(restaurant)")
//            }
//        }
//    }
    
    func restaurantPicked(restaurantString: String) {
        OperationQueue.main.addOperation {
            let alertController = UIAlertController(title: "A MATCH HAS BEEN MADE!", message: "Would you like to see where you are eating today?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Show Me Fool!", style: .default) { (_) in
                func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                    if segue.identifier == "mapVC" {
                        guard let destinationVC = segue.destination as? MapViewController else {return}
                        destinationVC.winningRestaurant = SwipeScreenViewController.shared.restaurant
                    }
                }
            }
            let cancelAction = UIAlertAction(title: "Nah, I'm good.", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
