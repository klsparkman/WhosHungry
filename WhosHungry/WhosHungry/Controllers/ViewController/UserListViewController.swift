
//
//  UserListViewController.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 4/17/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import UIKit
import CoreLocation

class UserListViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    // Mark: - Outlets
    @IBOutlet weak var generateCodeButton: UIButton!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var haveACodeButton: UIButton!
    @IBOutlet weak var pasteCodeTextField: UITextField!
    @IBOutlet weak var userListTableView: UITableView!
    @IBOutlet weak var readyToEatButton: UIButton!
    @IBOutlet weak var copycodeButton: UIButton!
    
    // Mark: - Properties
    static let shared = UserListViewController()
//    let restaurantService = RestaurantService()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    var isAdvertising: Bool!
    var locManager = CLLocationManager()
    var currentLocation: CLLocation?
    var user: User?
//    var safeArea: UILayoutGuide {
//        return self.view.safeAreaLayoutGuide
//    }
    
    // Mark: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        codeLabel.isHidden = true
        pasteCodeTextField.isHidden = true
        userListTableView.isHidden = true
        readyToEatButton.isHidden = true
        copycodeButton.isHidden = true
        generateCodeButton.layer.cornerRadius = 10
        generateCodeButton.layer.borderWidth = 1
        generateCodeButton.layer.borderColor = UIColor.white.cgColor
        codeLabel.layer.cornerRadius = 10
        pasteCodeTextField.layer.cornerRadius = 10
        haveACodeButton.layer.cornerRadius = 10
        haveACodeButton.layer.borderWidth = 1
        haveACodeButton.layer.borderColor = UIColor.white.cgColor
//        restaurantService.delegate = self
//        isAdvertising = true
        locManager.requestAlwaysAuthorization()
        pasteCodeTextField.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyBest
            locManager.startUpdatingLocation()
            currentLocation = locManager.location
        }
        
//        UIView.animate(withDuration: 3.0, delay: 0.2, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: .allowAnimatedContent, animations: {
//            self.beginButton.center = CGPoint(x: self.view.frame.maxX / 2, y: self.view.frame.maxY)
//        }, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pasteCodeTextField.resignFirstResponder()
        return true
    }
    
    func randomAlphaNumericString(length: Int) -> String {
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.count)
        var randomString = "Your invite code is:    "

        for _ in 0..<length {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
            let newCharacter = allowedChars[randomIndex]
            randomString += String(newCharacter)
        }

        return randomString
    }
    
    @IBAction func generateCodeButtonPressed(_ sender: Any) {
        codeLabel.isHidden = false
        pasteCodeTextField.isHidden = true
        codeLabel.text = randomAlphaNumericString(length: 10)
        userListTableView.isHidden = false
        readyToEatButton.isHidden = false
        copycodeButton.isHidden = false
    }
    
    @IBAction func haveACodeButtonPressed(_ sender: Any) {
        pasteCodeTextField.isHidden = false
        codeLabel.isHidden = true
        copycodeButton.isHidden = true
    }
    
    @IBAction func copyCodePressed(_ sender: Any) {
        UIPasteboard.general.string = codeLabel.text
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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        super.prepare(for: segue, sender: sender)
//        if segue.identifier == "toSwipeVC" {
//            guard let destinationVC = segue.destination as? SwipeScreenViewController else {return}
//            destinationVC.location = currentLocation
//            destinationVC.user = restaurantService.players
//        }
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            1
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = userListTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "Game Leader: \(user?.debugDescription ?? "")"
            return UITableViewCell()
        }
}//End of class

//extension UserListViewController: RestaurantServiceDelegate {
//    func restaurantPicked(manager: RestaurantService, restaurantString: String) {
//    }
//
//    func connectedDevices(manager: RestaurantService, connectedDevices: [String]) {
//        OperationQueue.main.addOperation {
////            self.playerLabel.text = "Players: \(connectedDevices)"
//        }
//    }
//}


