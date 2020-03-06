//
//  ModelImageViewModel.swift
//  OnrampProject
//
//  Created by Chris Hurley on 3/4/20.
//

import Foundation

protocol ModelImageViewModelDelegate {
    func modelName(_ modelImageViewModel: ModelImageViewModel, didChange: Bool)
}

class ModelImageViewModel {
    
    // MARK: - Properties
    
    private let userDefaults = UserDefaults.standard
    var delegate: ModelImageViewModelDelegate?
    var selectedThumbnailIndex = 0
    
    fileprivate var images: [BaeImage] {
        return getImagesSorted()
    }
    
    @objc dynamic private(set) var modelName: String = "" {
        didSet {
            if oldValue != modelName {
                
                let useDefaultName = userDefaults.bool(forKey: Constants.userDefaultKeys.useDefaultName)
                
                if  useDefaultName {
                    userDefaults.set(Constants.defaults.modelName, forKey: Constants.userDefaultKeys.modelName)
                } else {
                    userDefaults.set(modelName, forKey: Constants.userDefaultKeys.modelName)
                }
                
                delegate?.modelName(self, didChange: true)
            } else {
                delegate?.modelName(self, didChange: false)
            }
        }
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
    
    func useDefaultImages(to on: Bool) {
        userDefaults.set(on, forKey: Constants.userDefaultKeys.useDefaultImages)
    }
    
    func useDefaultName(to on: Bool) {
        userDefaults.set(on, forKey: Constants.userDefaultKeys.useDefaultName)
        
        if on {
            modelName = Constants.defaults.modelName
        }
    }
    
    func isUsingDefaultName() -> Bool {
        return userDefaults.bool(forKey: Constants.userDefaultKeys.useDefaultName)
    }
    
    func setModel(name: String) {
        let settings = Settings(modelName: name, modelImageSet: nil)
        WeatherViewModel.storeInUserDefaults(item: settings)
        modelName = name
    }
}

extension ModelImageViewModel {
    static func getModelName() -> String? {
        if let settings = WeatherViewModel.getFromUserDefaults(item: Constants.userDefaultKeys.settings) as? Settings {
            let modelName = settings.modelName
            return modelName
        } else {
            return nil
        }
    }
}
