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
            guard let userID = Auth.auth().currentUser?.uid else {return}
            Firebase.shared.fetchUser(withID: userID) { (result) in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case . success(let user):
                    if let user = user {
                        UserController.shared.currentUser = user
                        RestaurantController.shared.users.append(user)
                        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "gameChoiceVC") as? GameChoiceViewController {
                            if let navigator = self.navigationController {
                                navigator.pushViewController(viewController, animated: true)
                            }
                        }
                    }
                }
            }
        } else {
            self.animateTitle()
            self.setupView()
        }
    }// End of ViewDidLoad
    
    func animateTitle() {
        self.titleLabel.UILabelTextShadow(color: UIColor.cyan)
        titleLabel.alpha = 0
        titleLabel.fadeIn(duration: 2.8, delay: 0.2)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        titleLabel.alpha = 0
        self.animateTitle()
        self.setupView()
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
}//End of UILabel extension

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
}// End of SignInVC extension

extension UIView {
    func fadeIn(duration: TimeInterval, delay: TimeInterval, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
}
