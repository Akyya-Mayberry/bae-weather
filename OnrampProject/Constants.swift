//
//  Constants.swift
//  OnrampProject
//
//  Created by Chris Hurley on 3/1/20.
//

import Foundation

struct Constants {
    
    struct WeatherService {
        static let apiKey = "9c5a3d7c65785e89e4937eee59400c75"
        static let baseUrl = "https://api.openweathermap.org/data/2.5/weather?appid=9c5a3d7c65785e89e4937eee59400c75&units=imperial"
    }
    
    struct defaults {
        static let modelImages: [WeatherCategory: String] =
            [
                .freezing: "sample-freezing",
                .cold: "sample-cold",
                .warm: "sample-warm",
                .hot: "sample-hot"
        ]
        
        static let modelName = "Bae"
        static let numberOfImageCollections = 1
        static let numberOfImagesInSet = 4
        
        struct settings {
            static let placeholderText = "enter name"
        }
    }
}
    

