//
//  RestaurantController.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 4/15/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation

class RestaurantController {
    
    // Mark: - Properties
    static let shared = RestaurantController()
    var restaurants: [Restaurant] = []
    var restaurantsWithImages: [Restaurant] = []
    var users: [User] = []
    var yelpAPIKey: String?
    
    // Mark: - Yelp URL Constants
    let baseURL = URL(string: "https://api.yelp.com/v3/businesses")
    let searchEndpoint = "search"
    let authType = "Bearer Token"
    let searchKey = "location"
    let radiusKey = "radius"
    let categoryTerm = "term"
    
    private init() {
    }
    
    // Mark: - Fetch Request
    func fetchRestaurants(searchTerm: String, radius: Int, category: String, completion: @escaping (Result<Void, RestaurantError>) -> Void) {
        guard let baseURL = baseURL else {return completion(.failure(.noData))}
        let searchURL = baseURL.appendingPathComponent(searchEndpoint)
        var urlComponents = URLComponents(url: searchURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [URLQueryItem(name: searchKey, value: searchTerm), URLQueryItem(name: radiusKey, value: "\(Int(radius))"), URLQueryItem(name: categoryTerm, value: category)]
        let finalURL = urlComponents?.url
        var request = URLRequest(url: finalURL!)
        guard let yelpAPIKey = GameController.shared.yelpAPIKey else {return}
        let apiKey = yelpAPIKey.replacingOccurrences(of: "\"", with: "")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error, error.localizedDescription)
                return completion(.failure(.thrown(error)))
            }
            guard let data = data else {return completion(.failure(.noData))}
            do {
                let restaurantContainers = try JSONDecoder().decode(TopLevelObject.self, from: data).businesses
                let restaurants = restaurantContainers.compactMap({$0})
                guard !restaurants.isEmpty else {return completion(.failure(.noData))}
                let uniqueRestaurants = restaurants.unique(by: { $0.name })
                let group = DispatchGroup()
                for restaurant in uniqueRestaurants {
                    group.enter()
                    var restaurantCopy = restaurant
                    self.fetchImage(for: restaurant) { result in
                        switch result {
                        case .success(let image):
                            restaurantCopy.image = image
                        case .failure(let error):
                            print("Couldn't get image for restaurant \(error)")
                        }
                        self.restaurants.append(restaurantCopy)
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                    completion(.success(()))
                }
            } catch {
                print(error, error.localizedDescription)
                return completion(.failure(.thrown(error)))
            }
        }.resume()
    }
    
    func fetchImage(for restaurant: Restaurant, completion: @escaping (Result<UIImage, RestaurantError>) -> Void) {
        guard let imageEndpoint = restaurant.imageEndpoint,
              let restaurantImage = URL(string: imageEndpoint)
        else {
            return completion(.failure(.noData)) }
        URLSession.shared.dataTask(with: restaurantImage) { (data, response, error) in
            if let error = error {
                return completion(.failure(.thrown(error)))
            }
            guard let data = data else {
                return completion(.failure(.noData))
            }
            guard let image = UIImage(data: data) else {
                return completion(.failure(.noData))
            }
            completion(.success(image))
        }.resume()
    }
    
    func setStarRating(rating: Double) -> String {
        switch rating {
        case 5.0:
            return "regular_5"
        case 4.5:
            return "regular_4_half"
        case 4.0:
            return "regular_4"
        case 3.5:
            return "regular_3_half"
        case 3.0:
            return "regular_3"
        case 2.5:
            return "regular_2_half"
        case 2.0:
            return "regular_2"
        case 1.5:
            return "regular_1_half"
        case 1.0:
            return "regular_1"
        case 0:
            return "regular_0"
        default:
            return ""
        }
    }
    
    func restaurant(withName name: String) -> Restaurant? {
        restaurants.first(where: {$0.name == name})
    }
}

public extension Sequence {
    /// Returns the array of elements for which condition(element) is unique
    func unique<T: Hashable>(by condition: (Iterator.Element) throws -> T) rethrows -> [Iterator.Element] {
        var results: [Iterator.Element] = []
        var tempSet = Set<T>()
        for element in self {
            let value: T = try condition(element)
            if !tempSet.contains(value) {
                tempSet.insert(value)
                results.append(element)
            }
        }
        return results
    }
}
