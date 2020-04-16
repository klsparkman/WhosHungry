//
//  RestaurantController.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 4/15/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import Foundation

class RestaurantController {
    
    // Mark: - Properties
    static let shared = RestaurantController()
    var restaurants: [Restaurant] = []
    
    private init() {
    }
    
    // Zomato URL Constants
    let baseURL = URL(string: "https://developers.zomato.com/api/v2.1/")
    let searchEndpoint = "search"
    let headerKey = "user-key"
    let apiKey = "f9d11770a0a651c546720e10c914e7d6"
    
    // Mark: - Fetch Request
    func fetchRestaurants(completion: @escaping (Result<[Restaurant], RestaurantError>) -> Void) {
        guard let baseURL = baseURL else {return}
        let searchURL =  baseURL.appendingPathComponent(searchEndpoint)
        var request = URLRequest(url: searchURL)
        request.addValue(apiKey, forHTTPHeaderField: headerKey)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print(error, error.localizedDescription)
                return completion(.failure(.thrown(error)))
            }
            
            guard let data = data else {return completion(.failure(.noData))}
            
            do {
                let restaurantContainers = try JSONDecoder().decode(TopLevelObject.self, from: data).restaurants
                let restaurants = restaurantContainers.compactMap({$0.restaurant})
                self.restaurants = restaurants
                completion(.success(restaurants))
            } catch {
                print(error, error.localizedDescription)
                return completion(.failure(.thrown(error)))
            }
        }.resume()
    }
}
