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
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onTapRefreshImage(_ sender: UITapGestureRecognizer) {
        
        print("Should fetch current weather")
    }
    
    @IBAction func didChangeWeatherBlock(_ sender: UISlider) {
        print("Weather block time changed: \(sender.value)")
    }
    

}

