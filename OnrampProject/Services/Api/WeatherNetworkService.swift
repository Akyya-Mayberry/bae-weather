//
//  WeatherNetworkService.swift
//  OnrampProject
//
//  Created by Chris Hurley on 3/1/20.
//

import Foundation
import Alamofire

class WeatherNetworkService {
    
    func getCurrentWeatherIn(city: String, state: String) {
        AF.request("https://httpbin.org/get").response { response in
            debugPrint(response)
        }
    }
}
