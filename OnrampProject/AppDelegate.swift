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
        
        // Deletes user defaults
//        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
//        UserDefaults.standard.synchronize()
//
//        for (k, v) in UserDefaults.standard.dictionaryRepresentation() {
//            print("\(k) : \(v)")
//        }
        
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
    func loadDefaults() {
        let userDefaultsService = UserDefaultsService()
        let userDefaults = UserDefaults.standard
        
        // load defaults if user has not change settings or wants to them
        let currentSettings = userDefaultsService.getFromUserDefaults(item: Constants.userDefaultKeys.settings) as? Settings
        let modelImages = ModelImageViewModel.getImages()
        
        if currentSettings == nil {
            let settings = Settings(modelName: Constants.defaults.modelName, modelImageSet: modelImages)
            userDefaults.set(true, forKey: Constants.userDefaultKeys.useDefaultImages)
            userDefaults.set(true, forKey: Constants.userDefaultKeys.useDefaultName)
            userDefaultsService.storeInUserDefaults(item: settings)
        } else if UserDefaults.standard.bool(forKey: Constants.userDefaultKeys.useDefaultName) {
            let settings = Settings(modelName: Constants.defaults.modelName, modelImageSet: currentSettings?.modelImageSet)
            userDefaultsService.storeInUserDefaults(item: settings)
        } else if UserDefaults.standard.bool(forKey: Constants.userDefaultKeys.useDefaultImages ) {
            let settings = Settings(modelName: currentSettings!.modelName, modelImageSet: modelImages)
            userDefaultsService.storeInUserDefaults(item: settings)
        }
    }
}

