//
//  CurrentLocationViewController.swift
//  OnrampProject
//
//  Created by hollywoodno on 3/13/20.
//

import UIKit

protocol CurrentLocationViewControllerDelegate {
    func didAuthorizeCurrentLocation(_ currentLocationViewController: CurrentLocationViewController)
}

class CurrentLocationViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var messageStackView: UIStackView!
    @IBOutlet weak var requestWeatherStackView: UIStackView!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var requestLocationButton: UIButton! {
        didSet {
            let navImage = UIImage(named: "navigation-18dp-1")?.withRenderingMode(.alwaysTemplate)
            requestLocationButton.setImage(navImage, for: .normal)
            requestLocationButton.tintColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
            requestLocationButton.contentMode = .scaleAspectFit
            requestLocationButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/4))
        }
    }
    
    @IBOutlet weak var tryAgainButton: UIButton! {
        didSet {
            tryAgainButton.layer.borderColor = #colorLiteral(red: 0.9108538948, green: 0.8431372549, blue: 0.5877637754, alpha: 1).cgColor
            tryAgainButton.layer.borderWidth = 1.7
            tryAgainButton.layer.cornerRadius = tryAgainButton.bounds.size.height / 2
        }
    }
    
    let locationService = LocationService.sharedInstance
    let locationError = "Error occurred getting your current location"
    var delegate: CurrentLocationViewControllerDelegate?
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationService.delegate = self
        requestWeatherStackView.isHidden = false
        messageStackView.isHidden = true
    }
    
    @IBAction func didTapRequestLocation(_ sender: Any) {
        switch locationService.requestStatus {
        case .authorized:
            // animates gps icon
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                self.requestLocationButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/3))
            }, completion: nil)
            delegate?.didAuthorizeCurrentLocation(self)
        case .denied:
            showLinkToSettings()
        default:
            locationService.requestLocation()
        }
    }
    
    @IBAction func didTapTryAgain(_ sender: UIButton) {
        self.requestWeatherStackView.isHidden = false
        self.messageStackView.isHidden = true
    }
}

// MARK: - Extensions

extension CurrentLocationViewController: LocationServiceDelegate {
    func locationService(_ locationService: LocationService, didUpdateLocationAuthorization status: LocationStatusUpdate) {
        switch status {
        case .authorized:
            // animates gps icon
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                self.requestLocationButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/3))
            }, completion: nil)
            delegate?.didAuthorizeCurrentLocation(self)
        case .denied:
            showLinkToSettings()
        default:
            locationService.requestLocation()
        }
    }
    
    func locationService(_ locationService: LocationService, didFailWith error: Error) {
        DispatchQueue.main.async {
            self.messageLabel.text = self.locationError
            self.requestWeatherStackView.isHidden = true
            self.messageStackView.isHidden = false
        }
    }
}

extension UIViewController {
    func showLinkToSettings() {
        let locationNeededAlertController = UIAlertController (title: "Current Location Required", message: "To get current weather, access to your location is needed. Continue to settings to enable access.", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
        }
        
        locationNeededAlertController.addAction(settingsAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        locationNeededAlertController.addAction(cancelAction)
        
        present(locationNeededAlertController, animated: true, completion: nil)
    }
}

