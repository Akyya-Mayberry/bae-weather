//
//  UserDefaultsService.swift
//  OnrampProject
//
//  Created by Chris Hurley on 3/5/20.
//

import Foundation

class UserDefaultsService {
    
    // MARK: - Properties
    static let sharedInstance = UserDefaultsService()
    
    var useDefaultName: Bool {
        get { return UserDefaults.standard.bool(forKey: Constants.userDefaultKeys.useDefaultName) }
        set { UserDefaults.standard.set(newValue, forKey: Constants.userDefaultKeys.useDefaultName) }
    }
    
    var useDefaultImages: Bool {
        get { return UserDefaults.standard.bool(forKey: Constants.userDefaultKeys.useDefaultImages) }
        set { UserDefaults.standard.set(newValue, forKey: Constants.userDefaultKeys.useDefaultImages) }
    }
    
    var modelName: String? {
        get { return UserDefaults.standard.string(forKey: Constants.userDefaultKeys.modelName) }
        set { UserDefaults.standard.set(newValue, forKey: Constants.userDefaultKeys.modelName) }
    }
    
    var lastKnownWeather: Weather? {
        get {
            let weather = decodeFromUserDefaults(item: Constants.userDefaultKeys.lastKnownWeather)
            return weather as? Weather
        }
        set {
            let weatherData = encodeForUserDefaults(item: newValue)
            UserDefaults.standard.set(weatherData, forKey: Constants.userDefaultKeys.lastKnownWeather)
        }
    }
    
    var settings: Settings? {
        get {
            let settings = decodeFromUserDefaults(item: Constants.userDefaultKeys.settings)
            return settings as? Settings
        }
        set {
            let settingsData = encodeForUserDefaults(item: newValue)
            UserDefaults.standard.set(settingsData, forKey: Constants.userDefaultKeys.settings)
        }
    }
    
    // MARK: - Methods
    
    private init() { }
    
    fileprivate func encodeForUserDefaults(item: Any?) -> Any? {
        
        if let item = item as? Weather {
            let encoder = JSONEncoder()
            
            do {
                let data = try encoder.encode(item)
                return data
            } catch {
                print("error storing data in user defaults: \(error)")
            }
        }
        
        if let item = item as? Settings {
            let encoder = JSONEncoder()
            
            do {
                let data = try encoder.encode(item)
                return data
            } catch {
                print("error storing data in user defaults: \(error)")
            }
        }
        
        return nil
    }
    
    fileprivate func decodeFromUserDefaults(item: String) -> Any? {
        let decoder = JSONDecoder()
        
        guard let data = UserDefaults.standard.data(forKey: item) else {
            print("items has not been stored in defaults yet")
            return nil
        }
        
        if item == Constants.userDefaultKeys.lastKnownWeather {
            do {
                let lastKnownWeather = try decoder.decode(Weather.self, from: data)
                return lastKnownWeather
            } catch {
                print("error retrieving last known weather in user defaults: \(error)")
            }
        }
        
        if item == Constants.userDefaultKeys.settings {
            do {
                let settings = try decoder.decode(Settings.self, from: data)
                return settings
            } catch {
                print("error retrieving settings in user defaults")
            }
        }
        
        return nil
    }
}
