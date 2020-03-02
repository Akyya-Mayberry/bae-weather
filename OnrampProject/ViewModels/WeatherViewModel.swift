//
//  Weather.swift
//  OnrampProject
//
//  Created by Chris Hurley on 2/29/20.
//

import Foundation

/**
 Manages a current weather object
 */
struct WeatherViewModel {
    
    // MARK: - Properties
    
    private(set) var baeImage: BaeImage
    private(set) var lastUpdateTime: String
    private(set) var currentTemp: Int
    private(set) var weather: Weather
    
    fileprivate static var testWeatherIndex = 0 {
        didSet {
            if testWeatherIndex >= WeatherViewModel.getTestWeatherObjects().count {
                testWeatherIndex = 0
            }
        }
    }
    
    var currentDateAsString: String {
        return getFormattedDate(Date())
    }
    
    var currentTimeAsString: String {
        return weather.date.getTimeAsString()
    }
    
    // MARK: - Methods
    
    init(weather: Weather) {
        self.weather = weather
        
        let typeOfWeather = TypeOfWeather(for: weather.temperature)
        baeImage = BaeImage(for: typeOfWeather)
        currentTemp = weather.temperature
        
        lastUpdateTime = weather.date.getTimeAsString()
        
        WeatherViewModel.testWeatherIndex += 1
    }
    
    mutating func updateCurrentWeather(city: String, state: String, country: String) {
        // replace with API call
        weather = WeatherViewModel.getTestWeatherObjects()[0]
    }
    
    func getFormattedDate(_ date: Date) -> String {
        return date.getDateAsString()
    }
    
    func getHourlyTemps() -> [Int: Int] {
        return weather.hourlyTemps
    }
    
    func getCurrentWeatherBlock() -> WeatherBlockTime {
        return weather.currentHourBlock
    }
    
}

// MARK: - Extensions

extension WeatherViewModel {
    // for testing purposes
    
    static func getTestWeatherObjects() -> [Weather] {
        let weatherObjects = [
            Weather(
                date: Date(),
                temperature: 116,
                hourlyTemps: [6 : 30, 9: 67, 12: 78, 16: 99, 19: 90, 22: 50],
                city: "Fresno",
                state: "California",
                country: "USA",
                currentHourBlock: .six),
            Weather(
                date: Date(),
                temperature: 67,
                hourlyTemps: [6 : 54, 9: 57, 12: 61, 16: 57, 19: 55, 22: 50],
                city: "San Francisco",
                state: "California",
                country: "USA",
                currentHourBlock: .twelve),
            Weather(
                date: Date(),
                temperature: 76,
                hourlyTemps: [6 : 67, 9: 70, 12: 73, 16: 75, 19: 77, 22: 69],
                city: "Los Angeles",
                state: "California",
                country: "USA",
                currentHourBlock: .nine),
            Weather(
                date: Date(),
                temperature: 83,
                hourlyTemps: [6 : 70, 9: 72, 12: 79, 16: 81, 19: 76, 22: 69],
                city: "Tahoe",
                state: "California",
                country: "USA",
                currentHourBlock: .sixteen)
        ]
        
        return weatherObjects
    }
    
    
    static func getNextWeather() -> Weather {
        return WeatherViewModel.getTestWeatherObjects()[WeatherViewModel.testWeatherIndex]
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
}
