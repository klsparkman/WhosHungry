//
//  SwipeScreenViewController.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 4/17/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import UIKit

class SwipeScreenViewController: UIViewController {
    
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    
    var divisor: CGFloat!
    let restaurantService = RestaurantService()
    var restaurants: [Restaurant] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        divisor = (view.frame.width / 2) / 0.61
        restaurantService.delegate = self
//        RestaurantController.shared.fetchRestaurants { (result) in
//            switch result {
//            case .success(let restaurant):
//                self.card = restaurants
//            case .failure(let error):
//                print(error, error.localizedDescription)
//            }
//        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        resetCard()
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
                })
                return
            } else if card.center.x > (view.frame.width - 75) {
                //Move off to the right side of the screen
                UIView.animate(withDuration: 0.3, animations:  {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
                    card.alpha = 0
                })
                return
            }
            UIView.animate(withDuration: 0.2) {
                card.center = self.view.center
                self.thumbImageView.alpha = 0
            }
        }
    }
    
    func resetCard() {
        UIView.animate(withDuration: 0.2, animations: {
            self.card.center = self.view.center
            self.thumbImageView.alpha = 0
            self.card.alpha = 1
            self.card.transform = .identity
        })
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
