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
        case cuisines = "categories"
        case imageEndpoint = "image_url"
        case reviewCount = "review_count"
        case restaurantYelpLink = "url"
    }
    let name: String?
    let imageEndpoint: String?
    let location: ResLocation?
    let rating: Double?
    let reviewCount: Int?
    var image: UIImage?
    let cuisines: [Category]
    var restaurantYelpLink: String
    var cuisineList: String {
        cuisines.compactMap { $0.title }.joined(separator: ", ")
    }
}

struct ResLocation: Codable {
    let address1: String?
    let city: String?
    let zipcode: String?
}

struct Category: Codable {
    let title: String?
}

extension Restaurant: Equatable {
    static func == (lhs: Restaurant, rhs: Restaurant) -> Bool {
        return lhs.name == rhs.name
    }
}

extension Restaurant: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
