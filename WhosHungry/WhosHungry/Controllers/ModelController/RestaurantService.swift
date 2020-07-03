//
//  RestaurantService.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 5/18/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

//import Foundation
//import MultipeerConnectivity
//
//class RestaurantService: NSObject {
//    // Mark: - Properties
//    private let RestaurantServiceType = "ex-restaurant"
//    static let myPeerId = MCPeerID(displayName: UIDevice.current.name)
//    private let serviceAdvertiser: MCNearbyServiceAdvertiser
//    private let serviceBrowser: MCNearbyServiceBrowser
//    var players: [Int] = []
////    let playerCount: Int
//    
//    var delegate: RestaurantServiceDelegate?
//    
//    lazy var session: MCSession = {
//        let session = MCSession(peer: RestaurantService.myPeerId, securityIdentity: nil, encryptionPreference: .none)
//        session.delegate = self
//        return session
//        //.required for encryptionPreference
//    }()
//    
//    override init() {
//        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: RestaurantService.myPeerId, discoveryInfo: nil, serviceType: RestaurantServiceType)
//        self.serviceBrowser = MCNearbyServiceBrowser(peer: RestaurantService.myPeerId, serviceType: RestaurantServiceType)
//        
//        super.init()
//        
//        self.serviceAdvertiser.delegate = self
//        self.serviceAdvertiser.startAdvertisingPeer()
//        
//        self.serviceBrowser.delegate = self
//        self.serviceBrowser.startBrowsingForPeers()
//    }
//    
//    deinit {
//        self.serviceAdvertiser.stopAdvertisingPeer()
//        self.serviceBrowser.stopBrowsingForPeers()
//    }
//    
//    
//    func send(restaurantName: String) {
//        NSLog("%@", "sendRestaurant: \(restaurantName) to \(session.connectedPeers.count) peers")
//        if session.connectedPeers.count > 0 {
//            do {
//                try self.session.send(restaurantName.data(using: .utf8)!, toPeers: session.connectedPeers, with: .reliable)
//            } catch let error {
//                NSLog("%@", "Error for sending: \(error)")
//            }
//        }
//    }
//}//End of class
//
//// Mark: - Advertiser Extension
//extension RestaurantService: MCNearbyServiceAdvertiserDelegate {
//    
//    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
//        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
//    }
//    
//    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
//        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
//        invitationHandler(true, self.session)
//    }
//}
//// Mark: - Session Extension
//extension RestaurantService: MCSessionDelegate {
//    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
//        NSLog("%@", "peer \(peerID) didChangeState: \(state.rawValue)")
//        self.delegate?.connectedDevices(manager: self, connectedDevices:
//            session.connectedPeers.map{$0.displayName})
//        let playerCount = session.connectedPeers.count + 1
//        players.append(playerCount)
//        print("playerCount: \(playerCount)")
//    }
//    
//    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
//        NSLog("%@", "didReceiveData: \(data.count) bytes")
//        let str = String(data: data, encoding: .utf8)!
//        self.delegate?.restaurantPicked(manager: self, restaurantString: str)
//    }
//    
//    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
//        NSLog("%@", "didReceiveStream")
//    }
//    
//    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
//        NSLog("%@", "didStartReceivingResourceWithName")
//    }
//    
//    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
//        NSLog("%@", "didFinishReceivingResourceWithName")
//    }
//}
//// Mark: - Browser Extension
//extension RestaurantService: MCNearbyServiceBrowserDelegate {
//    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
//        NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
//    }
//    
//    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
//        NSLog("%@", "foundPeer: \(peerID)")
//        NSLog("%@", "invitePeer: \(peerID)")
//        browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
//    }
//    
//    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
//        NSLog("%@", "lostPeer: \(peerID)")
//    }
//}
//// Mark: - Protocol
//protocol RestaurantServiceDelegate {
//    func connectedDevices(manager: RestaurantService, connectedDevices: [String])
//    func restaurantPicked(manager: RestaurantService, restaurantString: String)
//}
