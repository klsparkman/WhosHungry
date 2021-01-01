//
//  UserListTableViewController.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 8/24/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import UIKit

class UserListTableViewController: UITableViewController {
    
    @IBOutlet weak var letsBeginButton: UIBarButtonItem!
    
    // Mark: - Properties
    static var shared = UserListTableViewController()
    var city: String?
    var radius: Double?
    var category: String?
    var inviteCode: String?
    var creatorID: String?
    var players: [String] = []
    let currentUser = UserController.shared.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Lets Begin", style: .plain, target: self, action: #selector(buttonTapped))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc func buttonTapped() {
        
        if currentUser?.isGameCreator == true {
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "swipeScreenVC") as? SwipeScreenViewController {
                if let navigator = navigationController {
                    navigator.pushViewController(viewController, animated: true)
                    Firebase.shared.stopListener()
                    let destinationVC = SwipeScreenViewController()
                    destinationVC.radius = self.radius
                    destinationVC.city = self.city
                    destinationVC.category = self.category
                    Firebase.shared.startGame()
                }
            }
        } else if currentUser?.isGameCreator == false {
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "swipeScreenVC") as? SwipeScreenViewController {
                if let navigator = navigationController {
                    navigator.pushViewController(viewController, animated: true)
                    let destinationVC = SwipeScreenViewController()
                    destinationVC.radius = self.radius
                    destinationVC.city = self.city
                    destinationVC.category = self.category
                }
            }
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        super.prepare(for: segue, sender: sender)
//        if segue.identifier == "toSwipeScreenVC" {
//            Firebase.shared.stopListener()
//            guard let destinationVC = segue.destination as? SwipeScreenViewController else {return}
//            destinationVC.radius = self.radius
//            destinationVC.city = self.city
//            destinationVC.category = self.category
//            Firebase.shared.startGame()
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        for player in players {
            if player.contains(": Game Creator") {
                Firebase.shared.checkGameStatus { (result) in
                    switch result {
                    case .success(true):
                        Firebase.shared.stopGame()
                    case .success(false):
                        print("Something went wrong, this should have been true...")
                    case .failure(let error):
                        print("There was an error checking game status: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Firebase.shared.listenForUsers { (result) in
            self.players = []
            for player in result {
                self.players.append(player)
                self.tableView.reloadData()
            }
            if self.currentUser!.isGameCreator == true {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            } else {
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        cell.textLabel?.text = players[indexPath.row]
        return cell
    }
    
    // Mark: - Actions
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation
}
