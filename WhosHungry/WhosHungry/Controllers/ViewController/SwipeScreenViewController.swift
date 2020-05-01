//
//  SwipeScreenViewController.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 4/17/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import UIKit

class SwipeScreenViewController: UIViewController {
    
    @IBOutlet weak var restaurantCardImageView: UIImageView!
    
    @IBOutlet var swipGestureRecognizer: UISwipeGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        restaurantCardImageView.isUserInteractionEnabled = true
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        restaurantCardImageView.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        leftSwipe.direction = UISwipeGestureRecognizer.Direction.left
        restaurantCardImageView.addGestureRecognizer(leftSwipe)
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer?) {
        if let handleSwipe = sender {
            switch handleSwipe.direction {
            case .right:
                restaurantCardImageView.backgroundColor = .green
            case .left:
                restaurantCardImageView.backgroundColor = .red
            default:
                break
            }
        }
    }
    @IBAction func swipeAction(_ sender: Any) {
        print("i swipped right")
    }
}
