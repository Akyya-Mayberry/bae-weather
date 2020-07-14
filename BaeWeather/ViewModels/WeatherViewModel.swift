//
//  Weather.swift
//  OnrampProject
//
//  Created by Chris Hurley on 2/29/20.
//

import Foundation
import CoreLocation

protocol WeatherViewModelDelegate {
    func didUpdateWeather(_ weatherViewModel: WeatherViewModel)
    func didFailWithError(_ weatherViewModel: WeatherViewModel, _ error: Error)
    func didUpdateModelImageDetails(_ weatherViewModel: WeatherViewModel, modelImageViewModel: ModelImageViewModel)
}

/**
 Manages a current weather object
 */
class WeatherViewModel {
    
    // MARK: - Properties
    
    private let weatherNetworkService = WeatherNetworkService.sharedInstance
    private let locationService = LocationService.sharedInstance
    fileprivate let userDefaultsService = UserDefaultsService.sharedInstance
    private var modelImageViewModel = ModelImageViewModel()
    var delegate: WeatherViewModelDelegate?
    
    private(set) var weather: Weather? {
        didSet {
            guard weather != nil else {
                return
            }
            userDefaultsService.lastKnownWeather = weather
            delegate?.didUpdateWeather(self)
        }
    }
    
    var weatherCity: String? {
        return weather?.city
    }
    
    var location: String? {
        guard weather != nil else {
            return nil
        }
        
        return "\(weather!.city.capitalized), \(weather!.country.uppercased())"
    }
    
    var weatherState: String? {
        return weather?.state
    }
    
    var lastUpdateTime: String? {
        return weather?.date.getTimeAsString()
    }
    
    var currentTemp: Int? {
        guard weather != nil else {
            return nil
        }
        
        return weather?.temperature
    }
    
    var getCurrentDate: String {
        return currentDateAsString
    }
    
    var currentDateAsString: String {
        return (weather?.date.getDateAsString())!
    }
    
    var currentTimeAsString: String {
        return (weather?.date.getTimeAsString())!
    }
    
    var lowTempString: String {
        guard weather != nil else {
            return "--"
        }
        return String(describing: weather!.low)
    }
    
    var highTempString: String {
        guard weather != nil else {
            return "--"
        }
        return String(describing: weather!.high)
    }
    
    var lowHighTempString: String {
        return "L\(lowTempString)°/H\(highTempString)°"
    }
    
    var tempsString: String {
        guard weather != nil else {
            return "--°"
        }
        return "\(currentTemp!)°\(lowHighTempString)"
    }
    
    // MARK: - Methods
    
    init(weather: Weather?) {
        modelImageViewModel.delegate = self
        
        if let weather = weather {
            self.weather = weather
        }
        
    }
    
    private func getCurrentLocation() -> (lat: Double, long: Double)? {
        locationService.startUpdatingLocation()
        
        if let currentLocation = locationService.currentLocation {
            locationService.stopUpdatingLocation()
            return currentLocation
        }
        
        locationService.stopUpdatingLocation()
        return nil
    }
    
    func getLocationAuthorizationStatus() -> LocationStatusUpdate {
        switch locationService.requestStatus {
        case .authorized:
            return .authorized
        case .denied:
            return .denied
        default:
            locationService.requestLocation()
            return .notDetermined
        }
    }
    
    func updateCurrentWeather(city: String, state: String) {
        weatherNetworkService.getCurrentWeather(city: city, state: state) { (data, error) in
            
            guard error == nil else {
                self.delegate?.didFailWithError(self, error!)
                return
            }
            
            if let data = data {
                let date = Date()
                let currentHourBlock = HourlyWeatherViewModel.getCurrentWeatherBlockUsing(date: date)
                
                self.weather = Weather(date: date, temperature: Int(data.main.temp), low: Int(data.main.temp_min), high: Int(data.main.temp_max), hourlyTemps: [:], city: city, state: state, country: data.sys.country, currentHourBlock: currentHourBlock)
            }
        }
    }
    
    func getCurrentWeather() {
        guard let currentLocation = getCurrentLocation() else {
            return
        }
        
        weatherNetworkService.getCurrentWeather(lat: currentLocation.lat, long: currentLocation.long) { (data, error) in
            guard error == nil else {
                self.delegate?.didFailWithError(self, error!)
                return
            }
            
            if let data = data {
                //                let date = Date()
                //                let currentHourBlock = HourlyWeatherViewModel.getCurrentWeatherBlockUsing(date: date)
                
                self.weather = WeatherViewModel.makeWeather(from: data)
            }
        }
    }
    
    func getWeatherCategory() -> WeatherCategory? {
        guard weather != nil else {
            return nil
        }
        
        let typeOfWeather = TypeOfWeather(for: weather!.temperature)
        return typeOfWeather.category
    }
    
    func getFormattedDate(_ date: Date) -> String {
        return date.getDateAsString()
    }
    
    func getHourlyTemps() -> [Int: Int] {
        return weather?.hourlyTemps ?? [:]
    }
    
    func getCurrentWeatherBlock() -> WeatherBlockTime {
        return weather!.currentHourBlock
    }
    
    func modelImageDetails(for typeOfWeather: WeatherCategory, completion: (WeatherModelImage?) -> Void) {
        if weather == nil {
            completion(nil)
        }
        
        let typeOfWeather = TypeOfWeather(for: weather!.temperature).category
        
        modelImageViewModel.getImage(for: typeOfWeather, asDefault: false) { (weatherModelImage) in
            completion(weatherModelImage)
        }
    }
    
}

// MARK: - Extensions

extension WeatherViewModel {
    static func makeWeather(from weatherData: WeatherData) -> Weather {
        let currentHourBlock = HourlyWeatherViewModel.getCurrentWeatherBlockUsing(date: Date())
        
        let weather = Weather(date: Date(), temperature: Int(weatherData.main.temp), low: Int(weatherData.main.temp_min), high: Int(weatherData.main.temp_max), hourlyTemps: [:], city: weatherData.name, state: "", country: weatherData.sys.country, currentHourBlock: currentHourBlock)
        
        return weather
    }
}

extension Date {
    func getDateAsString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short // or setLocalizeDateFromTemplate("")
        
        let dateAsString = formatter.string(from: self)
        
        return dateAsString
    }
    
    func getTimeAsString() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        let dateAsString = formatter.string(from: self)
        
        return dateAsString
    }
    
    func getHour() -> Int {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateFormat = "HH"
        
        let hour = formatter.string(from: self)
        
        return Int(hour)!
    }
}

extension WeatherViewModel: ModelImageViewModelDelegate {
    func modelName(_ modelImageViewModel: ModelImageViewModel, willChange: Bool, name: String) {
        delegate?.didUpdateModelImageDetails(self, modelImageViewModel: modelImageViewModel)
    }
}
