
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
    @IBOutlet weak var distanceLabel: UILabel!
    
    // Mark: - Properties
    var resultsArray: [Dictionary<String, AnyObject>] = Array()
    var mealType: String?
    let db = Firestore.firestore()
    var currentUser = UserController.shared.currentUser
    var inviteCode: String?
    
    // Mark: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        StyleConstants.setTextFieldStyle(textField: citySearchTextField)
        StyleConstants.setLabelWhiteBorderStyle(label: radiusLabel)
        StyleConstants.setLabelWhiteBorderStyle(label: distanceLabel)
        StyleConstants.setRadiusSliderStyle(slider: radiusSlider)
        StyleConstants.setButtonStyle(button: breakfastButton)
        StyleConstants.setButtonStyle(button: lunchButton)
        StyleConstants.setButtonStyle(button: dinnerButton)
        StyleConstants.setButtonStyle(button: dessertButton)
        StyleConstants.setButtonStyle(button: generateCodeButton)
        placesTableView.isHidden = true
        citySearchTextField.delegate = self
        placesTableView.dataSource = self
        placesTableView.delegate = self
        GameController.shared.updateViewWithRCValues()
        GameController.shared.fetchRemoteConfig()
        radiusLabel.text = "\(15) miles"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        createGameButton.isHidden = true
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
                print("There is an error with google places API: \(error!.localizedDescription)")
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
        radiusLabel.text = "\(Int(radiusSlider.value)) miles"
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
            if radiusLabel.text != "" {
                if self.mealType != nil  {
                    if citySearchTextField.text != "" {
                        let inviteCode = GameController.shared.randomAlphaNumericString(length: 10)
                    inviteCodeCreatedPopup(inviteCode: inviteCode)
                    self.inviteCode = inviteCode
                    UIPasteboard.general.string = "Your Who's Hungry invite code is: \(inviteCode)"
                } else {
                    fillInAllFields()
                }
            } else {
                fillInAllFields()
            }
        } else {
            fillInAllFields()
        }
    }
    
    @IBAction func createGameButtonPressed(_ sender: Any) {
        guard let currentUser = currentUser,
              let inviteCode = self.inviteCode,
              let city = citySearchTextField.text,
              let mealType = mealType,
              let radius = Double("\(radiusLabel.text!)".replacingOccurrences(of: " miles", with: ""))
        else {return}
        let gameHasBegun = false
        let winningRestaurant = ""
        let user = "\(currentUser.firstName + " " + currentUser.lastName): Game Creator"
        let game = Game(inviteCode: inviteCode, city: city, radius: radius, mealType: mealType, users: [user], gameHasBegun: gameHasBegun, winningRestaurant: winningRestaurant)
        Firebase.shared.createGame(game: game) { (result) in
            // MORE TO DO HERE!!!
            switch result {
            case .success(_):
                print(self.currentUser!.isGameCreator) 
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
    
    func fillInAllFields() {
        let alert = UIAlertController(title: "HOLD UP!", message: "Make sure all fields are filled out to continue!", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Roger that", style: .cancel, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    func inviteCodeCreatedPopup(inviteCode : String) {
        let alert = UIAlertController(title: "Success!", message: "Your invite code: \(inviteCode) has been saved to your clipboard", preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true, completion: nil)
            self.createGameButton.isHidden = false
        }
    }
}//End of class
