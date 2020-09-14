//
//  MainNavigationController.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 7/18/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import UIKit


class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signInVC") as UIViewController
        self.present(viewController, animated: true, completion: nil)
        
//        let viewController = SignInViewController()
//        self.navigationController?.pushViewController(SignInViewController(), animated: true)
        }
    
       
}// End of Class


