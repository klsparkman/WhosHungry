
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
    var users: [User]? = []
    var resultsArray: [Dictionary<String, AnyObject>] = Array()
    var mealType: String?
    var gameInviteCode: String?
    let db = Firestore.firestore()
    var currentUser = UserController.shared.currentUser
    
    // Mark: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        citySearchTextField.layer.cornerRadius = 10
        citySearchTextField.layer.borderColor = UIColor.black.cgColor
        citySearchTextField.layer.borderWidth = 1
        citySearchTextField.layer.masksToBounds = true
        
        whatCityLabel.layer.cornerRadius = 10
        whatCityLabel.layer.borderColor = UIColor.white.cgColor
        whatCityLabel.layer.borderWidth = 1
        whatCityLabel.layer.masksToBounds = true
        
        radiusLabel.layer.cornerRadius = 10
        radiusLabel.layer.borderColor = UIColor.white.cgColor
        radiusLabel.layer.borderWidth = 1
        radiusLabel.layer.masksToBounds = true
        
        typeOfFoodLabel.layer.cornerRadius = 10
        typeOfFoodLabel.layer.borderColor = UIColor.white.cgColor
        typeOfFoodLabel.layer.borderWidth = 1
        typeOfFoodLabel.layer.masksToBounds = true
        
        distanceLabel.layer.cornerRadius = 10
        distanceLabel.layer.borderColor = UIColor.white.cgColor
        distanceLabel.layer.borderWidth = 1
        distanceLabel.layer.masksToBounds = true
        
        radiusSlider.layer.cornerRadius = 10
        radiusSlider.layer.borderColor = UIColor.white.cgColor
        radiusSlider.layer.borderWidth = 1
        radiusSlider.layer.masksToBounds = true
        
        codeLabel.isHidden = true
        codeLabel.layer.cornerRadius = 10
        codeLabel.layer.borderColor = UIColor.black.cgColor
        codeLabel.layer.borderWidth = 1
        codeLabel.layer.masksToBounds = true
        
        yourInviteCodeIsLabel.isHidden = true
        yourInviteCodeIsLabel.layer.cornerRadius = 10
        yourInviteCodeIsLabel.layer.borderColor = UIColor.black.cgColor
        yourInviteCodeIsLabel.layer.borderWidth = 1
        yourInviteCodeIsLabel.layer.masksToBounds = true
        
        copycodeButton.isHidden = true
        placesTableView.isHidden = true
        createGameButton.isHidden = true
//        radiusLabel.isHidden = true
        
        generateCodeButton.layer.cornerRadius = 10
        generateCodeButton.layer.borderWidth = 1
        generateCodeButton.layer.borderColor = UIColor.white.cgColor
        
        breakfastButton.layer.cornerRadius = 10
        breakfastButton.layer.borderColor = UIColor.black.cgColor
        breakfastButton.layer.borderWidth = 1
        
        lunchButton.layer.cornerRadius = 10
        lunchButton.layer.borderColor = UIColor.black.cgColor
        lunchButton.layer.borderWidth = 1
        
        dinnerButton.layer.cornerRadius = 10
        dinnerButton.layer.borderColor = UIColor.black.cgColor
        dinnerButton.layer.borderWidth = 1
        
        dessertButton.layer.cornerRadius = 10
        dessertButton.layer.borderColor = UIColor.black.cgColor
        dessertButton.layer.borderWidth = 1
        
        locManager.requestAlwaysAuthorization()
        citySearchTextField.delegate = self
        placesTableView.dataSource = self
        placesTableView.delegate = self
//        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
//        view.addGestureRecognizer(tap)
        
        //        if CLLocationManager.locationServicesEnabled() {
        //            locManager.delegate = self
        //            locManager.desiredAccuracy = kCLLocationAccuracyBest
        //            locManager.startUpdatingLocation()
        //            currentLocation = locManager.location
        //        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch: UITouch? = touches.first
//        if touch?.view != placesTableView {
//            placesTableView.isHidden = true
//        }
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchPlaceFromGoogle(place: citySearchTextField.text!)
        citySearchTextField.resignFirstResponder()
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
        var randomString = ""
        
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
        yourInviteCodeIsLabel.isHidden = false
        codeLabel.text = randomAlphaNumericString(length: 10)
        copycodeButton.isHidden = false
    }
    
    @IBAction func copyCodePressed(_ sender: Any) {
        UIPasteboard.general.string = "Your Who's Hungry invite code is: \(codeLabel.text!)"
        createGameButton.isHidden = false
    }
    
    @IBAction func createGameButtonPressed(_ sender: Any) {
        guard let inviteCode = codeLabel.text,
              let users = users,
              let city = citySearchTextField.text,
              let mealType = mealType,
              let radius = Double("\(radiusLabel.text!)"),
              let creatorID = currentUser?.uid
        else {return}
        gameInviteCode?.append(inviteCode) ?? nil
        let game = Game(inviteCode: inviteCode, users: users, city: city, radius: radius, mealType: mealType, creatorID: creatorID)
        Firebase.shared.createGame(game: game) { (result) in
            // MORE TO DO HERE!!!
            switch result {
            case .success(let game):
                print("Game saved successfully: \(game)")
            case .failure(let error):
                print("Error saving game: \(error)")
            }
        }
        
        //        db.collection(Constants.userContainer).document(Constants.user).setData([Constants.inviteCode : inviteCode], merge: true)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
    
    @IBAction func radiusSlider(_ sender: Any) {
        radiusLabel.text = "\(Int(radiusSlider.value))"
    }
    
    @IBAction func citySearchTextFieldTapped(_ sender: Any) {
        placesTableView.isHidden = false
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
        if segue.identifier == "toUserListTVC" {
            guard let destinationVC = segue.destination as? UserListTableViewController else {return}
            destinationVC.radius = Double(radiusSlider.value * 1600)
            destinationVC.city = citySearchTextField.text
            destinationVC.category = mealType
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
}//End of class
