//
//  SceneDelegate.swift
//  OnrampProject
//
//  Created by Giovanni Noa on 2/20/20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    
    guard let _ = (scene as? UIWindowScene) else { return }
    
//    loadTabBarController()
  }
  
  func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
  }
  
  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
  }
  
  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
  }
  
  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
  }
}

extension SceneDelegate {
  
  func loadTabBarController() {
    
    // load weather view controller with last known weather
    
    let userDefaultsService = UserDefaultsService()
    let lastKnownWeather = userDefaultsService.getFromUserDefaults(item: Constants.userDefaultKeys.lastKnownWeather) as? Weather
    
    // Send to homepage if there's previous weather
    if lastKnownWeather != nil {
      let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
      
      let weatherVC = storyboard.instantiateViewController(identifier: String(describing: WeatherViewController.self)) as! WeatherViewController
      weatherVC.weatherViewModel = WeatherViewModel(weather: lastKnownWeather)
      weatherVC.weatherViewModel.delegate = weatherVC.self
      
      let settingsVC = storyboard.instantiateViewController(identifier: String(describing: SettingsViewController.self)) as! SettingsViewController
      
      
      let tabBarController = UITabBarController()
      tabBarController.viewControllers = [weatherVC, settingsVC]
      
      self.window?.rootViewController = tabBarController
    }
  }
}

