//
//  ResultsViewController.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 10/27/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    
    static let shared = ResultsViewController()
    var voteDict: [String : Int] = [:]
    var snapshotListenerData: [String : Any] = [:]
    var submittedVoteArray: [String] = []
    
    @IBOutlet weak var restaurantRestultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        comparingSubmittedVotes()
//        submittedVoteArray = SwipeScreenViewController.shared.likedRestaurants
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
        Firebase.shared.startListener {
            self.submittedVoteArray
        }
    }
    
//    func comparingSubmittedVotes() {
//        guard let gameUID = Firebase.shared.currentGame?.uid else {return}
//        guard let game = Firebase.shared.currentGame else {return}
//        
//        Firebase.shared.listenForSubmittedVotes(gameUID: gameUID) { (result) in
//            switch result {
//            case .failure(let error):
//                print(error.localizedDescription)
//            case .success(_):
//                Firebase.shared.fetchGame(withinviteCode: game.inviteCode) { (result) in
//                    switch result {
//                    case .success(let game):
//                        if let game = game {
//                            
//                            if game.submittedVotes.count == game.users.count {
//                                
//                                let arrays = game.submittedVotes
//                                print(arrays)
//                                //                            for subarray in arrays {
//                                //                                for element in subarray {
//                                //                                    print(element)
//                                //                                }
//                                //                            }
//                            }
//                            
//                            
//                        }
//                    case .failure(let error):
//                        print(error.localizedDescription)
//                    }
//                }
//            }
//        }
//    }
    
    
    
    
}// End of class
