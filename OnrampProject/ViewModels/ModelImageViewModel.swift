//
//  ModelImageViewModel.swift
//  OnrampProject
//
//  Created by Chris Hurley on 3/4/20.
//

import Foundation

struct ModelImageViewModel {
    
    // MARK: - Properties
    
    fileprivate var images: [BaeImage] {
        return getImagesSorted()
    }
    
    // MARK: - Methods
    
    func getImagefor(typeOfWeather: WeatherCategory) -> BaeImage {
        return images[typeOfWeather.rawValue]
    }
    
    func getImages() -> [BaeImage] {
        return images
    }
    
    private func getImagesSorted() -> [BaeImage] {
        let modelImagesSortedByKey = Constants.defaults.modelImages.sorted { (arg0, arg1) -> Bool in
            let (key2, _) = arg1
            let (key1, _) = arg0
            return key1.rawValue < key2.rawValue
        }
        
        let images = modelImagesSortedByKey.map { typeOfWeather, nameOfImage in
            return BaeImage(nameOfImage, for: typeOfWeather)
        }
        
        return images
    }
}
