//
//  GameChoiceViewController.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 8/24/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import UIKit
import Firebase

class GameChoiceViewController: UIViewController, UITextFieldDelegate {
    
    // Mark: - Outlets
    @IBOutlet weak var pasteCodeTextField: UITextField!
    @IBOutlet weak var joinThePartyButton: UIButton!
    @IBOutlet weak var createGameButton: UIButton!
    @IBOutlet weak var joinGameButton: UIButton!
    
    // Mark: - Properties
    static let shared = GameChoiceViewController()
    var currentUser = UserController.shared.currentUser
    let db = Firestore.firestore()
    let remoteConfig = RemoteConfig.remoteConfig()
    var trimmedInviteCode: String?
    
    // Mark: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        pasteCodeTextField.isHidden = true
        joinThePartyButton.isHidden = true
        createGameButton.layer.cornerRadius = 30
        joinGameButton.layer.cornerRadius = 30
        self.pasteCodeTextField.delegate = self
        GameController.shared.updateViewWithRCValues()
        GameController.shared.fetchRemoteConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //     Mark: - Actions
    @IBAction func createGameButtonTapped(_ sender: Any) {
    }
    
    @IBAction func joinGameButtonTapped(_ sender: Any) {
        pasteCodeTextField.isHidden = false
        if pasteCodeTextField != nil {
            joinThePartyButton.isHidden = false
        }
    }
    
    @IBAction func joinThePartyButtonTapped(_ sender: Any) {
//        Firebase.shared.addUserToGame(inviteCode: pasteCodeTextField.text!)
    }
    
    @IBAction func inviteCodeTextFieldTapped(_ sender: Any) {
        //        pasteCodeTextField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func fixInviteCode(){
        let inviteCode = pasteCodeTextField.text!
        if pasteCodeTextField.text!.count > 10 {
            let trimmedInviteCode = inviteCode.replacingOccurrences(of: "Your Who's Hungry invite code is: ", with: "")
            self.trimmedInviteCode = trimmedInviteCode
            print(trimmedInviteCode)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        fixInviteCode()
        guard let inviteCode = self.trimmedInviteCode else {return}
        Firebase.shared.fetchGame(withinviteCode: inviteCode) { (result) in
            switch result {
            case .failure(let error):
                print("There is an error fetching a game with that invite code: \(error.localizedDescription)")
            case.success(let game):
                Firebase.shared.addUserToGame(inviteCode: inviteCode)
                if let game = game {
                    Firebase.shared.currentGame = game
                    if segue.identifier == "toUserListVC" {
                        guard let destinationVC = segue.destination as? UserListTableViewController else {return}
                        destinationVC.category = game.mealType
                        destinationVC.city = game.city
                        destinationVC.radius = game.radius
                    }
                }
            }
        }
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            _ = self.navigationController?.popViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

//Your Who's Hungry invite code is: alWi7E95PR
