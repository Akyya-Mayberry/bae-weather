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
    private let fileService = FileService.sharedInstance
    var delegate: ModelImageViewModelDelegate?
    var selectedThumbnailIndex = 0
    
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
            let currentSettings = userDefaultsService.settings
            
            if  useDefaultName {
                let settings = Settings(modelName: "\(Constants.defaults.modelName)", modelImageSet: currentSettings!.modelImageSet)
                userDefaultsService.settings = settings
            } else {
                let settings = Settings(modelName: modelName, modelImageSet: currentSettings!.modelImageSet)
                userDefaultsService.settings = settings
            }
            
            NotificationCenter.default.post(name: .didSetModelName, object: self, userInfo: ["name": ModelImageViewModel.getModelName()])
        }
    }
    
    // MARK: - Methods
    
    func getImage(for typeOfWeather: WeatherCategory, completion: (WeathercasterImage?) -> Void) {
        let imageName = "\(typeOfWeather.rawValue)-image.png"
        
        getStoredWeathercasterImage(name: imageName) { (imageUrl) in
            if let imageUrl = imageUrl {
                let weathercasterImage = WeathercasterImage(0, name: imageUrl.path, weatherCategory: typeOfWeather)
                completion(weathercasterImage)
            } else {
                completion(nil)
            }
        }
    }
    
    func getImages(completion: ([WeathercasterImage?]) -> Void) {
        
        let currentSettings = userDefaultsService.settings
        
        if currentSettings == nil {
            completion([])
        }
        
        let currentImages = currentSettings!.modelImageSet
        var images: [WeathercasterImage?] = []
        
        fileService.getWeathercasterImagePaths(for: currentImages as! [String]) { (imageUrls) in
            for imageUrl in imageUrls {
                if let imageUrl = imageUrl {
                    
                    // TODO: getting filename should be extension
                    
                    // get the file name in order to get weather category
                    // ex. 1-image.png is image used for cold (1) weather
                    let fileName = imageUrl.lastPathComponent
                    let weatherCategory = Int((fileName.components(separatedBy: "-")[0]))
                    
                    let weathercasterImage = WeathercasterImage(0, name: imageUrl.path, weatherCategory: WeatherCategory(rawValue: weatherCategory!)!)
                    images.append(weathercasterImage)
                } else {
                    images.append(nil)
                }
            }
        }
        
        completion(images.sorted(by: { (weathercasterImage1, weathercasterImage2) -> Bool in
            return (weathercasterImage1?.typeOfWeather.rawValue)! < (weathercasterImage2?.typeOfWeather.rawValue)!
        }))
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
            let currentSettings = userDefaultsService.settings
            let settings = Settings(modelName: nameTrimmed, modelImageSet: currentSettings!.modelImageSet)
            userDefaultsService.settings = settings
            modelName = nameTrimmed
        }
    }
    
    func saveModelImage(data: Data, for typeOfWeather: WeatherCategory, completion: (Bool, URL?) -> Void) {
        let imageName = "\(typeOfWeather.rawValue)-image.png"
        
        storeWeathercasterImage(data: data, name: imageName) { (success, imageURL) in
            if success {
                
                // TODO: use update image method to update in user defaults
                var currentSettings = userDefaultsService.settings
                currentSettings?.modelImageSet[typeOfWeather.rawValue] = imageName
                userDefaultsService.settings = currentSettings
                
                completion(true, imageURL)
            } else {
                print("Error saving model image in model image view model")
                completion(false, nil)
            }
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
    
    func update(image: WeathercasterImage) {
        if let currentSettings = userDefaultsService.settings {
            var currentImages = currentSettings.modelImageSet
            currentImages[image.typeOfWeather.rawValue] = image.name
            
            let settings = Settings(modelName: currentSettings.modelName, modelImageSet: currentImages)
            userDefaultsService.settings = settings
        }
    }
    
    private func getStoredWeathercasterImage(name: String, completion: (URL?) -> Void) {
        fileService.getWebcasterImagePath(for: name) { (url) in
            completion(url)
        }
    }
    
    private func storeWeathercasterImage(data: Data, name: String, completion: (Bool, URL?) -> Void) {
        fileService.storeWebcasterImage(data: data, name: name, completion: { (success, imageUrl) in
            completion(success, imageUrl)
        })
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
