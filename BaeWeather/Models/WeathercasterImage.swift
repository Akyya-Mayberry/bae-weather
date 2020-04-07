//
//  BaeFit.swift
//  OnrampProject
//
//  Created by Chris Hurley on 2/29/20.
//

import Foundation

/**
 Returns an image based on type of weather
 - Parameters typeOfWeather: An object that describes weather based on generalized weather categories
 - Returns: An image representing a weather category
 */
struct WeathercasterImage: Codable {
    private(set) var collectionId: Int
    private(set) var name: String
    private(set) var typeOfWeather: WeatherCategory
    private(set) var date: Date
    
    init(_ collectionId: Int, name: String, weatherCategory: WeatherCategory) {
        self.collectionId = collectionId
        self.name = name
        self.typeOfWeather = weatherCategory
        self.date = Date()
    }
}
