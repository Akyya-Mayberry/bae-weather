//
//  AppDelegate.swift
//  OnrampProject
//
//  Created by Giovanni Noa on 2/20/20.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        configureTabControllerAppearance()
        loadDefaults()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

extension AppDelegate {
    func configureTabControllerAppearance() {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkGray], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkGray], for: .selected)
        
        UITabBar.appearance().tintColor = UIColor.darkGray
        UITabBar.appearance().isTranslucent = false
    }
    
    func loadDefaults() {
//        AppDelegate.loadDefaultImages()
        loadDefaultSettings()
    }
    
    func loadDefaultSettings() {
        let userDefaultsService = UserDefaultsService.sharedInstance
        
        // load defaults if user has not change settings or wants to use them
        let currentSettings = userDefaultsService.settings
        let defaultName = Constants.defaults.modelName
        
        if currentSettings == nil || userDefaultsService.useDefaultName && userDefaultsService.useDefaultImages {
            
            AppDelegate.loadDefaultImages()
            
            let settings = Settings(modelName: defaultName, modelImageSet: userDefaultsService.defaultImages)
            userDefaultsService.useDefaultImages = true
            userDefaultsService.useDefaultName = true
            userDefaultsService.settings = settings
            
            return
        }
        
        if userDefaultsService.useDefaultName  {
            let settings = Settings(modelName: defaultName, modelImageSet: currentSettings!.modelImageSet)
            userDefaultsService.settings = settings
        }
        
        if userDefaultsService.useDefaultImages {
            AppDelegate.loadDefaultImages()

            let settings = Settings(modelName: currentSettings!.modelName, modelImageSet: userDefaultsService.defaultImages)
            userDefaultsService.settings = settings
        }
    }
}

extension AppDelegate {
    static func loadDefaultImages() {
        let userDefaultsService = UserDefaultsService.sharedInstance

        var defaultImages: [String] = []
        
        for weathercasterImage in Constants.defaults.weathercasterImages {
            let weatherCategoryString = String(weathercasterImage.typeOfWeather.rawValue)
            let image = UIImage(named: weathercasterImage.name)
            
            let imageName = "\(weatherCategoryString)-image.png"
            
            if let imageData = image?.pngData() {
                storeDefaultImages(data: imageData, name: imageName) { (success, imageUrl) in
                    if success {
                        defaultImages.append(imageName)
                    } else {
                        fatalError("Error storing default image")
                    }
                }
            } else {
                fatalError("Error converting default image to data")
            }
        }
        
        userDefaultsService.defaultImages = defaultImages
    }
    
    static func storeDefaultImages(data: Data, name: String, completion: (Bool, URL?) -> Void) {
        let fileService = FileService.sharedInstance
        
        fileService.storeWebcasterImage(data: data, name: name, completion: { (success, imageUrl) in
            completion(success, imageUrl)
        })
    }
}

