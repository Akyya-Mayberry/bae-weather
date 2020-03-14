//
//  RequestLocationViewController.swift
//  OnrampProject
//
//  Created by hollywoodno on 3/9/20.
//

import UIKit

class RequestViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var containerView: UIView!
    
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
    
    private var containerChildViewControllers: [UIViewController] = []
    
    var activeChildViewController: UIViewController! {
        didSet {
            if oldValue != nil {
                removeChildViewController(oldValue)
            }
            setChildViewController()
        }
    }
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instantiateChildViewControllers()
        activeChildViewController = containerChildViewControllers.first
    }
    
    func instantiateChildViewControllers() {
        if let currentLocationViewController = storyboard?.instantiateViewController(identifier: String(describing: CurrentLocationViewController.self)) as? CurrentLocationViewController {
            containerChildViewControllers.append(currentLocationViewController)
        }
        
        if let loadingViewController = storyboard?.instantiateViewController(identifier: String(describing: LoadingViewController.self)) as? LoadingViewController {
            containerChildViewControllers.append(loadingViewController)
        }
    }
    
    func setChildViewController() {
        addChild(activeChildViewController)
        containerView.addSubview(activeChildViewController.view)
        
        // needed to keep childview within continer view since constraints are defined using autolayout
        activeChildViewController.view.frame = containerView.bounds
        
        activeChildViewController.didMove(toParent: self)
    }
    
    func removeChildViewController(_ childViewController: UIViewController) {
        childViewController.willMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParent()
    }
}


