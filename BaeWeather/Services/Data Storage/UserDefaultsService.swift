//
//  UserDefaultsService.swift
//  OnrampProject
//
//  Created by Chris Hurley on 3/5/20.
//

import Foundation

struct UserDefaultsService {
    let userDefaults = UserDefaults.standard
        
    func storeInUserDefaults(item: Any?) {
        
        if let item = item as? Weather {
            let encoder = JSONEncoder()
            
            do {
                let data = try encoder.encode(item)
                userDefaults.set(data, forKey: Constants.userDefaultKeys.lastKnownWeather)
            } catch {
                print("error storing data in user defaults: \(error)")
            }
        }
        
        if let item = item as? Settings {
            let encoder = JSONEncoder()
            
            do {
                let data = try encoder.encode(item)
                userDefaults.set(data, forKey: Constants.userDefaultKeys.settings)
            } catch {
                print("error storing data in user defaults: \(error)")
            }
        }
    }
    
    func getFromUserDefaults(item: String) -> Any? {
        let decoder = JSONDecoder()
        
        guard let data = userDefaults.data(forKey: item) else {
            print("items has not been stored in defaults yet")
            return nil
        }
        
        if item == Constants.userDefaultKeys.lastKnownWeather {
            do {
                
                let lastKnownWeather = try decoder.decode(Weather.self, from: data)
                return lastKnownWeather
            } catch {
                print("error retrieving last known weather in user defaults: \(error)")
                return nil
            }
        }
        
        if item == Constants.userDefaultKeys.settings {
            do {
                let data = userDefaults.object(forKey: item) as! Data
                let settings = try decoder.decode(Settings.self, from: data)
                return settings
            } catch {
                print("error retrieving settings in user defaults")
                return nil
            }
        }
        
        return nil
    }
}
