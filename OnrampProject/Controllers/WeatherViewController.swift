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
    
    private var weatherViewModel: WeatherViewModel!
    
    private var hourlyWeatherViewModel: HourlyWeatherViewModel!
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hourBlockWeatherSlider.maximumValue = Float(WeatherBlockTime.allCases.count) - 1
        hourBlockWeatherSlider.minimumValue = 0
        updateWeather()
        
    }
    
    @IBAction func onTapRefreshImage(_ sender: UITapGestureRecognizer) {
        updateWeather()
    }
    
    @IBAction func didChangeWeatherBlock(_ sender: UISlider) {
        let index = Int(sender.value)
        print("Slider new value: \(index)")
        
        // TODO: Hourly forecast currently not available, will have
        // to use seed data or hold off on this
        
        /*
         let weatherBlock = hourlyWeatherViewModel!.getCurrentWeatherBlockUsing(hourBlock: WeatherBlockTime.allCases[index])
         
         let weather = Weather(date: Date(), temperature: weatherBlock.temperature, hourlyTemps: weatherViewModel.getHourlyTemps(), city: "Fresno", state: "California", currentHourBlock: WeatherBlockTime.allCases[index])
         
         weatherViewModel = WeatherViewModel(city: "Fresno", state: "california")
         weatherViewModel.delegate = self
         */
    }
    
    private func updateWeather() {
        weatherViewModel = WeatherViewModel(city: "Fresno", state: "california")
        weatherViewModel.delegate = self
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            
            guard self.weatherViewModel.weather != nil else {
                return
            }
            
            self.currentWeatherLabel.text = "\(self.weatherViewModel.currentTemp!)°"
            self.currentDateLabel.text = self.weatherViewModel.currentDateAsString
            self.lastTimeUpdatedLabel.text = self.weatherViewModel.lastUpdateTime
            self.modelImageView.image = UIImage(named: (self.weatherViewModel.baeImage!.getImage()))
            
            // TODO: Hourly forecast currently not available, will have
            // to use seed data or hold off on this
            
            /*
             let currentHour = self.weatherViewModel.getCurrentWeatherBlock()
             self.hourBlockWeatherSlider.value = Float(self.hourlyWeatherViewModel.getIndex(for: currentHour))
             */
        }
    }
    
}

extension WeatherViewController: WeatherViewModelDelegate {
    func didUpdateWeather(_ weatherViewModel: WeatherViewModel) {
        updateUI()
    }
    
    func didFailWithError(_ weatherViewModel: WeatherViewModel, _ error: Error) {
        print("Error with viewModel: \(error)")
    }
    
    
}

