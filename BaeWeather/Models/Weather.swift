//
//  Weather.swift
//  OnrampProject
//
//  Created by Chris Hurley on 2/29/20.
//

import Foundation

enum WeatherCategory: Int, Codable, CaseIterable {
    case freezing = 0, cold, warm, hot
}

/**
 Defines a specific set of hourly times within a 24 hour period using military time
 
 - Description: Instead of viewing weather for every hour of the day, the weather block time
 will attempt to represent some of the most common important hours of the day for needing a temperature
 */
enum WeatherBlockTime: Int, CaseIterable, Comparable, Codable {
    static func < (lhs: WeatherBlockTime, rhs: WeatherBlockTime) -> Bool {
        return lhs.self.rawValue < rhs.self.rawValue
    }
    
    case six = 6, nine = 9, twelve = 12, sixteen = 16, nineteen = 19, twentytwo = 22
    
    // TODO: this is computed in hourly view model and should
    // be usuable from here
    func getIndex() -> Int {
        var blockIndex = -1
        for (i, hour) in WeatherBlockTime.self.allCases.sorted().enumerated() {
            if hour == self {
                blockIndex = i
            }
        }
        return blockIndex
    }
}

struct Weather: Codable {
    let date: Date
    let temperature: Int
    let low: Int
    let high: Int
    let hourlyTemps: [Int: Int]
    let city: String
    let state: String
    let country: String
    let currentHourBlock: WeatherBlockTime
}

struct WeatherData: Codable {
    let name: String
    let main: Main
    let sys: Sys
}

struct Main: Codable {
    let temp: Float
    let temp_min: Float
    let temp_max: Float
}

struct Sys: Codable {
    let country: String
}

struct WeatherBlock: Comparable {
    static func < (lhs: WeatherBlock, rhs: WeatherBlock) -> Bool {
        return lhs.hour.rawValue < rhs.hour.rawValue
    }
    
    let hour: WeatherBlockTime
    let temperature: Int
}

/**
 Takes a temperature and maps it to a generalized weather category
 */
struct TypeOfWeather: Codable {
    let category: WeatherCategory
    
    init(for temp: Int) {
        switch true {
        case temp < 50:
            category = .freezing
        case temp < 65:
            category = .cold
        case temp < 75:
            category = .warm
        default:
            category = .hot
        }
    }
    
    static func getCategoryString(for typeOfWeather: WeatherCategory) -> String {
        switch typeOfWeather {
        case .freezing:
            return "Freezing"
        case .cold:
            return "Cold"
        case .warm:
            return "Warm"
        default:
            return "Hot"
        }
    }
    
    static func getCategory(for typeOfWeather: String) -> WeatherCategory? {
        let typeOfWeather = typeOfWeather.lowercased()
        switch typeOfWeather {
        case "freezing":
            return .freezing
        case "cold":
            return .cold
        case "warm":
            return .warm
        case "hot":
            return .hot
        default:
            return nil
        }
    }
}
