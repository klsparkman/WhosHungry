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
    
    var divisor: CGFloat!
    let restaurantService = RestaurantService()
    var restaurant: Restaurant?
    var location: CLLocation?
    var currentCardIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        divisor = (view.frame.width / 2) / 0.61
        restaurantService.delegate = self
        fetchRestaurants()
    }
    
    func fetchRestaurants() {
        guard let location = location else {return}
        RestaurantController.shared.fetchRestaurants(location: location) { (result) in
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
        self.restaurantImageView.image = restaurant.image // ?? Default image
        self.restaurantNameLabel.text = restaurant.name
    }
    
    private func showNextCard() {
        guard RestaurantController.shared.restaurants.count > currentCardIndex + 1
            else { return }
        
        resetCard()
        currentCardIndex += 1
        let restaurant = RestaurantController.shared.restaurants[currentCardIndex]
        populateCard(with: restaurant)
    }
    
//    func fetchImageAndUpdateViews(restaurants: [Restaurant]) {
//        RestaurantController.shared.fetchImage(for: restaurant) { (result) in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let image):
//                    self.restaurantImageView.image = image
//                    self.restaurantImageView.contentMode = .scaleAspectFill
//                    self.restaurantNameLabel.text = restaurant.name
//                case .failure(let error):
//                    print(error, error.localizedDescription)
//                }
//            }
//        }
//    }
    
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
}

extension SwipeScreenViewController: RestaurantServiceDelegate {
    
    func connectedDevicesChanged(manager: RestaurantService, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            //            add label for connected devices?
            //            self.connectionsLabel.text = "Connections: \(connectedDevices)"
        }
    }
    
    func restaurantPicked(manager: RestaurantService, restaurantString: String) {
        // Add an alert for when everyone swipes right on a restaurant
    }
}
