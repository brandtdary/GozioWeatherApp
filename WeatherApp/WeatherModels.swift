//
//  WeatherModels.swift
//  WeatherApp
//
//  Created by Brandt Dary on 1/30/23.
//

import Foundation

// MARK: - WeatherResponse
struct WeatherResponse: Codable {
    let coord: Coord?
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let rain: Rain?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone, id: Int?
    let name: String?
    let cod: Int?
    
    // MARK: - Clouds
    struct Clouds: Codable {
        let all: Int?
    }

    // MARK: - Coord
    struct Coord: Codable {
        let lon: Double
        let lat: Double
    }

    // MARK: - Main
    struct Main: Codable {
        let temp: Double?
        let feelsLike: Double?
        let tempMin: Double?
        let tempMax: Double?
        let pressure: Int?
        let humidity: Int?
        let seaLevel: Int?
        let grndLevel: Int?

        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure
            case humidity
            case seaLevel = "sea_level"
            case grndLevel = "grnd_level"
        }
    }

    // MARK: - Rain
    struct Rain: Codable {
        let the1H: Double?

        enum CodingKeys: String, CodingKey {
            case the1H = "1h"
        }
    }

    // MARK: - Sys
    struct Sys: Codable {
        let type: Int?
        let id: Int?
        let country: String?
        let sunrise: Int?
        let sunset: Int?
    }

    // MARK: - Weather
    struct Weather: Codable {
        let id: Int?
        let main, description, icon: String?
    }

    // MARK: - Wind
    struct Wind: Codable {
        let speed: Double?
        let deg: Int?
        let gust: Double?
    }
}

let unknownText = "--"

extension WeatherResponse {
    
    func formattedTemperature(unit: UnitTemperature) -> String {
        guard let max = self.main?.tempMax, let min = self.main?.tempMin else {
            return "Temperature Unavailable"
        }

        let unitSymbol = unit.symbol
        
        // TODO: Consider rounding the temperature, instead of forcing in to an Int.
        return "H \(Int(max))\(unitSymbol) / L \(Int(min))\(unitSymbol)"
    }
    
    func formattedCurrentTemp() -> String {
        guard let temp = self.main?.temp else {
            return unknownText
        }
        return "\(Int(temp))"
    }
    
    func formattedCondition() -> String {
        guard let condition = self.weather?.first?.main else {
            return unknownText
        }
        return condition
    }
    
    func formattedSunriseTime() -> String {
        guard let time = self.sys?.sunrise else {
            return unknownText
        }
        
        let date = NSDate(timeIntervalSince1970: TimeInterval(time))
        let utcDateFormatter = DateFormatter()
        utcDateFormatter.dateStyle = .none
        utcDateFormatter.timeStyle = .short
        
        return utcDateFormatter.string(from: date as Date).lowercased().replacingOccurrences(of: " am", with: "").replacingOccurrences(of: " pm", with: "")
    }
    
    func formattedWindSpeed(unit: UnitOfMeasurement) -> String {
        guard let wind = self.wind?.speed else {
            return unknownText
        }
        
        // Metric & Standard are Meters per second, Imperial is Miles per Hour
        let description = unit == .imperial ? "m/h" : "m/s"
        return "\(Int(wind)) m/s"
    }
    
    func formattedHumidity() -> String {
        guard let humidity = self.main?.humidity else {
            return unknownText
        }
        return "\(humidity)%"
    }
}
