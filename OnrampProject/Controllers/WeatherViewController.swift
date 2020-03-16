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
  
  var weatherViewModel: WeatherViewModel!
  private var hourlyWeatherViewModel: HourlyWeatherViewModel!
  private let locationService = LocationService()
  
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
    if locationService.requestStatus == .authorized {
      weatherViewModel.getCurrentWeather()
    } else {
      self.refreshWeatherImageView.isHidden = false
      self.loadingSpinner.isHidden = true
      showLinkToSettings()
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
      self.modelNameLabel.text = ModelImageViewModel.getModelName()!
      self.locationLabel.text = self.weatherViewModel.location
      
      self.refreshWeatherImageView.isHidden = false
      self.loadingSpinner.isHidden = true
    }
  }
  
  @objc func onUpdateModelName(_ notification: Notification) {
    if let modelInfo = notification.userInfo as? [String: String] {
      if let modelName = modelInfo["name"] {
        DispatchQueue.main.async {
          self.modelNameLabel.text = modelName
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
    print("Error with viewModel: \(error)")
  }
}
