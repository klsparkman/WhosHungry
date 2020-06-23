//
//  InitialViewController.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 4/15/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import UIKit
import Firebase

class InitialViewController: UIViewController {
    
    private let db = Firestore.firestore()

    // Mark: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var faqButton: UIButton!
    @IBOutlet weak var signMeUpButton: UIButton!
    
    // Mark: - Properties
//    var safeArea: UILayoutGuide {
//        return self.view.safeAreaLayoutGuide
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        signMeUpButton.isHidden = true
    }
    
    // Mark: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)
        }
        self.titleLabel.UILabelTextShadow(color: UIColor.cyan)
        UIView.animate(withDuration: 3.0, delay: 0.2, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: .allowAnimatedContent, animations: {
            self.titleLabel.center = CGPoint(x: self.view.frame.maxX / 2, y: self.view.frame.maxY)
        }, completion: nil)
        setUpUI()
    }
    
    fileprivate func setUpUI() {
        signUpButton.rotate()
        loginButton.rotate()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        toggleToLogin()
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        toggleToSignUp()
    }
    
    private func toggleToLogin() {
        UIView.animate(withDuration: 0.2) {
            self.loginButton.tintColor = UIColor.black
            self.signUpButton.tintColor = UIColor.lightGray
            self.signMeUpButton.setTitle("Log Me In", for: .normal)
            self.confirmTextField.isHidden = true
            self.helpButton.setTitle("Forgot?", for: .normal)
            self.faqButton.setTitle("Remind", for: .normal)
        }
    }
    
    private func toggleToSignUp() {
        UIView.animate(withDuration: 0.2) {
            self.loginButton.tintColor = UIColor.lightGray
            self.signUpButton.tintColor = UIColor.black
            self.signMeUpButton.setTitle("Sign Me Up", for: .normal)
            self.confirmTextField.isHidden = false
            self.helpButton.setTitle("Help?", for: .normal)
            self.faqButton.setTitle("FAQ", for: .normal)
        }
    }
    
    fileprivate func segueToUserList() {
       let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(identifier: "userListVC") as? UserListViewController {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension UILabel {
    func UILabelTextShadow(color: UIColor) {
        self.textColor = .cyan
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 8.0
        self.layer.shadowOpacity = 1.0
    }
}
