
//
//  UserListViewController.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 4/17/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MPCManagerDelegate {
    
    // Mark: - Outlets
    @IBOutlet weak var peersTableView: UITableView!
    
    // Mark: - Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var isAdvertising: Bool!
    
    // Mark: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        peersTableView.delegate = self
        peersTableView.dataSource = self
        appDelegate.mpcManager.delegate = self
        appDelegate.mpcManager.browser.startBrowsingForPeers()
        appDelegate.mpcManager.advertiser.startAdvertisingPeer()
        isAdvertising = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        appDelegate.mpcManager.foundPeers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peerCell", for: indexPath)
        cell.textLabel?.text = appDelegate.mpcManager.foundPeers[indexPath.row].displayName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60.0
    }
    
    func foundPeer() {
        peersTableView.reloadData()
    }
    
    func lostPeer() {
        peersTableView.reloadData()
    }
    
    func invitationWasReceived(fromPeer: String) {
        
    }
    
//    func connectedWithPeer(peerID: MCPeerID) {
//
//    }
    
    @IBAction func startStopAdvertising(_ sender: Any) {
        let actionSheet = UIAlertController(title: "", message: "Change Visibility", preferredStyle: .actionSheet)
        var actionTitle: String
        if isAdvertising == true {
            actionTitle = "Make me invisible to others"
        }
        else {
            actionTitle = "Make me visible to others"
        }
        let visibilityAction: UIAlertAction = UIAlertAction(title: actionTitle, style: .default) { (alertAction) in
            if self.isAdvertising == true {
                self.appDelegate.mpcManager.advertiser.stopAdvertisingPeer()
            }
            else {
                self.appDelegate.mpcManager.advertiser.startAdvertisingPeer()
            }
            self.isAdvertising = !self.isAdvertising
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in
            
        }
        actionSheet.addAction(visibilityAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    

   
}//End of class
