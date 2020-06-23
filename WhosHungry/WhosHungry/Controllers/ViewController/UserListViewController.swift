
//
//  UserListViewController.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 4/17/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import CoreLocation

class UserListViewController: UIViewController, CLLocationManagerDelegate {

    // Mark: - Outlets
    @IBOutlet weak var playerLabel: UILabel!
    
    // Mark: - Properties
    static let shared = UserListViewController()
    let restaurantService = RestaurantService()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var isAdvertising: Bool!
    var locManager = CLLocationManager()
    var currentLocation: CLLocation?
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    
    let beginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Lets Begin!", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.contentHorizontalAlignment = .center
        button.titleLabel?.font = UIFont(name: "Lunasol", size: 37)
        return button
    }()

    // Mark: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        restaurantService.delegate = self
        isAdvertising = true
        locManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyBest
            locManager.startUpdatingLocation()
            currentLocation = locManager.location
        }
        
        UIView.animate(withDuration: 3.0, delay: 0.2, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: .allowAnimatedContent, animations: {
            self.beginButton.center = CGPoint(x: self.view.frame.maxX / 2, y: self.view.frame.maxY)
        }, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopup()
        }
    }
    
    func showLocationDisabledPopup() {
        let alertController = UIAlertController(title: "Background location access disabled.", message: "In order to pull restaurants in your area, we need your location.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open settings", style: .default) { (action) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "toSwipeVC" {
            guard let destinationVC = segue.destination as? SwipeScreenViewController else {return}
            destinationVC.location = currentLocation
            destinationVC.user = restaurantService.players
        }
    }
}//End of class

extension UserListViewController: RestaurantServiceDelegate {
    func restaurantPicked(manager: RestaurantService, restaurantString: String) {
    }
    
    func connectedDevices(manager: RestaurantService, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            self.playerLabel.text = "Players: \(connectedDevices)"
        }
    }
}
