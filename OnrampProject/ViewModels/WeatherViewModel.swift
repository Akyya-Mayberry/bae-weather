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
    
    private(set) var baeImage: BaeImage?
    private(set) var lastUpdateTime: String?
    private(set) var currentTemp: Int?
    
    var currentDate: String {
        return getFormattedDate(Date())
    }
    
    private var weather: Weather? {
        didSet {
            let typeOfWeather = TypeOfWeather(for: weather!.temperature)
            baeImage = BaeImage(for: typeOfWeather)
            lastUpdateTime = getFormattedTime(for: Date())
            currentTemp = weather?.temperature
            testWeatherIndex += 1
        }
    }
    
    private var testWeatherIndex = 0 {
        didSet {
            if testWeatherIndex >= getTestWeatherObjects().count {
                testWeatherIndex = 0
            }
        }
    }
    
    // MARK: - Methods
    
    mutating func updateCurrentWeather(city: String, state: String, country: String) {
        // replace with API call
        weather = getTestWeatherObjects()[testWeatherIndex]
    }
    
    private func getFormattedDate(_ date: Date) -> String {
        return "11:00pm"
    }
    
    private func getFormattedTime(for date: Date) -> String {
        return "3:30pm"
    }
    
}

// MARK: - Extensions

extension WeatherViewModel {
    
    private func getTestWeatherObjects() -> [Weather] {
        let weatherObjects = [
            Weather(temperature: 116,
                    hourlyTemps: [6 : 80, 9: 104],
                    city: "Fresno",
                    state: "California",
                    country: "USA"),
            Weather(temperature: 67,
                    hourlyTemps: [6 : 52, 9: 63],
                    city: "San Francisco",
                    state: "California",
                    country: "USA"),
            Weather(temperature: 76,
                    hourlyTemps: [6 : 69, 9: 74],
                    city: "Los Angeles",
                    state: "California",
                    country: "USA"),
            Weather(temperature: 83,
                    hourlyTemps: [6 : 60, 9: 80],
                    city: "Tahoe",
                    state: "California",
                    country: "USA")
        ]
        
        return weatherObjects
    }
    
}
