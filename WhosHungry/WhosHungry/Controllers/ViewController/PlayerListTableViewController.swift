//
//  PlayerListTableViewController.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 4/16/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import UIKit

class PlayerListTableViewController: UITableViewController {
    
    // Mark: - Properties
    
    // Mark: - Outlets
    @IBOutlet var userNameCell: UITableViewCell!
    
    // Mark: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        UserController.shared.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userNameCell", for: indexPath)
        let user = UserController.shared.users[indexPath.row]
        cell.textLabel?.text = user.name
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
