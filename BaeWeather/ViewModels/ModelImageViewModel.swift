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
                let settings = Settings(
                    modelName: "\(Constants.defaults.modelName)",
                    modelImageSet: currentSettings!.modelImageSet,
                    defaultImagesInUse: currentSettings!.defaultImagesInUse
                )
                userDefaultsService.settings = settings
            } else {
                let settings = Settings(
                    modelName: modelName,
                    modelImageSet: currentSettings!.modelImageSet,
                    defaultImagesInUse: currentSettings!.defaultImagesInUse
                )
                userDefaultsService.settings = settings
            }
            
            NotificationCenter.default.post(name: .didSetModelName, object: self, userInfo: ["name": ModelImageViewModel.getModelName()])
        }
    }
    
    // MARK: - Methods
    
    func getImage(for typeOfWeather: WeatherCategory, asDefault defaultImage: Bool, completion: (WeatherModelImage?) -> Void) {
        if defaultImage {
            let defaultWeatherModelImage = Constants.defaults.weatherModelImages[typeOfWeather.rawValue]
            completion(defaultWeatherModelImage)
        } else {
            let imageName = "\(typeOfWeather.rawValue)-image.png"
            
            getStoredWeatherModelImage(name: imageName) { (imageUrl) in
                if let imageUrl = imageUrl {
                    let weatherModelImage = WeatherModelImage(0, name: imageUrl.path, weatherCategory: typeOfWeather)
                    completion(weatherModelImage)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    func getImages(completion: ([WeatherModelImage?]) -> Void) {
        
        let currentSettings = userDefaultsService.settings
        
        if currentSettings == nil {
            completion([])
        }
        
        let currentImages = currentSettings!.modelImageSet
        var images: [WeatherModelImage?] = []
        
        fileService.getWeatherModelImagePaths(for: currentImages as! [String]) { (imageUrls) in
            for imageUrl in imageUrls {
                if let imageUrl = imageUrl {
                    
                    // TODO: getting filename should be extension
                    
                    // get the file name in order to get weather category
                    // ex. 1-image.png is image used for cold (1) weather
                    let fileName = imageUrl.lastPathComponent
                    let weatherCategory = Int((fileName.components(separatedBy: "-")[0]))
                    
                    let weatherModelImage = WeatherModelImage(0, name: imageUrl.path, weatherCategory: WeatherCategory(rawValue: weatherCategory!)!)
                    images.append(weatherModelImage)
                } else {
                    images.append(nil)
                }
            }
        }
        
        completion(images.sorted(by: { (weatherModelImage1, weatherModelImage2) -> Bool in
            return (weatherModelImage1?.typeOfWeather.rawValue)! < (weatherModelImage2?.typeOfWeather.rawValue)!
        }))
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
    
    func setDefaultImages(on: Bool) {
        userDefaultsService.useDefaultImages = on
        var currentSettings = userDefaultsService.settings
        
        let defaultImagesInUse = Constants.defaults.weatherModelImages.map { (weatherModelImage) -> Bool in
            return on
        }
        
        if on {
            AppDelegate.loadDefaultImages()
            
            currentSettings?.defaultImagesInUse = defaultImagesInUse
            userDefaultsService.settings = currentSettings
        } else {
            
            currentSettings?.defaultImagesInUse = defaultImagesInUse
            userDefaultsService.settings = currentSettings
        }
    }
    
    func setDefaultImage(on: Bool, for weatherCategory: WeatherCategory) {
        let currentSettings = userDefaultsService.settings
        var imagesInUse = currentSettings?.defaultImagesInUse
        imagesInUse![weatherCategory.rawValue] = on
        
        let settings = Settings(modelName: currentSettings!.modelName, modelImageSet: currentSettings!.modelImageSet, defaultImagesInUse: imagesInUse!)
        
        userDefaultsService.settings = settings
        userDefaultsService.useDefaultImages = on
    }
    
    func isUsingDefaultImages() -> Bool {
        return userDefaultsService.useDefaultImages
    }
    
    func isUsingDefaultImage(for weatherCategory: WeatherCategory) -> Bool {
        let currentSettings = userDefaultsService.settings
        let usingDefault: Bool = (currentSettings?.defaultImagesInUse[weatherCategory.rawValue])!
        return usingDefault
    }
    
    func setModel(name: String) {
        let nameTrimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !nameTrimmed.isEmpty {
            let currentSettings = userDefaultsService.settings
            
            let settings = Settings(
                modelName: nameTrimmed,
                modelImageSet: currentSettings!.modelImageSet,
                defaultImagesInUse: currentSettings!.defaultImagesInUse
            )
            
            userDefaultsService.settings = settings
            modelName = nameTrimmed
        }
    }
    
    // TODO: here is where check for if we are using a default image
    func saveModelImage(data: Data, for typeOfWeather: WeatherCategory, asDefault isDefaultImage: Bool, completion: (Bool, URL?) -> Void) {
        let imageName = "\(typeOfWeather.rawValue)-image.png"
        
        storeWeatherModelImage(data: data, name: imageName) { (success, imageURL) in
            if success {
                
                // TODO: use update image method to update in user defaults
                let currentSettings = userDefaultsService.settings
                var currentImages = currentSettings?.modelImageSet
                var defaultImagesInUse = currentSettings?.defaultImagesInUse
                
                currentImages![typeOfWeather.rawValue] = imageName
                defaultImagesInUse![typeOfWeather.rawValue] = isDefaultImage
                
                let settings = Settings(
                    modelName: currentSettings!.modelName,
                    modelImageSet: currentImages!,
                    defaultImagesInUse: defaultImagesInUse!
                )
                
                userDefaultsService.settings = settings
                
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
    
    // TODO: not in use. Test, fix and use.
    func update(image: WeatherModelImage) {
        if let currentSettings = userDefaultsService.settings {
            var currentImages = currentSettings.modelImageSet
            currentImages[image.typeOfWeather.rawValue] = image.name
            
            let settings = Settings(
                modelName: currentSettings.modelName,
                modelImageSet: currentImages,
                defaultImagesInUse: currentSettings.defaultImagesInUse
            )
            
            userDefaultsService.settings = settings
        }
    }
    
    private func getStoredWeatherModelImage(name: String, completion: (URL?) -> Void) {
        fileService.getModelImagePath(for: name) { (url) in
            completion(url)
        }
    }
    
    private func storeWeatherModelImage(data: Data, name: String, completion: (Bool, URL?) -> Void) {
        fileService.storeWeatherModelImage(data: data, name: name, completion: { (success, imageUrl) in
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
