//
//  UserController.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 9/14/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import Foundation
import CryptoKit
import AuthenticationServices
import Firebase

class UserController: NSObject {
    
    // Mark: - Properties
    static var shared = UserController()
    var currentUser: User?
    fileprivate var currentNonce: String?
    fileprivate var presentationVC: UIViewController?
    let db = Firestore.firestore()
    //    var userUID: String?
    var navigationController: UINavigationController?
//    fileprivate var user: User?
    
    private override init() {
        super.init()
    }
    
    func didTapAppleButton(in viewController: UIViewController) {
        presentationVC = viewController
        let nonce = randomNonceString()
        currentNonce = nonce
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName]
        request.nonce = sha256(nonce)
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        return hashString
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    func transitionToGameChoice() {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "gameChoiceVC") as? GameChoiceViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
}

extension UserController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            Auth.auth().signIn(with: credential) { (authDataResult, error) in
                //handle error
                if let error = error {
                    print("Error signing in: \(error)")
                }
                if let authUser = authDataResult?.user {
                    print(authUser.uid)
                    print(authUser.displayName) 
                    // Fetch a user in Firebase using the authenticated uid
                    Firebase.shared.fetchUser(withID: authUser.uid) { (result) in
                        
                        switch result {
                        //First success is there was already a user in Firebase, and we are adding to currentUser
                        case .success(let user):
                            if let user = user {
                                self.currentUser = user
                                self.transitionToGameChoice()
                                print("We found a user in Firebase")
                            } else {
                                //If there wasn't, create a new user in Firestore
                                guard let name = authUser.displayName,
                                      let email = authUser.email else {return}
                                let uid = authUser.uid
                                Firebase.shared.createUser(with: name, email: email, uid: uid) { (result) in
                                    switch result {
                                    //We successfully created a user in Firebase
                                    case .success(let user):
                                        if let user = user {
                                            self.currentUser = user
                                            self.transitionToGameChoice()
                                        } else {
                                            print("Need to do something else here!!!")
                                        }
                                    //We did not successfully create a user
                                    //Need to give another option to the user to sign in?
                                    case .failure(let error):
                                        print("Error creating user: \(error)")
                                        SignInViewController.shared.loginFailureAlert()
                                    }
                                }
                                //                                }
                            }
                        case .failure(let error):
                            print("Error doing stuff: \(error)")
                            
                        }
                    }
                }
                self.transitionToGameChoice()
                
                switch authorization.credential {
                case let appleIDCredential as ASAuthorizationAppleIDCredential:
                    let user = User(credentials: appleIDCredential)
                    
                    //Still set currentUser
                    self.currentUser = user
                    
                default:
                    break
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Right here.... Something went wrong", error)
    }
    
    func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest()]
        
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
}

extension UserController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        presentationVC!.view.window!
    }
}
