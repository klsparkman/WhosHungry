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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pasteCodeTextField.isHidden = true
        joinThePartyButton.isHidden = true
        createGameButton.layer.cornerRadius = 30
        joinGameButton.layer.cornerRadius = 30
        pasteCodeTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func createGameButtonTapped(_ sender: Any) {
    }
    
    @IBAction func joinGameButtonTapped(_ sender: Any) {
//        pasteCodeTextField.resignFirstResponder()
        pasteCodeTextField.isHidden = false
        if pasteCodeTextField != nil {
            joinThePartyButton.isHidden = false
        }
    }
    
    @IBAction func joinThePartyButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func inviteCodeTextFieldTapped(_ sender: Any) {
        pasteCodeTextField.becomeFirstResponder()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "toUserListVC" {
            guard let destinationVC = segue.destination as? UserListTableViewController else {return}
            destinationVC.inviteCode = pasteCodeTextField.text
        }
    }
    
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
//        navigationController?.popToViewController(SignInViewController(), animated: true)
//        self.navigationController?.popToViewController(SignInViewController())
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            _ = self.navigationController?.popViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
//        UserDefaults.standard.set(false, forKey: "isLoggedIn")
//        UserDefaults.standard.synchronize()
    }
}
