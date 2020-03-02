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
    
    private var weatherViewModel: WeatherViewModel! {
        didSet {
            hourlyWeatherViewModel = HourlyWeatherViewModel(weatherViewModel.getHourlyTemps(), currentDate: weatherViewModel.weather.date)
        }
    }
    
    private var hourlyWeatherViewModel: HourlyWeatherViewModel! {
        didSet {
            updateUI()
        }
    }
    
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
        
        let weatherBlock = hourlyWeatherViewModel!.getCurrentWeatherBlockUsing(hourBlock: WeatherBlockTime.allCases[index])
        
        let weather = Weather(date: Date(), temperature: weatherBlock.temperature, hourlyTemps: weatherViewModel.getHourlyTemps(), city: "Fresno", state: "California", country: "USA", currentHourBlock: WeatherBlockTime.allCases[index])
        
        weatherViewModel = WeatherViewModel(weather: weather)
        
    }
    
    private func updateWeather() {
        weatherViewModel = WeatherViewModel(weather: WeatherViewModel.getNextWeather())
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.currentWeatherLabel.text = "\(self.weatherViewModel.currentTemp)°"
            self.currentDateLabel.text = self.weatherViewModel.currentDateAsString
            self.lastTimeUpdatedLabel.text = self.weatherViewModel.lastUpdateTime
            self.modelImageView.image = UIImage(named: (self.weatherViewModel.baeImage.getImage()))
            
            let currentHour = self.weatherViewModel.getCurrentWeatherBlock()
            
            self.hourBlockWeatherSlider.value = Float(self.hourlyWeatherViewModel.getIndex(for: currentHour))
        }
    }
    
}

