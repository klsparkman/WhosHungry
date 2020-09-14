//
//  User.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 7/2/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import Foundation
import AuthenticationServices

struct User {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let inviteCode: String = ""
//    let gameID: String
    
    init(credentials: ASAuthorizationAppleIDCredential) {
        self.id = credentials.user
        self.firstName = credentials.fullName?.givenName ?? ""
        self.lastName = credentials.fullName?.familyName ?? ""
        self.email = credentials.email ?? ""
    }
}

extension User: CustomDebugStringConvertible {
    var debugDescription: String {
        return """
        ID: \(id)
        First Name: \(firstName)
        Last Name: \(lastName)
        Email: \(email)
        """
    }
}

extension User {
    init(inviteCode: [String : Any]) {
        self.init(inviteCode: inviteCode)
    }
}

//extension User {
//    init(dictionary: [String : Any]) {
////        guard (dictionary["inviteCode"] as? String) != nil else {return}
//        let inviteCode = dictionary["inviteCode"] as? String
//        self.init(inviteCode: inviteCode)
//
//    }
//}

//extension User {
//    init(firstName: String, lastName: String, ) {
//        
//    }
//}
