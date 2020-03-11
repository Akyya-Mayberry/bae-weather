//
//  RequestLocationViewController.swift
//  OnrampProject
//
//  Created by hollywoodno on 3/9/20.
//

import UIKit

class RequestLocationViewController: UIViewController {
  
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
  
  @IBOutlet weak var heartImageView: UIImageView! {
    didSet {
      heartImageView.image = heartImageView.image?.withRenderingMode(.alwaysTemplate)
      heartImageView.tintColor = #colorLiteral(red: 0.8225541115, green: 0.2497350872, blue: 0.3470991254, alpha: 0.9402022688)
    }
  }
  
  @IBOutlet weak var weatherImageView: UIImageView! {
    didSet {
      weatherImageView.image = weatherImageView.image?.withRenderingMode(.alwaysTemplate)
      weatherImageView.tintColor = #colorLiteral(red: 0.5270639062, green: 0.628903687, blue: 0.5675569773, alpha: 0.9402022688)
    }
  }
  
  @IBAction func didTapRequestLocation(_ sender: Any) {
    performSegue(withIdentifier: "LoadingSegue", sender: self)
  }
  
  // MARK: - Methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // animates gps icon
    UIView.animate(withDuration: 1.5, delay: 2.0, options: .curveEaseIn, animations: {
      self.requestLocationButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/3))
    }, completion: nil)
  }
}
