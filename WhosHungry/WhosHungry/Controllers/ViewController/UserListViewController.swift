
//
//  UserListViewController.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 4/17/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import CoreLocation

class UserListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MPCManagerDelegate, CLLocationManagerDelegate {

    // Mark: - Outlets
    @IBOutlet weak var peersTableView: UITableView!

    // Mark: - Properties
    static let shared = UserListViewController()
    let restaurantService = RestaurantService()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var isAdvertising: Bool!
    var locManager = CLLocationManager()
    var currentLocation: CLLocation?

    // Mark: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        peersTableView.delegate = self
        peersTableView.dataSource = self
        appDelegate.mpcManager.delegate = self
        appDelegate.mpcManager.browser.startBrowsingForPeers()
        appDelegate.mpcManager.advertiser.startAdvertisingPeer()
        isAdvertising = true
        locManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyBest
            locManager.startUpdatingLocation()
            currentLocation = locManager.location
//            guard let currentLocation = locManager.location else {return}
//            print(currentLocation.coordinate.latitude)
//            print(currentLocation.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopup()
        }
    }
    
    func showLocationDisabledPopup() {
        let alertController = UIAlertController(title: "Background location access disabled.", message: "In order to pull restaurants in your area, we need your location.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open settings", style: .default) { (action) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        self.present(alertController, animated: true, completion: nil)
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPeer = appDelegate.mpcManager.foundPeers[indexPath.row] as MCPeerID
        appDelegate.mpcManager.browser.invitePeer(selectedPeer, to: appDelegate.mpcManager.session, withContext: nil, timeout: 20)
    }

    func foundPeer() {
        peersTableView.reloadData()
    }

    func lostPeer() {
        peersTableView.reloadData()
    }

    func invitationWasReceived(fromPeer: String) {
        let alert = UIAlertController(title: "", message: "\(fromPeer) wants to have dinner with you.", preferredStyle: .alert)
        let acceptAction = UIAlertAction(title: "Accept", style: .default) { (alertAction) in
            self.appDelegate.mpcManager.invitationHandler(true, self.appDelegate.mpcManager.session)
        }
        let declineAction = UIAlertAction(title: "Decline", style: .cancel) { (alertAction) in
            self.appDelegate.mpcManager.invitationHandler(false, nil)
        }
        alert.addAction(acceptAction)
        alert.addAction(declineAction)

        self.present(alert, animated: true, completion: nil)
    }

    func connectedWithPeer(peerID: MCPeerID) {
        self.performSegue(withIdentifier: "idSegueSwipe", sender: self)
    }

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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "toSwipeVC" {
            guard let destinationVC = segue.destination as? SwipeScreenViewController else {return}
            destinationVC.location = currentLocation
        }
    }


}//End of class
