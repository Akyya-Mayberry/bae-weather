//
//  LoadingViewController.swift
//  OnrampProject
//
//  Created by hollywoodno on 3/11/20.
//

import UIKit

class LoadingViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var messageStackView: UIStackView!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tryAgainButton: UIButton! {
        didSet {
            tryAgainButton.layer.borderColor = #colorLiteral(red: 0.9108538948, green: 0.8431372549, blue: 0.5877637754, alpha: 1).cgColor
            tryAgainButton.layer.borderWidth = 1.7
            tryAgainButton.layer.cornerRadius = tryAgainButton.bounds.size.height / 2
        }
    }
    
    let networkService = WeatherNetworkService.sharedInstance
    let locationService = LocationService.sharedInstance
    let weatherViewModel = WeatherViewModel(weather: nil)
    let weatherError = "Error occurred fetching weather for your location."
    let locationError = "Error occurred getting your current location"
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationService.startUpdatingLocation()
        locationService.delegate = self
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
            loadingSpinner.stopAnimating()
            messageLabel.text = locationError
            messageStackView.isHidden = false
        }
        locationService.stopUpdatingLocation()
    }
    
    @IBAction func didTapTryAgain(_ sender: UIButton) {
        messageStackView.isHidden = true
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
            self.messageStackView.isHidden = false
            self.messageLabel.text = self.weatherError
            print("loading weather returned an error: \(error)")
        }
    }
     
    func didUpdateModelImageDetails(_ weatherViewModel: WeatherViewModel, modelImageViewModel: ModelImageViewModel) {
        //
    }
}

extension LoadingViewController: LocationServiceDelegate {
    func locationService(_ locationService: LocationService, didUpdateLocationAuthorization status: LocationStatusUpdate) {
        switch locationService.requestStatus {
        case .authorized:
            getCurrentLocation()
        case .denied:
            self.loadingSpinner.stopAnimating()
            showLinkToSettings()
        default:
            self.loadingSpinner.stopAnimating()
            locationService.requestLocation()
        }
    }
    
    func locationService(_ locationService: LocationService, didFailWith error: Error) {
        DispatchQueue.main.async {
            self.loadingSpinner.stopAnimating()
            self.messageStackView.isHidden = false
            self.messageLabel.text = self.locationError
            print("requesting current location returned an error: \(error)")
        }
    }
}
