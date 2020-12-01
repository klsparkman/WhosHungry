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
    var currentPlayers: [String] = []
    var creatorID: String?
//    var players: String?
    var players: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //****Maybe add your listener here??
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
//        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Firebase.shared.listenForUsers { (result) in
            self.players = []
            for player in result {
                self.players.append(player)
            }

            print("PLAYERS: \(result)")
            self.tableView.reloadData()
        } 
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let players = players else {return 0}
        return players.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
//        guard let players = players else {return UITableViewCell()}
//        for player in players {
//            cell.textLabel?.text = player
//        }
        cell.textLabel?.text = players[indexPath.row]
//        cell.textLabel?.text = players.map( {$0} )
//        let user = RestaurantController.shared.users[indexPath.row]
//        cell.textLabel?.text = self.creatorID
//        cell.textLabel?.text = user.firstName + " " + user.lastName
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
        }
    }
}
