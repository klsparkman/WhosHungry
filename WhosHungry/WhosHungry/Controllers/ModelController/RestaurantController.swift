//
//  RestaurantController.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 4/15/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import UIKit
import CoreLocation

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
    let latKey = "lat"
    let lonKey = "lon"
    let radiusKey = "radius"
    let radiusVal = "\(32180)"
    
    // Mark: - Fetch Request
    func fetchRestaurants(location: CLLocation, completion: @escaping (Result<[Restaurant], RestaurantError>) -> Void) {
        guard let baseURL = baseURL else {return}
        let latitude = String(location.coordinate.latitude)
        let longitude = String(location.coordinate.longitude)
        let searchURL =  baseURL.appendingPathComponent(searchEndpoint)
        var urlComponents = URLComponents(url: searchURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [URLQueryItem(name: latKey, value: latitude), URLQueryItem(name: lonKey, value: longitude), URLQueryItem(name: radiusKey , value: radiusVal)]
        guard let finalURL = urlComponents?.url else {return completion(.failure(.invalidURL))}
        var request = URLRequest(url: finalURL)
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
                //                guard let restaurants = restaurants.randomElement() else {return}
                self.restaurants = restaurants
                // Now that I have restaurants, go get their images
                let group = DispatchGroup()
                
                var restaurantsWithImages: [Restaurant] = []
                
                for restaurant in restaurants {
                    group.enter()
                    var restaurantCopy = restaurant
                    print(restaurant.imageEndpoint)
                    self.fetchImage(for: restaurant) { result in
                        switch result {
                        case .success(let image):
                            restaurantCopy.image = image
                        case .failure(let error):
                            print("Couldn't get image for restaurant \(error)")
                        }
                        restaurantsWithImages.append(restaurantCopy)
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
//                    self.restaurants = restaurantsWithImages.sorted(by: <#T##(Restaurant, Restaurant) throws -> Bool#>)
                    completion(.success(restaurantsWithImages))
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
}
