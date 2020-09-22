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
    var userUID: String?
    var navigationController: UINavigationController?
    
    private override init() {
        super.init()
    }
    
    func didTapAppleButton(in viewController: UIViewController) {
        presentationVC = viewController
        let nonce = randomNonceString()
        currentNonce = nonce
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
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
            if let navigator = self.navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    func checkIfUserExists() -> Bool {
        guard let userUID = userUID else {return false}
        db.collection(Constants.userContainer).whereField(Constants.uid, isEqualTo: userUID).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                self.transitionToGameChoice()
            }
        }
        print("This user exists: \(userUID)")
        return true
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
                if let user = authDataResult?.user {
                    print("Nice! You're now signed in as \(user.uid)")
                    self.userUID = user.uid
                }
                
                switch authorization.credential {
                case let appleIDCredential as ASAuthorizationAppleIDCredential:
                    let user = User(credentials: appleIDCredential)
                    //Check to see if user exists in Firestore
                    if self.checkIfUserExists() == false {
                        //If not, createUser
                        self.db.collection(Constants.userContainer).addDocument(data: [Constants.uid : self.userUID!,
                                                                                       Constants.firstName : user.firstName,
                                                                                       Constants.lastName : user.lastName,
                                                                                       Constants.email : user.email])
                        self.transitionToGameChoice()
                    }
                    //Still set currentUser
                    self.currentUser = user
                    
                default:
                    break
                }
            }
        }
    }
}

func signIn(providerID: String, idTokenString: String, nonce: String, completion: @escaping (Result<AuthDataResult, UserError>) -> Void) {
    
    let credential = OAuthProvider.credential(withProviderID: providerID, idToken: idTokenString, rawNonce: nonce)
    Auth.auth().signIn(with: credential) { (authDataResult, error) in
        if let error = error {
            print(error.localizedDescription)
            completion(.failure(.noData))
            return
        }
        guard let authDataResult = authDataResult else {
            completion(.failure(.noData))
            return
        }
        completion(.success(authDataResult))
    }
}

func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    print("Right here.... Something went wrong", error)
}


extension UserController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        presentationVC!.view.window!
    }
}


