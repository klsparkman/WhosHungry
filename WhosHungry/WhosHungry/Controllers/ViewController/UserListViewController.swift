
//
//  UserListViewController.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 4/17/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

class UserListViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // Mark: - Outlets
    @IBOutlet weak var generateCodeButton: UIButton!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var haveACodeButton: UIButton!
    @IBOutlet weak var pasteCodeTextField: UITextField!
    @IBOutlet weak var userListTableView: UITableView!
    @IBOutlet weak var copycodeButton: UIButton!
    @IBOutlet weak var citySearchTextField: UITextField!
    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var placesTableView: UITableView!
    
    // Mark: - Properties
    static let shared = UserListViewController()
    var locManager = CLLocationManager()
    var currentLocation: CLLocation?
    var user: User?
    var resultsArray: [Dictionary<String, AnyObject>] = Array()
    
    // Mark: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        codeLabel.isHidden = true
        pasteCodeTextField.isHidden = true
        userListTableView.isHidden = true
        copycodeButton.isHidden = true
//        placesTableView.isHidden = true
        generateCodeButton.layer.cornerRadius = 10
        generateCodeButton.layer.borderWidth = 1
        generateCodeButton.layer.borderColor = UIColor.white.cgColor
        codeLabel.layer.cornerRadius = 10
        pasteCodeTextField.layer.cornerRadius = 10
        haveACodeButton.layer.cornerRadius = 10
        haveACodeButton.layer.borderWidth = 1
        haveACodeButton.layer.borderColor = UIColor.white.cgColor
        locManager.requestAlwaysAuthorization()
        pasteCodeTextField.delegate = self
        citySearchTextField.delegate = self
        placesTableView.dataSource = self
        placesTableView.delegate = self
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        if CLLocationManager.locationServicesEnabled() {
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyBest
            locManager.startUpdatingLocation()
            currentLocation = locManager.location
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pasteCodeTextField.resignFirstResponder()
        searchPlaceFromGoogle(place: citySearchTextField.text!)
//        placesTableView.isHidden = false
        return true
    }
    
    func searchPlaceFromGoogle(place: String) {
        var strGoogleApi = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(place)&key=AIzaSyCX7hPyTPm3vokTYYzuDumnEVCtwC_lvXE"
        strGoogleApi = strGoogleApi.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        var urlRequest = URLRequest(url: URL(string: strGoogleApi)!)
        urlRequest.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error == nil {
                
                if let responseData = data {
                    let jsonDict = try? JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                    
                    if let dict = jsonDict as? Dictionary<String, AnyObject> {
                        if let results = dict["results"] as? [Dictionary<String, AnyObject>] {
                            print("json = \(results)")
                            self.resultsArray.removeAll()
                            for dct in results {
                                self.resultsArray.append(dct)
                            }
                            DispatchQueue.main.async {
                                self.placesTableView.reloadData()
                            }
                        }
                    }
                }
            } else {
                // There is an error with google places API
            }
        }
        task.resume()
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
    
    // Mark: - Actions
    
    @IBAction func generateCodeButtonPressed(_ sender: Any) {
        codeLabel.isHidden = false
        pasteCodeTextField.isHidden = true
        codeLabel.text = randomAlphaNumericString(length: 10)
        userListTableView.isHidden = false
        copycodeButton.isHidden = false
        //        let game = Game(uid: <#T##String#>, users: <#T##[User]#>, city: <#T##String#>, radius: <#T##Double#>, mealType: <#T##String#>)
        //        Firebase.shared.createGame(game: <#T##Game#>)
    }
    
    @IBAction func haveACodeButtonPressed(_ sender: Any) {
        pasteCodeTextField.isHidden = false
        codeLabel.isHidden = true
        copycodeButton.isHidden = true
    }
    
    @IBAction func copyCodePressed(_ sender: Any) {
        UIPasteboard.general.string = codeLabel.text
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.synchronize()
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func radiusSlider(_ sender: Any) {
        radiusLabel.text = "\(Int(radiusSlider.value))"
    }
    
    @IBAction func citySearchTextFieldTapped(_ sender: Any) {
        placesTableView.isHidden = false
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
        if segue.identifier == "toSwipeScreenVC" {
            guard let destinationVC = segue.destination as? SwipeScreenViewController else {return}
            destinationVC.radius = Int(radiusSlider.value * 1600)
            //                destinationVC.location = currentLocation
            //                destinationVC.user = restaurantService.players
        }
    }
    
    // Mark: - UITableView DataSource & Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == placesTableView {
            return resultsArray.count
        } else if tableView == userListTableView {
            return 10
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == userListTableView {
            let cell = userListTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "Game Leader: \(user?.debugDescription ?? "")"
            return cell
        } else if tableView == placesTableView {
            let cell = placesTableView.dequeueReusableCell(withIdentifier: "placesCell")
            if let lblPlaceName = cell?.contentView.viewWithTag(102) as? UILabel {
                let place = self.resultsArray[indexPath.row]
                lblPlaceName.text = "\(place["formatted_address"] as! String)"
            }
            return cell!
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCity = resultsArray[indexPath.row]
        citySearchTextField.text = "\(selectedCity)"
    }
    
}//End of class
