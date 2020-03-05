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
        // Override point for customization after application launch.
        
        for (k, v) in UserDefaults.standard.dictionaryRepresentation() {
            print("\(k) : \(v)")
        }
        
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
        let userDefaults = UserDefaults.standard
        
        // use default name if none is set or using default flag is set
        if userDefaults.string(forKey: Constants.userDefaultKeys.modelName) == nil {
            userDefaults.set(true, forKey: Constants.userDefaultKeys.useDefaultName)
        }
        
        if userDefaults.bool(forKey: Constants.userDefaultKeys.useDefaultName) {
            userDefaults.set(Constants.defaults.modelName, forKey: Constants.userDefaultKeys.modelName)
        }
    }
}

