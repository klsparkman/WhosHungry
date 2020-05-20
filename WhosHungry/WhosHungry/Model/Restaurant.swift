//
//  Restaurant.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 4/15/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import UIKit

struct TopLevelObject: Codable {
    let restaurants: [RestaurantContainer]
}

struct RestaurantContainer: Codable {
    let restaurant: Restaurant
}

struct Restaurant: Codable {
    enum CodingKeys: String, CodingKey {
        case name, cuisines, location
        case imageEndpoint = "featured_image"
        //case rating = "user_rating"
    }
    
    let name: String?
    let cuisines: String?
    let imageEndpoint: String?
    let location: ResLocation?
//    let user_rating: UserRating?
    var image: UIImage?
    var liked: Bool?
}

struct ResLocation: Codable {
    let address: String?
    let city: String?
    let zipcode: String?
}

//struct UserRating: Codable {
//
//    enum CodingKeys: String, CodingKey {
//        case rating = "aggregate_rating"
//    }
//
//    let rating: String?
//}

