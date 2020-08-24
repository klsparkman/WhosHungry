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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        pasteCodeTextField.isHidden = true
        joinThePartyButton.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func createGameButtonTapped(_ sender: Any) {
    }
    
    @IBAction func joinGameButtonTapped(_ sender: Any) {
        pasteCodeTextField.isHidden = false
        if pasteCodeTextField != nil {
            joinThePartyButton.isHidden = false
        }
    }
    
}
