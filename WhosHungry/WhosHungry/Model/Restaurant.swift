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
}

struct ResLocation: Codable {
    let address1: String?
    let city: String?
    let zipcode: String?
}

//struct TopLevelObject: Codable {
//    let restaurants: [RestaurantContainer]
//}

//struct RestaurantContainer: Codable {
//    let restaurant: Restaurant
//}

//struct Restaurant: Codable {
//    enum CodingKeys: String, CodingKey {
//        case name, cuisines, location, rating
//        case imageEndpoint = "featured_image"
//    }
//
//    let name: String?
//    let cuisines: String?
//    let imageEndpoint: String?
//    let location: ResLocation?
//    let rating: UserRating?
//    var image: UIImage?
//    var isLiked: Bool?
//}
//struct UserRating: Codable {
//    enum CodingKeys: String, CodingKey {
//        case rating = "aggregate_rating"
//    }
//
//    let rating: String?
//}

//extension Restaurant: Equatable {
//    static func == (lhs: Restaurant, rhs: Restaurant) -> Bool {
//        return lhs == rhs
//    }
//}
