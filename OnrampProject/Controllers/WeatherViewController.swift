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
    
    private var weatherViewModel = WeatherViewModel()
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateWeather()
        
    }
    
    @IBAction func onTapRefreshImage(_ sender: UITapGestureRecognizer) {
        updateWeather()
    }
    
    @IBAction func didChangeWeatherBlock(_ sender: UISlider) {
        print("Weather block time changed: \(sender.value)")
    }
    
    private func updateWeather() {
        weatherViewModel.updateCurrentWeather(city: "Fresno", state: "California", country: "USA")
        updateUI()
    }
    
    private func updateUI() {
        currentWeatherLabel.text = "\(String(describing: weatherViewModel.currentTemp!))°"
        currentDateLabel.text = weatherViewModel.currentDate
        lastTimeUpdatedLabel.text = weatherViewModel.lastUpdateTime
    }

}

