//
//  User.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 7/2/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import Foundation
import AuthenticationServices

struct User: Decodable {
    let firstName: String
    let lastName: String
    let email: String
    let uid: String
    var isGameCreator: Bool = false
    
    init(firstName: String, lastName: String, email: String, uid: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.uid = uid
    }
    
    init(credentials: ASAuthorizationAppleIDCredential) {
        self.uid = credentials.user
        self.firstName = credentials.fullName?.givenName ?? ""
        self.lastName = credentials.fullName?.familyName ?? ""
        self.email = credentials.email ?? ""
    }
}

extension User: CustomDebugStringConvertible {
    var debugDescription: String {
        return """
        ID: \(uid)
        First Name: \(firstName)
        Last Name: \(lastName)
        Email: \(email)
        """
    }
}

extension User {
    init?(dictionary: [String : Any]) {
        guard let firstName = dictionary[Constants.firstName] as? String,
        let lastName = dictionary[Constants.lastName] as? String,
        let email = dictionary[Constants.email] as? String,
        let uid = dictionary[Constants.uid] as? String
        else {return nil}
        self.init(firstName: firstName, lastName: lastName, email: email, uid: uid)
    }
}
