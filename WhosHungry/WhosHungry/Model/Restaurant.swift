//
//  Restaurant.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 4/15/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import UIKit

struct TopLevelObject: Codable {
    let businesses: [Restaurant]
}

struct Restaurant: Codable {
    enum CodingKeys: String, CodingKey {
        case name, location, rating
        case imageEndpoint = "image_url"
        case reviewCount = "review_count"
    }
    
    let name: String?
    let imageEndpoint: String?
    let location: ResLocation?
    let rating: Double?
    let reviewCount: Int?
    var image: UIImage?
    var isLiked: Bool?
//    let category: Category?
}

struct ResLocation: Codable {
    let address1: String?
    let city: String?
    let zipcode: String?
}

//struct Category: Codable {
//    let title: String?
//}
