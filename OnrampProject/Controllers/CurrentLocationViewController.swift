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
    
    @IBOutlet weak var requestLocationButton: UIButton! {
        didSet {
            let navImage = UIImage(named: "navigation-18dp-1")?.withRenderingMode(.alwaysTemplate)
            requestLocationButton.setImage(navImage, for: .normal)
            requestLocationButton.tintColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
            requestLocationButton.contentMode = .scaleAspectFit
            requestLocationButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/4))
        }
    }
    
    let locationService = LocationService()
    var delegate: CurrentLocationViewControllerDelegate?
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationService.delegate = self
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
    
    func showLinkToSettings() {
        print("In request vc Location is not granted, inform user it's needed")
        
        let locationNeededAlertController = UIAlertController (title: "Current Location Required", message: "To get current weather, access to your location is needed. Continue to settings to enable access.", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("User taken to settings: \(success)")
                })
            }
        }
        
        locationNeededAlertController.addAction(settingsAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        locationNeededAlertController.addAction(cancelAction)
        
        present(locationNeededAlertController, animated: true, completion: nil)
    }
}

// MARK: - Extensions

extension CurrentLocationViewController: LocationServiceDelegate {
    func locationService(_ locationService: LocationService, didUpdateLocationAuthorization status: LocationStatusUpdate) {
        switch status {
        case .authorized:
            print("In request vc current location is authorized, send to loading page")
            // animates gps icon
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                self.requestLocationButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/3))
            }, completion: nil)
            delegate?.didAuthorizeCurrentLocation(self)
        case .denied:
            print("Show screen to request access or ask view model to request access")
            showLinkToSettings()
        default:
            locationService.requestLocation()
        }
    }
    
    func locationService(_ locationService: LocationService, didFailWith error: Error) {
        print("In request vc location manager failed. Alert user of error. Error: \(error).")
    }
}

