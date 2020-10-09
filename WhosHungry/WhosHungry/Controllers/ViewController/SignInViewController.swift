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
    
    // Mark: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        UserController.shared.delegate = self
        if let currentUser = Auth.auth().currentUser {
//            let uid = currentUser.uid
//            Firebase.shared.fetchUser(withID: uid) { (result) in
//                switch result {
//                case .success(let user):
//                    GameController.shared.addUserToGame(inviteCode: <#T##String#>)
//                    RestaurantController.shared.users.append(user!)
//                case .failure(let error):
//                    print("Error fetching user in automatic signIn: \(error.localizedDescription)")
//                }
//            }
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "gameChoiceVC") as? GameChoiceViewController {
                if let navigator = navigationController {
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        }
//        else {
//            UserController.shared.performExistingAccountSetupFlows()
//        }
        titleLabel.UILabelTextShadow(color: UIColor.cyan)
        UIView.animate(withDuration: 3.0, delay: 0.2, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: .allowAnimatedContent, animations: {
            self.titleLabel.center = CGPoint(x: self.view.frame.maxX / 2, y: self.view.frame.maxY)
        }, completion: nil)
        setupView()
    }
    
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
        appleButton.addTarget(self, action: #selector(didTapAppleButton), for: .touchUpInside)
        view.addSubview(appleButton)
        NSLayoutConstraint.activate([
            appleButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
            appleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            appleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        ])
    }
    
    @objc func didTapAppleButton() {
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
