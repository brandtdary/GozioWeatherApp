//
//  ViewController.swift
//  WeatherApp
//
//  Created by Derrick Willer on 1/9/23.
//

import UIKit

enum UnitOfMeasurement: String, CaseIterable {
    case imperial
    case standard
    case metric
}

class CurrentWeatherViewController: UIViewController {
    
    var location: Location?
    var locations = [Location]()
    var weather: WeatherResponse?
    var unitOfMeasurement: UnitOfMeasurement!
    var unit: UnitTemperature!

    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var highLowTempLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var temperatureUnitSymbolLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var sunriseTimeLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    
    // MARK: - View Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Dummy Data
        locations.append(Location(lat: "33.78591032377107", lon: "-84.40964058633683", name: "Fulton, GA"))
        locations.append(Location(lat: "33.812092", lon: "-117.918976", name: "Disneyland, CA"))
        locations.append(Location(lat: "47.606209", lon: "-122.332069", name: "Seattle, WA"))
        locations.append(Location(lat: "33.448376", lon: "-112.074036", name: "Phoenix, AZ"))
        locations.append(Location(lat: "38.907192", lon: "-77.036873", name: "Washington D.C."))
        // Location of Gozio HQ
        location = locations.first!
        
        setUnit(unit: .imperial)
        clearLabels()
        getWeather()
    }
    
    private func clearLabels() {
        temperatureUnitSymbolLabel.text = " "
        weatherImageView.image = nil
        locationNameLabel.text = unknownText
        highLowTempLabel.text = unknownText
        currentTempLabel.text = unknownText
        conditionLabel.text = unknownText
        sunriseTimeLabel.text = unknownText
        windSpeedLabel.text = unknownText
        humidityLabel.text = unknownText
    }
    
    private func setUnit(unit: UnitOfMeasurement) {
        self.unitOfMeasurement = unit
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
        locationNameLabel.isEnabled = false
        settingsButton.isEnabled = false
        Services.shared.getWeather(lat: lat, lon: lon, unit: unitOfMeasurement.rawValue) { weatherResponse in
            guard let weather = weatherResponse else { return } // TODO: Add error handling
            
            self.weather = weather
            self.updateView()
            self.locationNameLabel.isEnabled = true
            self.settingsButton.isEnabled = true
        }
    }
    
    private func updateView() {
        guard let currentWeather = weather else { return }
        locationNameLabel.text = currentWeather.name
        
        highLowTempLabel.text = currentWeather.formattedTemperature(unit: unit)
        currentTempLabel.text = currentWeather.formattedCurrentTemp()
        temperatureUnitSymbolLabel.text = temperatureUnitSymbol()
        conditionLabel.text = currentWeather.formattedCondition()
        sunriseTimeLabel.text = currentWeather.formattedSunriseTime()
        windSpeedLabel.text = currentWeather.formattedWindSpeed(unit: unitOfMeasurement)
        humidityLabel.text = currentWeather.formattedHumidity()
                    
        if let icon = currentWeather.weather?.first?.icon {
            updateWeatherIcon(icon: icon)
        }
        
        locationNameLabel.isEnabled = true
    }
    
    @IBAction func changeUnit(_ sender: Any) {
        let alertController = UIAlertController(title: "Currently Selected: \(self.unitOfMeasurement.rawValue.capitalized)", message: nil, preferredStyle: .actionSheet)
        for unit in UnitOfMeasurement.allCases {
            if unit.rawValue == self.unitOfMeasurement.rawValue { continue }
            alertController.addAction(UIAlertAction(title: unit.rawValue.capitalized, style: .default, handler: { action in
                DispatchQueue.main.async {
                    self.setUnit(unit: unit)
                    self.getWeather()
                }
            }))
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.popoverPresentationController?.sourceView = settingsButton
        
        present(alertController, animated: true)
    }
    
    
    @IBAction func changeLocation() {
        let alertController = UIAlertController(title: "Choose a different location:", message: nil, preferredStyle: .actionSheet)
        for location in locations {
            if location.name == self.location?.name {
                continue
            }
            alertController.addAction(UIAlertAction(title: location.name, style: .default, handler: { action in
                DispatchQueue.main.async {
                    self.location = location
                    self.getWeather()
                }
            }))
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alertController.popoverPresentationController?.sourceView = locationNameLabel
        
        present(alertController, animated: true)
    }
    
    private func temperatureUnitSymbol() -> String {
        switch self.unitOfMeasurement {
        case .imperial:
            return "F"
        case .standard:
            return "K"
        case .metric:
            return "C"
        case .none:
            return "?"
        }
    }

    private func updateWeatherIcon(icon: String) {
        ImageManager.shared.weatherIcon(for: icon) { image in
            self.weatherImageView.image = image
        }
    }
}
