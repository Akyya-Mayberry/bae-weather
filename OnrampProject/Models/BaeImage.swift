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
            image = "It's freezing. Show freezing cold image."
        case .cold:
            image = "It's cold. Show cold image."
        case .warm:
            image = "It's warm. Show warm image."
        case .hot:
            image = "It's hot. Show hot image."
        }
    }
    
    func getImage() -> String {
        return image
    }
}
