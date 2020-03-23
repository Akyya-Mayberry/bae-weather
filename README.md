# Bae Weather

Bae Weather is a slimmed down weather app aim to be simplistic and cute (hence bae). Users are provided with the current weather in degrees, only significant hourly forecasts (rush hour e.x.) and a convient categorized weather (freezing, cold, warm, hot) modeled by a customizable weathercaster (bae, kiddos etc).

# Implemented Features

  - Current weather (persisted)
  - Default weathercaster (persisted)
  - Default weathercaster name (Bae) (persisted)
  - Customizable weathercaster name (persisted)
  - Upload custom weathercaster photos (not persisted)

### Tech

* [https://openweathermap.org/] - OpenWeather API: for current weather data
* [https://cocoapods.org/] - Cocoapods Alamofire: for network requests
* [https://icons8.com/] - Icons8: for icons
* [https://pixabay.com/] - Pixabay: source of default model photos
* [https://swift.org/] - Swift 5
* [https://developer.apple.com/xcode/] - XCode 11.13.1

### Installation

For best development experience it is recommended to use the following

  - XCode 11.13.1 - Swift 5
  - Cocoapods 1.8.4
 
Steps
1. Clone the repository
2. change into the root of the project directory and install the cocoapods. For information on how to get up and running with cocoapods * [https://cocoapods.org/]
3. Once cocoapad installation completes, proceed by opening the OnrampProject.xcworkspace file at the root of the project structure. It is very important to use this file and not the regular OnrampProject.xcodeproj file. 
4. Build and run the app.

### How to use the app

Currently all features of the app are not implemented.

Homepage: When launching the application, you are sent to the weather homepage. The current weather is fetched and displayed along with the webcasters image associated with the weather cateogry. Currently the current location is hardcoded for "Fresno, California". To change this, you must update the default values for city state in the Contants.swift file. The current date and the last time the current weather was updated is also display. Please be aware that the weather may take a couple of minutes to update (you may see a placeholder for weather). This issue will be fix and future updates

Settings: Settings view is primarily for webcaster configuration. You are able to view and change the weathercaster name. You are able to view each model image associated with a weather cateogry by swiping the preview area or selecting a model image from the thumbnails.

Weathercaster Image Details: Clicking on an image in the preview area if of the settings view presents a detailed view of the image. The details view allows selecting a new photo from the library however uploaded photos are not yet perisisted.

### Implementation of Project Reqs

##### Project Structure
- Services:
    - Network Service - Open Weather API for getting current weather
    - UserDefaults Service - Aim to be a wrapper around user defaults. Some quering and peristence will still require regular usage of UserDefaults.
- UIViewControllers: 
    - WeatherViewController: Displays current weather, date, last time weather was updated, webcaster image for current weather and hourly forecast (not implemented)
    - SettingsViewController: Configurations related to webcaster/model such as name and photos for each weather category
    - ModelImageViewDetailsViewController: Allows editing of a webcaster image for a given category (not persisted)
- UIViews: 
    - ModelImageView: Custom UIView for displaying webcaster photos as thumbnails and previes
    - WeatherCategoryView: Reusuable weathery category icon and the weather category it represents
- ViewModels:
    - WeatherViewModel: Manages fetching, updating and providing current weather details
    - ModelImageViewModel: Manages webcaster/model configurations
    - HoulyWeatherViewModel: Manges hourly update section of weather view controller, but is not implemented due to cost of obtaining hourly forecast
- Models:
    - Weather: Weather object that includes basic weather details
    - Settings: Configuration settings used primarily in settings view controller
    - BaeImage: Maps an image string respresenting a weather category to a weather category
- Cocoapods:
    - Alamofire: A network pod that is a wrapper around iOS url session
- Constants:
    - Holds app configuration data such as api base url, keys used in user defaults and default weathercaster data

##### Design Patterns
- MVVM: Based on the project structure above, MVVM is the design pattern implemented. A lot of typical UIViewController work in MVC such as managing weather models and weathercaster objects and state has been moved to view models. Interacting with the network service is also extracted away from the UIViewControllers and handled in view models. Since I hadn't coded very many projects in MVVM, it took some getting use to. It did leave my view controllers slimmer, but then I had so many extensions for delgation methods that some of my view controller files still have lots of code. I've seen some datasource get extracted out of the view controller and that's definetly a convention I want to try out. 

##### Data Persistence and State
- UserDefaults: Most data that is being stored is the app is stored in user defaults. Giving the simplicity of data that needed to be peristed (ex. just settings and no user account management), user defaults was the peristence store of choice. Realm was considered because of how easy it is to model updates throughout the app, but it was not needed.

- NSNotification: For this app thus far, there was one property that I needed to be "global", the model's name. The state of this property needed to be known in the Weather view, because the models name is displayed. First attempt at this was done using delegation, and second attempt using key value observation. But with using delegation and kvo updates were not provided in the weather view if it wasn't the current displayed view. Realm would of been greate for passing updates to the weather view, but NSNotification was far easier to implement and did the job well.

- Delegatation: Delegation was used throughout the app and was the choice for handling asynchronous network calls. Due to the ease of using delegation, it was often the first sought after solution for event management.

##### iOS Controls
- Slider: Though the backend not fully implented, the UI uses a slider to allow selection of a weather hour within a restricted range

- CollectionView: Use in SettingsViewController to manage the previewing of model image Sets. Currently only one set of images exist (1 per for categories of weather). As features roll out, there can be multiple image sets user defined and application default.

- Custom UIViews: Used for reusble custom components such as model image thumbnails and previews

- StackViews: Used in combination with autolayout for laying out interface

- Switches: Used to manage toggling of default settings of app

##### Upcoming
1. Refactor datasource and delegation code, extract it out of view controllers
2. Use users current location, by implementing location manager
3. Make interface better (fonts, colors, animations etc)
4. Implement persisting user photo uploads and multiple image sets
5. Seek out any free options for hourly weather updates to fully implement hour-based weather update
6. Handle network errors on backend and in UI. 

 

