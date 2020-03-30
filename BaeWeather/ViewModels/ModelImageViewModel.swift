//
//  ModelImageViewModel.swift
//  OnrampProject
//
//  Created by Chris Hurley on 3/4/20.
//

import Foundation

protocol ModelImageViewModelDelegate {
    func modelName(_ modelImageViewModel: ModelImageViewModel, willChange: Bool, name: String)
}

class ModelImageViewModel {
    
    // MARK: - Properties
    
    private let userDefaultsService = UserDefaultsService.sharedInstance
    var delegate: ModelImageViewModelDelegate?
    var selectedThumbnailIndex = 0
    
    fileprivate var images: [BaeImage] {
        return getImagesSorted()
    }
    
    @objc dynamic private(set) var modelName: String = "" {
        willSet {
            if newValue != modelName {
                delegate?.modelName(self, willChange: true, name: newValue)
            } else {
                delegate?.modelName(self, willChange: false, name: newValue)
            }
        }
        
        didSet {
            let useDefaultName = userDefaultsService.useDefaultName
            
            if  useDefaultName {
                let settings = Settings(modelName: "\(Constants.defaults.modelName)", modelImageSet: nil)
                userDefaultsService.settings = settings
            } else {
                let settings = Settings(modelName: modelName, modelImageSet: nil)
                userDefaultsService.settings = settings
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
        userDefaultsService.useDefaultImages = on
    }
    
    func setDefaultName(on: Bool) {
        userDefaultsService.useDefaultName = on
        
        if on {
            setModel(name: Constants.defaults.modelName)
        }
    }
    
    func isUsingDefaultName() -> Bool {
        return userDefaultsService.useDefaultName
    }
    
    func setModel(name: String) {
        let nameTrimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !nameTrimmed.isEmpty {
            let settings = Settings(modelName: nameTrimmed, modelImageSet: nil)
            userDefaultsService.settings = settings
            modelName = nameTrimmed
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
        if let currentSettings = userDefaultsService.settings {
            var currentImages = currentSettings.modelImageSet
            currentImages![image.typeOfWeather.rawValue] = image
            
            let settings = Settings(modelName: currentSettings.modelName, modelImageSet: currentImages)
            userDefaultsService.settings = settings
        }
    }
}

extension ModelImageViewModel {
    static let userDefaultsService = UserDefaultsService.sharedInstance
    static func getModelName() -> String {
        if let settings = userDefaultsService.settings {
            return settings.modelName
        } else {
            return Constants.defaults.modelName
        }
    }
}

extension Notification.Name {
    static let didSetModelName = Notification.Name(Constants.notifications.modelNameSet)
}
