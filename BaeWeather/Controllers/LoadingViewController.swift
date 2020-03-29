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
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tryAgainButton: UIButton! {
        didSet {
            tryAgainButton.layer.borderColor = UIColor.darkGray.cgColor
            tryAgainButton.layer.borderWidth = 1
            tryAgainButton.layer.cornerRadius = 10
        }
    }
    
    let networkService = WeatherNetworkService()
    let locationService = LocationService.sharedInstance
    let weatherViewModel = WeatherViewModel(weather: nil)
    let weatherError = "Error occurred fetching weather for your location."
    let locationError = "Error occurred getting your current location"
    
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
            weatherViewModel.getCurrentWeather()
        } else {
            messageLabel.text = locationError
        }
        locationService.stopUpdatingLocation()
    }
    
    @IBAction func didTapTryAgain(_ sender: UIButton) {
        self.tryAgainButton.isHidden = true
        self.messageLabel.isHidden = true
        loadSpinner()
    }
}

extension LoadingViewController: WeatherViewModelDelegate {
    func didUpdateWeather(_ weatherViewModel: WeatherViewModel) {
        DispatchQueue.main.async {
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
    }
    
    func didFailWithError(_ weatherViewModel: WeatherViewModel, _ error: Error) {
        DispatchQueue.main.async {
            self.loadingSpinner.stopAnimating()
            self.tryAgainButton.isHidden = false
            self.messageLabel.isHidden = false
            self.messageLabel.text = self.weatherError
            print("loading weather returned an error: \(error)")
        }
    }
    
    func didUpdateModelImageDetails(_ weatherViewModel: WeatherViewModel, modelImageViewModel: ModelImageViewModel) {
        //
    }
}
