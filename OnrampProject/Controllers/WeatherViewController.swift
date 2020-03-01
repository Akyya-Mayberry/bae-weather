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
    
    private var weatherViewModel = WeatherViewModel()
    
    private var hourlyWeatherViewModel: HourlyWeatherViewModel? {
        didSet {
            DispatchQueue.main.async {
                let currentHour = self.hourlyWeatherViewModel!.getCurrentWeatherBlockUsing(date: self.weatherViewModel.date)
                self.hourBlockWeatherSlider.value = 1.0/Float(currentHour.hour.rawValue)
            }
        }
    }
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherViewModel.delegate = self
        updateWeather()
        
    }
    
    @IBAction func onTapRefreshImage(_ sender: UITapGestureRecognizer) {
        updateWeather()
    }
    
    @IBAction func didChangeWeatherBlock(_ sender: UISlider) {
        
        // TODO: Move this out of view controller
        
        let index = Int(round(sender.value *
            Float(WeatherBlockTime.allCases.count - 1)))
        print("Weather block time: \(WeatherBlockTime.allCases[index]))")
        
        let weatherBlock = hourlyWeatherViewModel?.getCurrentWeatherBlockUsing(hourBlock: WeatherBlockTime.allCases[index])
        
        DispatchQueue.main.async {
            self.currentWeatherLabel.text = "\(weatherBlock!.temperature)°"
            let modelImage = BaeImage(for: TypeOfWeather(for: weatherBlock!.temperature))
            self.modelImageView.image = UIImage(named: modelImage.getImage())
        }
    }
    
    private func updateWeather() {
        weatherViewModel.updateCurrentWeather(city: "Fresno", state: "California", country: "USA")
        updateUI()
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.currentWeatherLabel.text = "\(String(describing: self.weatherViewModel.currentTemp!))°"
            self.currentDateLabel.text = self.weatherViewModel.currentDateAsString
            self.lastTimeUpdatedLabel.text = self.weatherViewModel.lastUpdateTime
            self.modelImageView.image = UIImage(named: (self.weatherViewModel.baeImage?.getImage())!)
        }
    }
    
}

// MARK: - Extensions

extension WeatherViewController: WeatherViewModelDelegate {
    func didUpdateCurrentWeather(_ weatherViewModel: WeatherViewModel) {
        hourlyWeatherViewModel = HourlyWeatherViewModel(weatherViewModel.getHourlyTemps())
    }
}

