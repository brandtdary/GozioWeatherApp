//
//  ViewController.swift
//  WeatherApp
//
//  Created by Derrick Willer on 1/9/23.
//

import UIKit

class CurrentWeatherViewController: UIViewController {
    
    var location: Location?
    @IBOutlet weak var weatherImageView: UIImageView!
    // MARK: - View Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        location = Location(lat: "33.78591032377107", lon: "-84.40964058633683")

        updateWeather()
        
    }
    
    private func updateWeather() {
        guard let lat = location?.lat, let lon = location?.lon else { return }
        Services.shared.getWeather(lat: lat, lon: lon) { weather in
            print("City Name: \(weather?.name ?? "Unknonw Location")")
            print("H \(weather?.main?.tempMax)ºF L \(weather?.main?.tempMin)ºF")
            print("Current Temp: \(weather?.main?.temp)")
            print("Condition: \(weather?.weather?.first?.main)")
            
            print("Sunrise: \(weather?.sys?.sunrise)")
            
            print("Wind: \(weather?.wind?.speed) m/h")

            print("Humidity: \(weather?.main?.humidity)%")
            
            print("Icon: \(weather?.weather?.first?.icon)")
            
            if let icon = weather?.weather?.first?.icon {
                self.updateWeatherIcon(icon: icon)
            }
        }
    }

    private func updateWeatherIcon(icon: String) {
        ImageManager.shared.weatherIcon(for: icon) { image in
            self.weatherImageView.image = image
        }
    }
    
// MARK: - Setup view
    
   
    
// MARK: - Button Action
    
   
}
