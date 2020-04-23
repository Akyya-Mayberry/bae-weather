//
//  WeatherTests.swift
//  BaeWeatherTests
//
//  Created by Chris Hurley on 4/22/20.
//

import XCTest
@testable import BaeWeather

class WeatherTests: XCTestCase {
    
    private var sut: WeatherViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let currentHourBlock = HourlyWeatherViewModel.getCurrentWeatherBlockUsing(date: Date())
        
        let weather = Weather(date: Date(), temperature: 83, hourlyTemps: [:], city: "San Francisco", state: "California", country: "USA", currentHourBlock: currentHourBlock)
        
        sut = WeatherViewModel(weather: weather)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testTemperatureConvertsToRightTypeOfWeather() throws {
        
        let currentWeatherCategory = TypeOfWeather(for: sut.currentTemp!)
        let temp1 = TypeOfWeather(for: -30)
        let temp2 = TypeOfWeather(for: 0)
        let temp3 = TypeOfWeather(for: 55)
        let temp4 = TypeOfWeather(for: 72)
        let temp5 = TypeOfWeather(for: 115)
        
        XCTAssertEqual(currentWeatherCategory.category, .hot)
        XCTAssertEqual(temp1.category, .freezing)
        XCTAssertEqual(temp2.category, .freezing)
        XCTAssertEqual(temp3.category, .cold)
        XCTAssertEqual(temp4.category, .warm)
        XCTAssertEqual(temp5.category, .hot)
    }
    
    func testGetWeatherCategoryForTypeofWeather() throws {
        let weatherCategory = sut.getWeatherCategory()
        XCTAssertEqual(weatherCategory, .hot)
    }
    
    func testMakeWeatherObjectFromWeatherData() throws {
        let weatherData = WeatherData(name: "Paris", main: Main(temp: 45), sys: Sys(country: "France"))
        let currentWeather = WeatherViewModel.makeWeather(from: weatherData)
        
        XCTAssertNotNil(currentWeather)
        XCTAssertEqual(currentWeather.city, "Paris")
        XCTAssertTrue(type(of: currentWeather) == Weather.self)
        XCTAssertFalse(type(of: currentWeather) == WeatherData.self)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
