//
//  LoadingViewController.swift
//  OnrampProject
//
//  Created by hollywoodno on 3/11/20.
//

import UIKit

class LoadingViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    let networkService = WeatherNetworkService()
    let locationService = LocationService()
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationService.startUpdatingLocation()
        loadingSpinner.layer.opacity = 0
        loadSpinner()
    }
    
    func loadSpinner() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
            UIView.animate(withDuration: 1) {
                self.loadingSpinner.layer.opacity = 1
                self.loadingSpinner.startAnimating()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(5)) {
            self.getCurrentLocation()
        }
    }
    
    func getCurrentLocation() {
        if let currentLocation = locationService.currentLocation {
            getCurrentWeather(lat: currentLocation.lat, long: currentLocation.long)
        } else {
            print("Show there was an error getting current location")
        }
        locationService.stopUpdatingLocation()
    }
    
    func getCurrentWeather(lat: Double, long: Double) {
        networkService.getCurrentWeather(lat: lat, long: long) { (weatherData, error) in
            
            self.loadingSpinner.stopAnimating()
            
            if error != nil {
                print("loading weather returned an error, show this to user on loading screen")
            }
            
            if let weatherData = weatherData {
                
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let weatherVC = storyboard.instantiateViewController(identifier: String(describing: WeatherViewController.self)) as! WeatherViewController
                
                let weather = WeatherViewModel.makeWeather(from: weatherData)
                weatherVC.weatherViewModel = WeatherViewModel(weather: weather)
                weatherVC.weatherViewModel.delegate = weatherVC.self
                
                let settingsVC = storyboard.instantiateViewController(identifier: String(describing: SettingsViewController.self)) as! SettingsViewController
                
                let tabBarController = UITabBarController()
                tabBarController.viewControllers = [weatherVC, settingsVC]
                tabBarController.modalPresentationStyle = .fullScreen
                
                self.present(tabBarController, animated: true, completion: nil)
            }
        }
    }
}
