//
//  Services.swift
//  WeatherApp
//
//  Created by Brandt Dary on 1/30/23.
//

import UIKit

class Services {
    
    static let shared = Services()
    
    let baseURL = "https://api.openweathermap.org"
    let basePath = "/data/2.5/weather"
    
    // TODO: Use Result Type
    func getWeather(lat: String, lon: String, unit: String?, completionHandler: @escaping (WeatherResponse?) -> ()) {
        
        var queryItems = [URLQueryItem]()
        let lat = URLQueryItem(name: "lat", value: lat)
        queryItems.append(lat)
        let lon = URLQueryItem(name: "lon", value: lon)
        queryItems.append(lon)
        
        if unit != nil {
            let units = URLQueryItem(name: "units", value: unit)
            queryItems.append(units)
        }
        let components = self.urlComponent(url: baseURL, path: basePath, queryItems: queryItems)
        
        // TODO: Refactor this to not force unrwap optional
        let request = URLRequest(url: components.url!)

        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let responseData = data else {
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
                return
            }
            
            do {
                let weather = try JSONDecoder().decode(WeatherResponse.self, from: responseData)
                DispatchQueue.main.async {
                    completionHandler(weather)
                }
            } catch {
                print("error trying to convert data to JSON")
                print(error)
                completionHandler(nil)
            }
        }.resume()

        
    }
        
    private let openWeatherMapAPIKey = "3aa158b2f14a9f493a8c725f8133d704"
    private func urlComponent(url: String, path: String, queryItems: [URLQueryItem]? = nil) -> URLComponents {
        var components = URLComponents(string: url)!
        components.path = path
        
        if queryItems != nil {
            var items = queryItems!
            let appidQueryItem = URLQueryItem(name: "appid", value: openWeatherMapAPIKey)
            items.append(appidQueryItem)
            components.queryItems = items
        }
        return components
    }
    
    
    
}
