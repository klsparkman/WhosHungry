//
//  UserListTableViewController.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 8/24/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import UIKit

protocol UserListTableViewControllerDelegate: class {
    func gameHasBegun(_ sender: Bool) 
}

class UserListTableViewController: UITableViewController {
    
    @IBOutlet weak var letsBeginButton: UIBarButtonItem!
    
    // Mark: - Properties
    static var shared = UserListTableViewController()
    var city: String?
    var radius: Double?
    var category: String?
    var inviteCode: String?
    var currentPlayers: [String] = []
    var creatorID: String?
    var players: [String] = []
    weak var delegate: UserListTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.letsBeginButton.isEnabled = false
//        self.navigationItem.rightBarButtonItem = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Firebase.shared.listenForUsers { (result) in
            self.players = []
            for player in result {
                self.players.append(player)
            }
            self.tableView.reloadData()
            for player in self.players {
                if player.contains(": Game Creator") == true {
                    self.letsBeginButton.isEnabled = true
                } else {
                    self.letsBeginButton.isEnabled = false
                }
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
    
    //     MARK: - Navigation
    
    //****Need to deactivate your listener when you segue to SwipeScreenVC!!!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "toSwipeScreenVC" {
            guard let destinationVC = segue.destination as? SwipeScreenViewController else {return}
            destinationVC.radius = self.radius
            destinationVC.city = self.city
            destinationVC.category = self.category
            self.delegate?.gameHasBegun(true)
        }
    }
}
