//
//  AppDelegate.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 4/15/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import UIKit
import Firebase
import AuthenticationServices

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        let userLoginStatus = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        
        if (userLoginStatus) == true {
            self.window?.rootViewController!.performSegue(withIdentifier: "segue", sender: nil)
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let viewController: UserListViewController = storyboard.instantiateViewController(identifier: "userListVC") as! UserListViewController
            
//            let rootViewController = self.window!.rootViewController!
//            rootViewController.pushViewController(viewController, animated: true)
//            rootViewController.present(viewController, animated: true, completion: nil)
//            let viewController = UserListViewController()
//                    window = UIWindow(frame: UIScreen.main.bounds)
//                    window?.makeKeyAndVisible()
//                    window?.rootViewController = UserListViewController()
//            self.window?.rootViewController?.present(viewController, animated: true, completion: nil)
            
        } else {
            let viewController = LoginViewController()
            self.window?.rootViewController?.present(viewController, animated: true, completion: nil)
        }

        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

