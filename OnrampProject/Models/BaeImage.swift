//
//  BaeFit.swift
//  OnrampProject
//
//  Created by Chris Hurley on 2/29/20.
//

import Foundation

/**
 Returns an image based on type of weather
 - Parameter typeOfWeather: An object that describes weather based on generalized weather categories
 - Returns: An image representing a genralized weather category
 */
struct BaeImage {
    private(set) var image: String
    private(set) var typeOfWeather: WeatherCategory
    
    init(_ image: String, for weatherCategory: WeatherCategory) {
        self.image = image
        self.typeOfWeather = weatherCategory
    }
}
