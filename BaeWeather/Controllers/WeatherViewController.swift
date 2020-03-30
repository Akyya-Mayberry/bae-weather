//
//  ViewController.swift
//  OnrampProject
//
//  Created by Giovanni Noa on 2/20/20.
//

import UIKit

class WeatherViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var currentWeatherLabel: UILabel!
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var lastTimeUpdatedLabel: UILabel!
    @IBOutlet weak var hourBlockWeatherSlider: UISlider!
    @IBOutlet weak var modelImageView: UIImageView!
    @IBOutlet weak var modelNameLabel: UILabel!
    @IBOutlet weak var weatherInfoView: UIView!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var refreshWeatherImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var errorMessageView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    private let weatherError = "Error occurred getting weather update."
    private var hourlyWeatherViewModel: HourlyWeatherViewModel!
    var weatherViewModel: WeatherViewModel!
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onUpdateModelName(_:)), name: .didSetModelName, object: nil)
        //    hourBlockWeatherSlider.maximumValue = Float(WeatherBlockTime.allCases.count) - 1
        //    hourBlockWeatherSlider.minimumValue = 0
        
        //    updateWeather()
        updateUI()
    }
    
    @IBAction func onTapRefreshImage(_ sender: UITapGestureRecognizer) {
        refreshWeatherImageView.tintColor = #colorLiteral(red: 0.8225541115, green: 0.2497350872, blue: 0.3470991254, alpha: 0.9402022688) // must set - it's turns white when touched
        refreshWeatherImageView.isHidden = true
        loadingSpinner.isHidden = false
        updateWeather()
    }
    
    @IBAction func didChangeWeatherBlock(_ sender: UISlider) {
        let index = Int(sender.value)
        print("Slider new value: \(index)")
        
        // TODO: Hourly forecast currently not available, will have
        // to use seed data or hold off on this
    }
    
    private func updateWeather() {
        switch weatherViewModel.getLocationAuthorizationStatus() {
        case .authorized:
            weatherViewModel.getCurrentWeather()
        case .denied:
            self.refreshWeatherImageView.isHidden = false
            self.loadingSpinner.isHidden = true
            self.showLinkToSettings()
        default:
            self.refreshWeatherImageView.isHidden = false
            self.loadingSpinner.isHidden = true
        }
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            
            guard self.weatherViewModel != nil, self.weatherViewModel.weather != nil else {
                return
            }
            
            self.currentWeatherLabel.text = "\(self.weatherViewModel.currentTemp!)°"
            self.currentDateLabel.text = self.weatherViewModel.currentDateAsString
            self.lastTimeUpdatedLabel.text = self.weatherViewModel.lastUpdateTime
            self.modelImageView.image = UIImage(named: self.weatherViewModel.modelImageDetails!.imageName)
            self.modelNameLabel.text = "\(ModelImageViewModel.getModelName()) Weather"
            self.locationLabel.text = self.weatherViewModel.location
            
            self.refreshWeatherImageView.isHidden = false
            self.loadingSpinner.isHidden = true
            self.refreshWeatherImageView.isHidden = false
            self.errorMessageView.isHidden = true
        }
    }
    
    @objc func onUpdateModelName(_ notification: Notification) {
        if let modelInfo = notification.userInfo as? [String: String] {
            if let modelName = modelInfo["name"] {
                DispatchQueue.main.async {
                    self.modelNameLabel.text = "\(modelName) Weather"
                }
            }
        }
    }
}

extension WeatherViewController: WeatherViewModelDelegate {
    func didUpdateModelImageDetails(_ weatherViewModel: WeatherViewModel, modelImageViewModel: ModelImageViewModel) {
        //
    }
    
    func didUpdateWeather(_ weatherViewModel: WeatherViewModel) {
        print("Weather view model gave view controller the delegate a weather update")
        updateUI()
    }
    
    func didFailWithError(_ weatherViewModel: WeatherViewModel, _ error: Error) {
        DispatchQueue.main.async {
            self.loadingSpinner.isHidden = true
            self.refreshWeatherImageView.isHidden = false
            self.errorMessageView.isHidden = false
            self.errorLabel.text = self.weatherError
            print("Error with viewModel fetching weather: \(error)")
        }
    }
}

/*
 Allows refresh imageView UI to act like a button, by highlighting/changing tint color when touched
 **/
extension WeatherViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        
        if touch.view == refreshWeatherImageView {
            refreshWeatherImageView.tintColor = .white
        }
    }
}
