# Bae Weather

Bae Weather is a personizable web app. Users are provided with the current weather in degrees, only significant hourly forecasts (rush hour e.x.) and a convient categorized weather (freezing, cold, warm, hot) modeled by a customizable weathercaster (bae, kiddos etc).

![Bae Weather Demo](bae-weather-demo1.gif)

# Implemented Features

  - Current weather for current location
  - Default weathercaster
  - Default weathercaster name (Bae)
  - Customizable weathercaster name
  - Upload custom weathercaster photos
  - Hourly Weather - to come
  - Take image for custom weathercaster photos
  - View/adjust temperature ranges for weather categories

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

Current Location Request: When first launching the application, you are requested to grant the app access to your current location in order to display weather for your location. If you deny access, before proceeding to use the app, you will be require to grant the app location access in your phones settings. Once location access is granted, you will be sent to the weather homepage. 

Weather Homepage: Once location access is granted for the first time and on each subsequent app launch, you are sent to the weather homepage. The first time you launch the app, the current weather is fetched and displayed for you along with the default webcaster name "Bae", the current date and time the weather was fetched, and the default webcasters images associated with the current weather cateogry. If you have used the app to fetch current weather before, then your homepage will display the date and time of the last fetched weather. To update the weather, you must click the refresh button. If location access is not granted, you will first be required to authorized your current location before the weather is able to update. 

Settings: Settings view is primarily to configure the webcaster. You are able to view and change the weathercaster name. To change the name, click on the pencil icon and ensure that "Use Default" switch is turned off. If the "Use Default" switch is on, your webcaster will have the default name of "Bae" and the field to change the name will be disabled. In this view, you are also able to view the model image associated with each weather cateogry by either selecting anl image from the collection of thumbnails or by swiping along the image the larger image preview area. You can use the default image or select your own image for each weather category. To select your own image either 1. click to edit the model images and turn the switch off to use all the default images, or 2. click on a image in the preview area to display it's details. In the details view, turn off the switch to use the default image. Then use the edit button to select your own image from your image library.

Weather Category Image Details: Clicking on an image in the preview area displays the image details and the ability to select a custom image from your photos library. However the ability to save the image is not implemented yet.

##### Project Structure
- Services:
    - Network Service - Open Weather API for getting current weather
    - UserDefaults Service - Aim to be a wrapper around user defaults. Some quering and peristence will still require regular usage of UserDefaults.
    - Location Service - Provides current location data for device
    - File Service - Persist user custom weathercaster model photos to documents directory
- UIViewControllers: 
    - WeatherViewController: Displays current weather, date, last time weather was updated, webcaster image for current weather 
    - SettingsViewController: Configurations related to webcaster/model such as name and photos for each weather category
    - ModelImageViewDetailsViewController: Allows editing of a webcaster image for a given category
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
- MVVM: Based on the project structure above, MVVM is the design pattern implemented. Services handle working with API clients, local data storage and location manager. Only view models interact with the services to manipulate the data objects and pass information to and from the view controllers. The view controllers manages the views. The view controllers are slimmer, but there is still room for refactoring especially around moving extensions.

##### Data Persistence and State
- UserDefaults: The current weather and model name is stored user defaults as well as user defined settings. Giving the simplicity of data that needed to be peristed and that the data is local (ex. just settings and no user account management), user defaults was the peristence store of choice. 

- File System: The default images for each weather category and/or the custom image user selects is stored locally in the users documents directory. 

- NSNotification: For this app thus far, there was one property that I needed to be "global", the model's name. The state of this property needed to be known in the Weather view, because the models name is displayed. First attempt at this was done using delegation, and second attempt using key value observation. But with using delegation and kvo updates were not provided in the weather view if it wasn't the current displayed view. Realm would of been greate for passing updates to the weather view, but NSNotification was far easier to implement and did the job well.

- Delegatation: Delegation was used throughout the app and was the choice for handling asynchronous network calls, and updates between view model and view controllers. 
 

