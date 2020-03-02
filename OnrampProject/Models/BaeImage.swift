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
    private let image: String
    
    init(for typeOfWeather: TypeOfWeather) {
        switch typeOfWeather {
        case .freezing:
            image = "sample-freezing"
        case .cold:
            image = "sample-cold"
        case .warm:
            image = "sample-warm"
        case .hot:
            image = "sample-hot"
        }
    }
    
    func getImage() -> String {
        return image
    }
}
