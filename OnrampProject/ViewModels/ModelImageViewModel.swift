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
    
    private let userDefaultsService = UserDefaultsService()
    private let userDefaults = UserDefaults.standard
    var delegate: ModelImageViewModelDelegate?
    var selectedThumbnailIndex = 0
    
    static var images: [BaeImage] {
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
            NotificationCenter.default.post(name: .didSetModelName, object: self, userInfo: ["name": modelName])
        }
    }
    
    // MARK: - Methods
    
    func getImagefor(typeOfWeather: WeatherCategory) -> BaeImage {
        let currentSettings = userDefaultsService.getFromUserDefaults(item: Constants.userDefaultKeys.settings) as? Settings
        let images = currentSettings?.modelImageSet
        return images![typeOfWeather.rawValue]
    }
    
    static func getImages() -> [BaeImage] {
        return images
    }
    
    static func getImagesSorted() -> [BaeImage] {
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
        userDefaultsService.storeInUserDefaults(item: settings)
        modelName = name
    }
    
    func getCategory(for typeOfWeather: WeatherCategory) -> String {
        switch typeOfWeather {
        case .freezing:
            return "Freezing"
        case .cold:
            return "Cold"
        case .warm:
            return "Warm"
        default:
            return "Hot"
        }
    }
    
    func getIconName(for typeOfWeather: WeatherCategory) -> String {
        switch typeOfWeather {
        case .freezing:
            return Constants.weatherCategoryIcons.freezing
        case .cold:
            return Constants.weatherCategoryIcons.cold
        case .warm:
            return Constants.weatherCategoryIcons.warm
        default:
            return Constants.weatherCategoryIcons.hot
        }
    }
    
    func update(image: BaeImage) {
        if let currentSettings = userDefaultsService.getFromUserDefaults(item: Constants.userDefaultKeys.settings) as? Settings {
            var currentImages = currentSettings.modelImageSet
            currentImages![image.typeOfWeather.rawValue] = image
            
            let settings = Settings(modelName: currentSettings.modelName, modelImageSet: currentImages)
            userDefaultsService.storeInUserDefaults(item: settings)
        }
    }
}

extension ModelImageViewModel {
    static let userDefaultsService = UserDefaultsService()
    static func getModelName() -> String? {
        if let settings = userDefaultsService.getFromUserDefaults(item: Constants.userDefaultKeys.settings) as? Settings {
            let modelName = settings.modelName
            return modelName
        } else {
            return nil
        }
    }
}

extension Notification.Name {
    static let didSetModelName = Notification.Name(Constants.notifications.modelNameSet)
}
