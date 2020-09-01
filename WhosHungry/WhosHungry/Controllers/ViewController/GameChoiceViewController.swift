//
//  GameChoiceViewController.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 8/24/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import UIKit

class GameChoiceViewController: UIViewController {
    
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func createGameButtonTapped(_ sender: Any) {
    }
    
    @IBAction func joinGameButtonTapped(_ sender: Any) {
        pasteCodeTextField.resignFirstResponder()
        pasteCodeTextField.isHidden = false
        if pasteCodeTextField != nil {
            joinThePartyButton.isHidden = false
        }
    }
    
}
