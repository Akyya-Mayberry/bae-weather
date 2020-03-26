//
//  ModelImageViewModel.swift
//  OnrampProject
//
//  Created by Chris Hurley on 3/4/20.
//

import Foundation

protocol ModelImageViewModelDelegate {
    func modelName(_ modelImageViewModel: ModelImageViewModel, didChange: Bool, name: String)
}

class ModelImageViewModel {
    
    // MARK: - Properties
    
    private let userDefaultsService = UserDefaultsService()
    private let userDefaults = UserDefaults.standard
    var delegate: ModelImageViewModelDelegate?
    var selectedThumbnailIndex = 0
    
    fileprivate var images: [BaeImage] {
        return getImagesSorted()
    }
    
    @objc dynamic private(set) var modelName: String = Constants.defaults.modelName {
        didSet {
            if oldValue != modelName {
                
                let useDefaultName = userDefaults.bool(forKey: Constants.userDefaultKeys.useDefaultName)
                
                if  useDefaultName {
                    let settings = Settings(modelName: "\(Constants.defaults.modelName)", modelImageSet: nil)
                    userDefaultsService.storeInUserDefaults(item: settings)
                } else {
                    let settings = Settings(modelName: modelName, modelImageSet: nil)
                    userDefaultsService.storeInUserDefaults(item: settings)
                }
                
                delegate?.modelName(self, didChange: true, name: ModelImageViewModel.getModelName())
            } else {
                delegate?.modelName(self, didChange: false, name: ModelImageViewModel.getModelName())
            }
            NotificationCenter.default.post(name: .didSetModelName, object: self, userInfo: ["name": ModelImageViewModel.getModelName()])
        }
    }
    
    // MARK: - Methods
    
    func getImagefor(typeOfWeather: WeatherCategory) -> BaeImage {
        return images[typeOfWeather.rawValue]
    }
    
    func getImages() -> [BaeImage] {
        return images
    }
    
    func getImagesSorted() -> [BaeImage] {
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
    
    func useDefaultName(on: Bool) {
        userDefaults.set(on, forKey: Constants.userDefaultKeys.useDefaultName)
        
        if on {
            modelName = Constants.defaults.modelName
        }
    }
    
    func isUsingDefaultName() -> Bool {
        return userDefaults.bool(forKey: Constants.userDefaultKeys.useDefaultName)
    }
    
    func setModel(name: String) {
        if !name.isEmpty {
            let settings = Settings(modelName: name, modelImageSet: nil)
            userDefaultsService.storeInUserDefaults(item: settings)
            modelName = name
        }
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
    static func getModelName() -> String {
        if let settings = userDefaultsService.getFromUserDefaults(item: Constants.userDefaultKeys.settings) as? Settings {
            return settings.modelName
        } else {
            return Constants.defaults.modelName
        }
    }
}

extension Notification.Name {
    static let didSetModelName = Notification.Name(Constants.notifications.modelNameSet)
}
