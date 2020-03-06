//
//  Weather.swift
//  OnrampProject
//
//  Created by Chris Hurley on 2/29/20.
//

import Foundation

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
    
    private let weatherNetworkService = WeatherNetworkService()
    fileprivate let userDefaults = UserDefaults.standard
    private(set) var weatherCity: String
    private(set) var weatherState: String
    private(set) var lastUpdateTime: String?
    private var modelImageViewModel = ModelImageViewModel()
    var delegate: WeatherViewModelDelegate?
    
    private(set) var weather: Weather? {
        didSet {
            guard weather != nil else {
                return
            }
            
            lastUpdateTime = currentTimeAsString
            
            WeatherViewModel.storeInUserDefaults(item: weather)
            delegate?.didUpdateWeather(self)
        }
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
    
    var modelImageDetails: BaeImage? {
        
        guard weather != nil else {
            return nil
        }
        
        let typeOfWeather = TypeOfWeather(for: weather!.temperature).category
        
        return modelImageViewModel.getImagefor(typeOfWeather: typeOfWeather)
    }
    
    var currentDateAsString: String {
        return (weather?.date.getDateAsString())!
    }
    
    var currentTimeAsString: String {
        return (weather?.date.getTimeAsString())!
    }
    
    // MARK: - Methods
    
    init(city: String, state: String) {
        self.weatherCity = city
        self.weatherState = state
        modelImageViewModel.delegate = self
        
        if let lastKnownWeather = WeatherViewModel.getFromUserDefaults(item: Constants.userDefaultKeys.lastKnownWeather) as? Weather {
            self.weather = lastKnownWeather
            lastUpdateTime = self.weather?.date.getTimeAsString()
            delegate?.didUpdateWeather(self)
        }
        
//        updateCurrentWeather(city: city, state: state)
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
                
                self.weather = Weather(date: date, temperature: Int(data.main.temp), hourlyTemps: [:], city: city, state: state, currentHourBlock: currentHourBlock)
                
                WeatherViewModel.storeInUserDefaults(item: self.weather)
            }
        }
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
    
}

// MARK: - Extensions

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
    func modelName(_ modelImageViewModel: ModelImageViewModel, didChange: Bool) {
        delegate?.didUpdateModelImageDetails(self, modelImageViewModel: modelImageViewModel)
    }
}

// TODO: Move to userdefault service or shared instance
extension WeatherViewModel {
    
    static func storeInUserDefaults(item: Any?) {
        let userDefaults = UserDefaults.standard
        
        if let item = item as? Weather {
            let encoder = JSONEncoder()
            
            do {
                let data = try encoder.encode(item)
                userDefaults.set(data, forKey: Constants.userDefaultKeys.lastKnownWeather)
            } catch {
                print("error storing data in user defaults: \(error)")
            }
        }
        
        if let item = item as? Settings {
            let encoder = JSONEncoder()
            
            do {
                let data = try encoder.encode(item)
                userDefaults.set(data, forKey: Constants.userDefaultKeys.settings)
            } catch {
                print("error storing data in user defaults: \(error)")
            }
        }
    }
    
    static func getFromUserDefaults(item: String) -> Any? {
        let userDefaults = UserDefaults.standard
        let decoder = JSONDecoder()
        
        guard let data = userDefaults.data(forKey: item) else {
            print("items has not been stored in defaults yet")
            return nil
        }
        
        if item == Constants.userDefaultKeys.lastKnownWeather {
            do {
                
                let lastKnownWeather = try decoder.decode(Weather.self, from: data)
                return lastKnownWeather
            } catch {
                print("error retrieving last known weather in user defaults: \(error)")
                return nil
            }
        }
        
        if item == Constants.userDefaultKeys.settings {
            do {
                let data = userDefaults.object(forKey: item) as! Data
                let settings = try decoder.decode(Settings.self, from: data)
                return settings
            } catch {
                print("error retrieving settings in user defaults")
                return nil
            }
        }
        
        return nil
    }
}
