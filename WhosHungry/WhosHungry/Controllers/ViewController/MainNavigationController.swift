//
//  MainNavigationController.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 7/18/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

//import UIKit
//import Firebase
//
//class MainNavigationController: UINavigationController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        if Auth.auth().currentUser != nil {
//            self.performSegue(withIdentifier: "segue", sender: nil)
//        }
//    
//            view.backgroundColor = .cyan
//    
//            if isLoggedIn() {
//                let userController = UserListViewController()
//                viewControllers = [userController]
//            } else {
//                perform(#selector(showLoginController), with: nil, afterDelay: 0.01)
//            }
//        }
//
//    
//    func showLoginController() {
//            let loginController = LoginViewController()
//            present(loginController, animated: true, completion: {
//            })
//        }
//    
//        fileprivate func isLoggedIn() -> Bool {
//            return UserDefaults.standard.bool(forKey: Keys.loggedIn)
//        }
//}// End of Class


