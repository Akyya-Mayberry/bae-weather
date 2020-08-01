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
        
        static let weatherModelImages = [
            WeatherModelImage(0, name: "abstract-freezing", weatherCategory: .freezing, isDefault: true),
            WeatherModelImage(0, name: "abstract-cold", weatherCategory: .cold, isDefault: true),
            WeatherModelImage(0, name: "abstract-warm", weatherCategory: .warm, isDefault: true),
            WeatherModelImage(0, name: "abstract-hot", weatherCategory: .hot, isDefault: true)
        ]
        
        static let modelName = "Bae 🥰"
        static let numberOfImageCoections = 1
        static let numberOfImagesInSet = 4
        static let location = (city: "Fresno", state: "California")
        
        struct settings {
            static let placeholderText = "enter name"
        }
    }
    
    struct userDefaultKeys {
        static let modelName = "modelName"
        static let images = "images"
        static let defaultImages = "defaultImages"
        static let useDefaultName = "useDefaultName"
        static let useDefaultImages = "useDefaultImages"
        static let lastKnownWeather = "weather"
        static let settings = "settings"
        static let defaultImagesInUse = "defaultImagesInUse"
    }
    
    struct notifications {
        static let modelNameSet = "didSetModelName"
    }
    
    struct weatherCategoryIcons {
        static let freezing = "icon-freezing-filled"
        static let cold = "icon-cold-filled"
        static let warm = "icon-warm-filled"
        static let hot = "icon-hot-filled"
    }
    
    struct tabBarItems {
        static let weather = "thermometer"
        static let settings = "settings"
    }
    
    static var imagesDirectory = "weatherModelImages/0"
}


