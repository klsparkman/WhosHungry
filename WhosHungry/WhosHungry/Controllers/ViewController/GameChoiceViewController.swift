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
//    var gameHasBegun: Bool
    
    // Mark: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        pasteCodeTextField.isHidden = true
        joinThePartyButton.isHidden = true
        createGameButton.layer.cornerRadius = 30
        joinGameButton.layer.cornerRadius = 30
        joinThePartyButton.layer.cornerRadius = 20
        joinThePartyButton.layer.borderWidth = 2
        joinThePartyButton.layer.borderColor = UIColor.white.cgColor
        self.pasteCodeTextField.delegate = self
        GameController.shared.updateViewWithRCValues()
        GameController.shared.fetchRemoteConfig()
        UserListTableViewController.shared.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    //     Mark: - Actions
    @IBAction func createGameButtonTapped(_ sender: Any) {
    }
    
    @IBAction func joinGameButtonTapped(_ sender: Any) {
        pasteCodeTextField.isHidden = false
        if pasteCodeTextField != nil {
        }
    }
    
    @IBAction func joinThePartyButtonTapped(_ sender: Any) {
    }
    
    @IBAction func inviteCodeTextFieldTapped(_ sender: Any) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        joinThePartyButton.isHidden = false
        fixInviteCode()
       
        guard let inviteCode = self.trimmedInviteCode else {return false}
        Firebase.shared.fetchGame(withinviteCode: inviteCode) { (result) in
            switch result {
            case .failure(let error):
                print("There is an error fetching a game with that invite code: \(error.localizedDescription)")
            case.success(_):
                Firebase.shared.updateUserList(inviteCode: inviteCode)
            }
        }
        return false
    }
    
    func fixInviteCode(){
        let inviteCode = pasteCodeTextField.text!
        if pasteCodeTextField.text!.count > 10 {
            let trimmedInviteCode = inviteCode.replacingOccurrences(of: "Your Who's Hungry invite code is:", with: "")
            self.trimmedInviteCode = trimmedInviteCode
        } else {
            self.trimmedInviteCode = inviteCode
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        super.prepare(for: segue, sender: sender)
//        if segue.identifier == "toUserListVC" {
//            guard let game = Firebase.shared.currentGame else {return}
//            guard let destinationVC = segue.destination as? UserListTableViewController else {return}
//            destinationVC.category = game.mealType
//            destinationVC.city = game.city
//            destinationVC.radius = game.radius * 1600
//        }
//    }
    
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
    
    extension GameChoiceViewController: UserListTableViewControllerDelegate {
        func gameHasBegun(_ sender: Bool) {
            if sender == true {
                gameHasAlreadyBegun()
            } else {
                if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "toUserListVC") as? UserListTableViewController {
                    guard let game = Firebase.shared.currentGame else {return}
                    viewController.category = game.mealType
                    viewController.city = game.city
                    viewController.radius = game.radius * 1600
                    if let navigator = navigationController {
                        navigator.pushViewController(viewController, animated: true)
                    }
                }
            }
        }

        func gameHasAlreadyBegun() {
            let alert = UIAlertController(title: "You were too slow!", message: "So sorry, the game has already begun and is too late to join.", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Guess I'm eating alone tonight", style: .cancel, handler: nil)
            alert.addAction(okButton)
            present(alert, animated: true, completion: nil)
        }
    }
