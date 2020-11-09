//
//  GameController.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 10/1/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import Foundation
import Firebase

class GameController: NSObject {
    
    // Mark: - Properties
    static var shared = GameController()
    let db = Firestore.firestore()
    let remoteConfig = RemoteConfig.remoteConfig()
    var googleAPIKey: String?
    var yelpAPIKey: String?
    
    private override init() {
        super.init()
    }
    
    func fetchRemoteConfig() {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        self.remoteConfig.fetch { [unowned self] (status, error) in
            if status == .success {
                self.remoteConfig.activate { (changed, error) in
                    self.updateViewWithRCValues()
                }
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }
    
    func updateViewWithRCValues() {
        DispatchQueue.main.async {
            let rc = RemoteConfig.remoteConfig()
            let yelpKey = rc.configValue(forKey: Constants.yelpAPIKey).stringValue ?? ""
            let googleKey = rc.configValue(forKey:Constants.googleAPIKey).stringValue ?? ""
            self.yelpAPIKey = yelpKey
            self.googleAPIKey = googleKey
        }
    }
    
    func updateSubmittedVotes() {
        
    }
   
}//End of Class
