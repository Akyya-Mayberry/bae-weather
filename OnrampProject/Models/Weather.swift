//
//  Weather.swift
//  OnrampProject
//
//  Created by Chris Hurley on 2/29/20.
//

import Foundation

/**
 Takes a temperature and maps it to a generalized weather category
 */
enum TypeOfWeather {
    case hot, warm, cold, freezing
    
    init(for temp: Int) {
        switch true {
        case temp < 50:
            self = .freezing
        case temp < 65:
            self = .cold
        case temp < 75:
            self = .warm
        default:
            self = .hot
        }
    }
}

/**
 Defines a specific set of hourly times within a 24 hour period using military time
 
 - Description: Instead of viewing weather for every hour of the day, the weather block time
 will attempt to represent some of the most common important hours of the day for needing a temperature
 */
enum WeatherBlockTime: Int, CaseIterable {
    case six = 6, nine = 9, twelve = 12, sixteen = 16, nineteen = 19, twentytwo = 22
    
}

struct WeatherBlock {
    let hour: WeatherBlockTime
    let temperature: Int
}

struct Weather {
    let temperature: Int
    let hourlyTemps: [Int: Int]
    let city: String
    let state: String
    let country: String
}
