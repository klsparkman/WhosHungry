//
//  SignInViewController.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 9/1/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import UIKit
import Firebase
import AuthenticationServices
import FirebaseAuth

class SignInViewController: UIViewController {

    // Mark: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    
    // Mark: - Properties
    static var shared = SignInViewController()
    var loggedInCurrentUser: User?
    
    // Mark: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        UserController.shared.delegate = self
    
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser
            if let user = user {
                let uid = user.uid
//                guard let email = user.email else {return}
                var multiFactorString = "MultiFactor: "
                for info in user.multiFactor.enrolledFactors {
                    multiFactorString += info.displayName ?? "[DisplayName]"
                    multiFactorString += " "
                }
                let currentUser = User(firstName: multiFactorString, lastName: multiFactorString, email: "", uid: uid)
                print(multiFactorString)
                RestaurantController.shared.users.append(currentUser)
            }
//            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "gameChoiceVC") as? GameChoiceViewController {
//                if let navigator = navigationController {
//                    navigator.pushViewController(viewController, animated: true)
//                }
//            }
        }
//        else {
//            UserController.shared.performExistingAccountSetupFlows()
//        }
        titleLabel.UILabelTextShadow(color: UIColor.cyan)
        UIView.animate(withDuration: 3.0, delay: 0.2, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: .allowAnimatedContent, animations: {
            self.titleLabel.center = CGPoint(x: self.view.frame.maxX / 2, y: self.view.frame.maxY)
        }, completion: nil)
        setupView()
    }// End of ViewDidLoad
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        //        UIView.animate(withDuration: 3.0, delay: 0.2, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: .allowAnimatedContent, animations: {
        //            self.titleLabel.center = CGPoint(x: self.view.frame.maxX / 2, y: self.view.frame.maxY)
        //        }, completion: nil)
    }
    
    
    
    func setupView() {
        let appleButton = ASAuthorizationAppleIDButton()
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        view.addSubview(appleButton)
        NSLayoutConstraint.activate([
            appleButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
            appleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            appleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        ])
    }
    
    @objc func handleAuthorizationAppleIDButtonPress() {
        UserController.shared.didTapAppleButton(in: self)
    }
    
    func loginFailureAlert() {
        let alert = UIAlertController(title: "Error", message: "Please try signing in again", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default) { (_) in
            let viewController = SignInViewController()
            self.present(viewController, animated: true, completion: nil)
        }
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}//End of class

extension UILabel {
    func UILabelTextShadow(color: UIColor) {
        self.textColor = .cyan
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 8.0
        self.layer.shadowOpacity = 1.0
    }
}//End of extension

extension SignInViewController: UserControllerDelegate {
    func userLoggedIn(_ sender: Bool) {
        if sender == true {
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "gameChoiceVC") as? GameChoiceViewController {
                if let navigator = navigationController {
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        }
    }
}
