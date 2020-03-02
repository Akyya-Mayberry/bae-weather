//
//  WeatherNetworkService.swift
//  OnrampProject
//
//  Created by Chris Hurley on 3/1/20.
//

import Foundation
import Alamofire

struct WeatherNetworkService {
    private let baseUrl = Constants.WeatherService.baseUrl
    
    func getCurrentWeather(city: String, state: String, completion: @escaping (WeatherData?, Error?) -> Void) {
        
        let urlString = "\(baseUrl)&q=\(city),\(state)"
        
        AF.request(urlString).responseDecodable(of: WeatherData.self) { response in
            if response.error != nil {
                completion(nil, response.error)
            } else {
                completion(response.value, nil)
            }
        }
    }
}


