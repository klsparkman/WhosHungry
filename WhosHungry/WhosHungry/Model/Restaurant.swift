//
//  Restaurant.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 4/15/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import Foundation

struct TopLevelObject: Codable {
    let restaurants: [RestaurantContainer]
}

struct RestaurantContainer: Codable {
    let restaurant: Restaurant
}

struct Restaurant: Codable {
    
    enum CodingKeys: String, CodingKey {
        case name, cuisines, location
        case image = "featured_image"
        //case rating = "user_rating"
    }
    
    let name: String?
    let cuisines: String?
    let image: String?
    let location: ResLocation?
//    let user_rating: UserRating?
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

