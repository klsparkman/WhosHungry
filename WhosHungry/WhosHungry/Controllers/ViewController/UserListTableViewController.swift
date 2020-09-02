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
    var city: String?
    var radius: Double?
    var category: String?
    var inviteCode: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
//        Firebase.shared.getUserCollection()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RestaurantController.shared.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        let user = RestaurantController.shared.users[indexPath.row]
        cell.textLabel?.text = user.firstName + user.lastName
        return cell
    }
    
    // Mark: - Actions
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

//     MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "toSwipeScreenVC" {
            guard let destinationVC = segue.destination as? SwipeScreenViewController else {return}
            destinationVC.radius = radius
            destinationVC.city = city
            destinationVC.category = category
        }
    }
}
