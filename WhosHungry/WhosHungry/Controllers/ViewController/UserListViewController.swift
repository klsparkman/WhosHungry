//
//  UserListViewController.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 4/17/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class UserListViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    var peerID: MCPeerID?
    var session: MCSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        peerID = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer: peerID!, securityIdentity: nil, encryptionPreference: .none)
        session!.delegate = self
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected to \(peerID.displayName)")
        case .connecting:
            print("Connecting: \(peerID.displayName)")
        case .notConnected:
            print("Not Connected: \(peerID.displayName)")
        default:
            print("")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func hostButtonTapped(_ sender: Any) {
        hostSession()
    }
    
    @IBAction func joinButtonTapped(_ sender: Any) {
        joinSession()
    }
    
    func hostSession() {
        let advertiser = MCAdvertiserAssistant(serviceType: "mg-testing", discoveryInfo: nil, session: session!)
        advertiser.start()
    }
    
    func joinSession() {
        let browser = MCBrowserViewController(serviceType: "mg-testing", session: session!)
        browser.delegate = self
        self.present(browser, animated: true, completion: nil)
    }
    
}//End of class
