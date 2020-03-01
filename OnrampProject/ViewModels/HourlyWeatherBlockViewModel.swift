//
//  HourlyWeatherBlockViewModel.swift
//  OnrampProject
//
//  Created by Chris Hurley on 2/29/20.
//

import Foundation

/**
 Manages the hourly weather updates for a weather forecast
 */
struct HourlyWeatherViewModel {
    
    // MARK: - Properties
    
    private var weatherBlocks: [WeatherBlockTime: Int] = [:]
    
    // MARK: - Methods
    
    init(_ hourlyTempBlocks: [Int: Int]) {
        createWeatherBlocks(from: hourlyTempBlocks)
    }
    
    mutating func createWeatherBlocks(from hourlyTempBlocks: [Int: Int]) {
        
        // Todo: use reduce
        for (hour, temp) in hourlyTempBlocks {
            let blockTime = WeatherBlockTime(rawValue: hour)
            weatherBlocks[blockTime!] = temp
        }
    }
    
    func getCurrentWeatherBlockUsing(date: Date) -> WeatherBlock {
        
        let time = date.getHour()
        
        for (hour, temp) in weatherBlocks {
            print("Hour raw value: \(hour.rawValue)")
            if hour.rawValue >= time {
                return WeatherBlock(hour: hour, temperature: temp)
            }
        }
        
        return WeatherBlock(hour: .twelve, temperature: weatherBlocks[.twelve]!)
    }
    
    func getCurrentWeatherBlockUsing(hour h: Int) -> WeatherBlock {
        
        
        for (hour, temp) in weatherBlocks {
            print("Hour raw value: \(hour.rawValue)")
            if hour.rawValue >= h {
                return WeatherBlock(hour: hour, temperature: temp)
            }
        }
        
        return WeatherBlock(hour: .twelve, temperature: weatherBlocks[.twelve]!)
    }
    
    func getCurrentWeatherBlockUsing(hourBlock h: WeatherBlockTime) -> WeatherBlock {
        return WeatherBlock(hour: h, temperature: weatherBlocks[h]!)
    }
    
    func getHourlyWeatherBlocks() -> [WeatherBlockTime: Int] {
        return weatherBlocks
    }
    
    func getFormmattedBlockTime(hour date: Date) -> Int {
        let hour = date.getHour()
        return hour
    }
}

extension Date {
    func getHour() -> Int {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateFormat = "HH"
        
        let hour = formatter.string(from: self)
        return Int(hour)!
    }
}
