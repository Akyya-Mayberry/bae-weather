//
//  WeatherNetworkService.swift
//  OnrampProject
//
//  Created by Chris Hurley on 3/1/20.
//

import Foundation
import Alamofire
import CoreLocation

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
  
  func getCurrentWeather(lat: Double, long: Double, completion: @escaping (WeatherData?, Error?) -> Void) {
    let urlString = "\(baseUrl)&lat=\(lat)&lon=\(long)"
    
    AF.request(urlString).responseDecodable(of: WeatherData.self) { response in
      if response.error != nil {
        completion(nil, response.error)
      } else {
        completion(response.value, nil)
      }
    }
  }
}


