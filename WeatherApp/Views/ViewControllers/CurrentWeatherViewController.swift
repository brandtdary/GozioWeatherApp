//
//  ViewController.swift
//  WeatherApp
//
//  Created by Derrick Willer on 1/9/23.
//

import UIKit

enum UnitOfMeasurement: String {
    case imperial
    case standard
    case metric
}

class CurrentWeatherViewController: UIViewController {
    
    var location: Location?
    var weather: WeatherResponse?
    var unitOfMeasurement: UnitOfMeasurement!
    var unit: UnitTemperature!

    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var highLowTempLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var sunriseTimeLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    // MARK: - View Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Location of Gozio HQ
        location = Location(lat: "33.78591032377107", lon: "-84.40964058633683")
        
        unitOfMeasurement = .imperial
        setUnit(unit: unitOfMeasurement)
        clearLabels()
        getWeather()
    }
    
    private func clearLabels() {
        locationNameLabel.text = unknownText
        highLowTempLabel.text = unknownText
        currentTempLabel.text = unknownText
        conditionLabel.text = unknownText
        sunriseTimeLabel.text = unknownText
        windSpeedLabel.text = unknownText
        humidityLabel.text = unknownText
    }
    
    private func setUnit(unit: UnitOfMeasurement) {
        switch unit {
        case .imperial:
            self.unit = .fahrenheit
        case .standard:
            self.unit = .kelvin
        case .metric:
            self.unit = .celsius
        }
    }
    
    private func getWeather() {
        guard let lat = location?.lat, let lon = location?.lon else { return }
        if unit == nil {
            unit = .fahrenheit
        }
        Services.shared.getWeather(lat: lat, lon: lon, unit: unitOfMeasurement.rawValue) { weatherResponse in
            guard let weather = weatherResponse else { return }
            
            self.weather = weather
            self.updateView()
        }
    }
    
    private func updateView() {
        guard let currentWeather = weather else { return }
        locationNameLabel.text = currentWeather.name
        
        highLowTempLabel.text = currentWeather.formattedTemperature(unit: unit)
        currentTempLabel.text = currentWeather.formattedCurrentTemp()
        conditionLabel.text = currentWeather.formattedCondition()
        sunriseTimeLabel.text = currentWeather.formattedSunriseTime()
        windSpeedLabel.text = currentWeather.formattedWindSpeed(unit: unitOfMeasurement)
        humidityLabel.text = currentWeather.formattedHumidity()
                    
        if let icon = currentWeather.weather?.first?.icon {
            updateWeatherIcon(icon: icon)
        }
    }

    private func updateWeatherIcon(icon: String) {
        ImageManager.shared.weatherIcon(for: icon) { image in
            self.weatherImageView.image = image
        }
    }
}
