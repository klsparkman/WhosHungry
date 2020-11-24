
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

class CreateGameDetailsViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // Mark: - Outlets
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var copycodeButton: UIButton!
    @IBOutlet weak var citySearchTextField: UITextField!
    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var placesTableView: UITableView!
    @IBOutlet weak var breakfastButton: UIButton!
    @IBOutlet weak var lunchButton: UIButton!
    @IBOutlet weak var dinnerButton: UIButton!
    @IBOutlet weak var dessertButton: UIButton!
    @IBOutlet weak var generateCodeButton: UIButton!
    @IBOutlet weak var createGameButton: UIButton!
    @IBOutlet weak var yourInviteCodeIsLabel: UILabel!
    @IBOutlet weak var whatCityLabel: UILabel!
    @IBOutlet weak var typeOfFoodLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    // Mark: - Properties
    static let shared = CreateGameDetailsViewController()
    var locManager = CLLocationManager()
    var currentLocation: CLLocation?
    var resultsArray: [Dictionary<String, AnyObject>] = Array()
    var mealType: String?
    var gameInviteCode: String?
    let db = Firestore.firestore()
    var currentUser = UserController.shared.currentUser
//    let submittedVotes: [Dictionary<String, Int>] = Array()
//    var users: [User] = []
    
    // Mark: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        StyleConstants.setTextFieldStyle(textField: citySearchTextField)
        StyleConstants.setLabelWhiteBorderStyle(label: whatCityLabel)
        StyleConstants.setLabelWhiteBorderStyle(label: radiusLabel)
        StyleConstants.setLabelWhiteBorderStyle(label: typeOfFoodLabel)
        StyleConstants.setLabelWhiteBorderStyle(label: distanceLabel)
        StyleConstants.setLabelBlackBorderStyle(label: codeLabel)
        StyleConstants.setLabelBlackBorderStyle(label: yourInviteCodeIsLabel)
        StyleConstants.setRadiusSliderStyle(slider: radiusSlider)
        StyleConstants.setButtonWhiteBorderStyle(button: generateCodeButton)
        StyleConstants.setButtonStyle(button: breakfastButton)
        StyleConstants.setButtonStyle(button: lunchButton)
        StyleConstants.setButtonStyle(button: dinnerButton)
        StyleConstants.setButtonStyle(button: dessertButton)
        copycodeButton.isHidden = true
        placesTableView.isHidden = true
        createGameButton.isHidden = true
        yourInviteCodeIsLabel.isHidden = true
        codeLabel.isHidden = true
        citySearchTextField.delegate = self
        placesTableView.dataSource = self
        placesTableView.delegate = self
        GameController.shared.updateViewWithRCValues()
        GameController.shared.fetchRemoteConfig()
//        locManager.requestAlwaysAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchPlaceFromGoogle(place: citySearchTextField.text!)
        citySearchTextField.resignFirstResponder()
        return true
    }

    func searchPlaceFromGoogle(place: String) {
        guard let api = GameController.shared.googleAPIKey else {return}
        let googleapi = api.replacingOccurrences(of: "\"", with: "")
        var strGoogleApi = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(place)&key=\(googleapi)"
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
    
    // Mark: - Actions
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func citySearchTextFieldTapped(_ sender: Any) {
        placesTableView.isHidden = false
    }
    
    @IBAction func radiusSlider(_ sender: Any) {
        radiusLabel.text = "\(Int(radiusSlider.value))"
    }
    
    @IBAction func breakfastButtonTapped(_ sender: Any) {
        breakfastButton.backgroundColor = .systemPink
        lunchButton.backgroundColor = .white
        dinnerButton.backgroundColor = .white
        dessertButton.backgroundColor = .white
        mealType = "breakfast"
    }
    
    @IBAction func lunchButtonTapped(_ sender: Any) {
        breakfastButton.backgroundColor = .white
        lunchButton.backgroundColor = .systemPink
        dinnerButton.backgroundColor = .white
        dessertButton.backgroundColor = .white
        mealType = "lunch"
    }
    
    @IBAction func dinnerButtonTapped(_ sender: Any) {
        breakfastButton.backgroundColor = .white
        lunchButton.backgroundColor = .white
        dinnerButton.backgroundColor = .systemPink
        dessertButton.backgroundColor = .white
        mealType = "dinner"
    }
    
    @IBAction func dessertButtonTapped(_ sender: Any) {
        breakfastButton.backgroundColor = .white
        lunchButton.backgroundColor = .white
        dinnerButton.backgroundColor = .white
        dessertButton.backgroundColor = .systemPink
        mealType = "dessert"
    }
    
    @IBAction func generateCodeButtonPressed(_ sender: Any) {
        codeLabel.isHidden = false
        yourInviteCodeIsLabel.isHidden = false
        codeLabel.text = GameController.shared.randomAlphaNumericString(length: 10)
        copycodeButton.isHidden = false
    }
    
    @IBAction func copyCodePressed(_ sender: Any) {
        UIPasteboard.general.string = "Your Who's Hungry invite code is: \(codeLabel.text!)"
        createGameButton.isHidden = false
    }
    
    @IBAction func createGameButtonPressed(_ sender: Any) {
        guard let currentUser = currentUser,
              let inviteCode = codeLabel.text,
              let city = citySearchTextField.text,
              let mealType = mealType,
              let radius = Double("\(radiusLabel.text!)")
//              let votes = submittedVotes
        else {return}
        let user = currentUser.firstName + " " + currentUser.lastName
//        let votes = Array(submittedVotes.map { ("\($0.keys) \($0.values)") })
        let game = Game(inviteCode: inviteCode, city: city, radius: radius, mealType: mealType, users: [user], submittedVotes: [], creatorID: currentUser.uid)
        Firebase.shared.createGame(game: game) { (result) in
            // MORE TO DO HERE!!!
            switch result {
            case .success(_):
                print("This worked!")
            case .failure(let error):
                print("Error saving game: \(error.localizedDescription)")
            }
        }
    }

    @IBAction func logoutButtonPressed(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            _ = self.navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "toUserListTVC" {
            guard let destinationVC = segue.destination as? UserListTableViewController else {return}
            destinationVC.radius = Double(radiusSlider.value * 1600)
            destinationVC.city = citySearchTextField.text
            destinationVC.category = mealType
            guard let currentUser = currentUser else {return}
            destinationVC.creatorID = "\(currentUser.firstName + " " + currentUser.lastName): Game Creator"
        }
    }
    
    // Mark: - UITableView DataSource & Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == placesTableView {
            return resultsArray.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = placesTableView.dequeueReusableCell(withIdentifier: "placesCell") else {return UITableViewCell()}
        if let placeName = cell.contentView.viewWithTag(102) as? UILabel {
            let place = self.resultsArray[indexPath.row]
            placeName.text = "\(place[Constants.address] as! String)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = resultsArray[indexPath.row]
        citySearchTextField.text = "\(selectedCity[Constants.address] as! String)"
        placesTableView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}//End of class




//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if (status == CLAuthorizationStatus.denied) {
//            showLocationDisabledPopup()
//        }
//    }
//
//    func showLocationDisabledPopup() {
//        let alertController = UIAlertController(title: "Background location access disabled.", message: "In order to pull restaurants in your area, we need your location.", preferredStyle: .alert)
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        alertController.addAction(cancelAction)
//
//        let openAction = UIAlertAction(title: "Open settings", style: .default) { (action) in
//            if let url = URL(string: UIApplication.openSettingsURLString) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            }
//        }
//        alertController.addAction(openAction)
//        self.present(alertController, animated: true, completion: nil)
//    }
