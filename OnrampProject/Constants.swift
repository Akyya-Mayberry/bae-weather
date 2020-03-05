//
//  Constants.swift
//  OnrampProject
//
//  Created by Chris Hurley on 3/4/20.
//

import Foundation

class Constants {
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
