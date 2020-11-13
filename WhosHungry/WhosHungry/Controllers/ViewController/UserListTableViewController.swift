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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //****Maybe add your listener here??
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
//        guard let game = Firebase.shared.currentGame else {return}
//        Firebase.shared.getUserCollection(currentGame: game)
        self.tableView.reloadData()
//        fetchGameUsers()
    }
    
    //    func fetchGameUsers() {
    //        guard let inviteCode = self.inviteCode else {return}
    //        Firebase.shared.fetchGame(withinviteCode: inviteCode) { (result) in
    //            switch result {
    //            case .failure(let error):
    //                print("There was an error attempting to get the users in your game! \(error.localizedDescription)")
    //            case.success(let game):
    //                if let game = game {
    //                    self.currentPlayers.append(contentsOf: game.users)
    //                }
    //            }
    //        }
    //    }
    
//    func fetchGameUsers() {
//        guard let game = Firebase.shared.currentGame else {return}
//        Firebase.shared.fetchUsersWithListeners(game: game) { (result) in
//            switch result {
//            case .failure(let error):
//                print("Error fetching users from Firebase: \(error.localizedDescription)")
//            case .success(let user):
//                if let user = user {
//                    RestaurantController.shared.users.append(user)
//                }
//            }
//        }
//    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RestaurantController.shared.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        let user = RestaurantController.shared.users[indexPath.row]
        cell.textLabel?.text = user.firstName + " " + user.lastName
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
