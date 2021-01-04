//
//  UserListTableViewController.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 8/24/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import UIKit

class UserListTableViewController: UITableViewController {
    
    // Mark: - Properties
    static var shared = UserListTableViewController()
    var city: String?
    var radius: Double?
    var category: String?
    var inviteCode: String?
    var creatorID: String?
    var players: [String] = []
    let currentUser = UserController.shared.currentUser
    
    // Mark: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Lets Begin", style: .plain, target: self, action: #selector(buttonTapped))
        
        if self.currentUser!.isGameCreator == true {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
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
        listenForUsers()
        listenForGameStart()
    }
    
    @objc func buttonTapped() {
        Firebase.shared.stopUserListener()
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "swipeScreenVC") as? SwipeScreenViewController {
            if let navigator = navigationController {
                Firebase.shared.stopListener()
                navigator.pushViewController(viewController, animated: true)
                let destinationVC = SwipeScreenViewController()
                destinationVC.radius = self.radius
                destinationVC.city = self.city
                destinationVC.category = self.category
                Firebase.shared.startGame()
            }
        }
    }
    
    func listenForUsers() {
        Firebase.shared.listenForUsers { (result) in
            self.players = []
            for player in result {
                if self.players.count <= 10 {
                    self.players.append(player)
                } else {
                    self.maxPlayersJoined()
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func listenForGameStart() {
        Firebase.shared.listenForStartGame { (result) in
            if result == true {
                if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "swipeScreenVC") as? SwipeScreenViewController {
                    if let navigator = self.navigationController {
                        navigator.pushViewController(viewController, animated: true)
                        Firebase.shared.stopListener()
                        let destinationVC = SwipeScreenViewController()
                        destinationVC.radius = self.radius
                        destinationVC.city = self.city
                        destinationVC.category = self.category
                        Firebase.shared.startGame()
                    }
                }
            }
        }
    }
    
    func maxPlayersJoined() {
        let alert = UIAlertController(title: "Sorry my friend!", message: "The game has already reached the max number of players allowed.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
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
}//End of Class
