//
//  MPCManager.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 4/17/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

//import UIKit
//import MultipeerConnectivity
//
//protocol MPCManagerDelegate {
//
//    func foundPeer()
//    func lostPeer()
//    func invitationWasReceived(fromPeer: String)
//    func connectedWithPeer(peerID: MCPeerID)
//}
//
//class MPCManager: NSObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate {
//    var session: MCSession!
//    var peer: MCPeerID!
//    var browser: MCNearbyServiceBrowser!
//    var advertiser: MCNearbyServiceAdvertiser!
//    var foundPeers = [MCPeerID]()
//    var invitationHandler: ((Bool, MCSession?) -> Void)!
//    var delegate: MPCManagerDelegate?
//
//    override init() {
//        super.init()
//
//        peer = MCPeerID(displayName: UIDevice.current.name)
//        session = MCSession(peer: peer)
//        session.delegate = self
//
//        browser = MCNearbyServiceBrowser(peer: peer, serviceType: "kls-whoshungry")
//        browser.delegate = self
//
//        advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: nil, serviceType: "kls-whoshungry")
//        advertiser.delegate = self
//    }
//
//    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
//
//    }
//
//    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
//
//    }
//
//    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
//
//    }
//
//    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
//
//    }
//
//    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
//
//    }
//
//    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
//        switch state {
//        case MCSessionState.connected:
//            print("Connected to session: \(session)")
//            delegate?.connectedWithPeer(peerID: peerID)
//        case MCSessionState.connecting:
//            print("Connecting to session: \(session)")
//        default:
//            print("Did not connect to session: \(session)")
//        }
//    }
//
//    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
//        foundPeers.append(peerID)
//        delegate?.foundPeer()
//    }
//
//    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
//        guard let index = foundPeers.firstIndex(of: peerID) else {return}
//        for aPeer in foundPeers {
//            if aPeer == peerID {
//                foundPeers.remove(at: index)
//                break
//            }
//        }
//        delegate?.lostPeer()
//    }
//
//    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
//        print(error, error.localizedDescription)
//    }
//
//    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
//        self.invitationHandler = invitationHandler
//        delegate?.invitationWasReceived(fromPeer: peerID.displayName)
//    }
//
//    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
//        print(error, error.localizedDescription)
//    }
//
////    func sendData(dictionaryWithData dictionary: Dictionary<String, String>, toPeer targetPeer: MCPeerID) -> Bool {
////        var error: NSError?
////        let dataToSend = NSKeyedArchiver.archivedData(withRootObject: dictionary, requiringSecureCoding: false)
////        let peersArray = NSArray(object: targetPeer)
////        if !session.sendData(dataToSend, toPeers: peersArray, withMode: MCSessionSendDataMode.reliable, error: &error) {
////            return false
////        }
////        return true
////    }
//}


