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
    let weatherViewModel = WeatherViewModel(weather: nil)
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationService.startUpdatingLocation()
        weatherViewModel.delegate = self
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
        if locationService.currentLocation != nil {
            //            getCurrentWeather(lat: currentLocation.lat, long: currentLocation.long)
            weatherViewModel.getCurrentWeather()
        } else {
            print("Show there was an error getting current location")
        }
        locationService.stopUpdatingLocation()
    }
}

extension LoadingViewController: WeatherViewModelDelegate {
    func didUpdateWeather(_ weatherViewModel: WeatherViewModel) {
        self.loadingSpinner.stopAnimating()
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let weatherVC = storyboard.instantiateViewController(identifier: String(describing: WeatherViewController.self)) as! WeatherViewController
        
        weatherVC.weatherViewModel = WeatherViewModel(weather: weatherViewModel.weather)
        weatherVC.weatherViewModel.delegate = weatherVC.self
        
        let settingsVC = storyboard.instantiateViewController(identifier: String(describing: SettingsViewController.self)) as! SettingsViewController
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [weatherVC, settingsVC]
        tabBarController.modalPresentationStyle = .fullScreen
        
        self.present(tabBarController, animated: true, completion: nil)
    }
    
    func didFailWithError(_ weatherViewModel: WeatherViewModel, _ error: Error) {
        self.loadingSpinner.stopAnimating()
        print("loading weather returned an error: \(error), show this to user on loading screen")
    }
    
    func didUpdateModelImageDetails(_ weatherViewModel: WeatherViewModel, modelImageViewModel: ModelImageViewModel) {
        //
    }
}
