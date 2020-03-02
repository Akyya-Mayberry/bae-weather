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
    private let sortedBlockTimes: [WeatherBlockTime] = WeatherBlockTime.allCases.sorted()
    var currentHourBlock: WeatherBlockTime
    
    // MARK: - Methods
    
    init(_ hourlyTempBlocks: [Int: Int], currentDate: Date) {
        self.currentHourBlock = HourlyWeatherViewModel.getCurrentWeatherBlockUsing(date: currentDate)
        createWeatherBlocks(from: hourlyTempBlocks)
    }
    
    mutating func createWeatherBlocks(from hourlyTempBlocks: [Int: Int]) {
        // Todo: use reduce
        for (hour, temp) in hourlyTempBlocks {
            let blockTime = WeatherBlockTime(rawValue: hour)
            weatherBlocks[blockTime!] = temp
        }
    }
    
    static func getCurrentWeatherBlockUsing(date: Date) -> WeatherBlockTime {
        
        let time = date.getHour()
        var hourBlock: WeatherBlockTime
        
        switch true {
        case time <= WeatherBlockTime.six.rawValue:
            hourBlock = .six
        case time <= WeatherBlockTime.nine.rawValue:
            hourBlock = .nine
        case time <= WeatherBlockTime.twelve.rawValue:
            hourBlock = .twelve
        case time <= WeatherBlockTime.sixteen.rawValue:
            hourBlock = .sixteen
        case time <= WeatherBlockTime.nineteen.rawValue:
            hourBlock = .nineteen
        case time <= WeatherBlockTime.twentytwo.rawValue:
            hourBlock = .twentytwo
        default:
            hourBlock = .twelve
        }
        
        return hourBlock
    }
    
    func getCurrentWeatherBlockUsing(hour h: Int) -> WeatherBlock {
        
        for (hour, temp) in weatherBlocks {
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
    
    func getSortedBlockTimes() -> [WeatherBlockTime] {
        return sortedBlockTimes
    }
    
    func getIndex(for blockTime: WeatherBlockTime) -> Int {
        return sortedBlockTimes.firstIndex(of: blockTime)!
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
