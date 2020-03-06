# Onramp iOS Take-Home Project 

## Overview 🍎

Congratulations for making it this far in the interview process for the Pandora Demo Tape Apprenticeship at Onramp!

This project seeks to better inform the Onramp team of your experience with Swift programming and iOS development as well as prepare you for your interview at Pandora.

You will have seven days to complete this project. We expect those who have a moderate level of iOS development experience to spend between 24 and 32 hours to design, implement, document, and submit the project to us. Depending on your level, it may take more or less time, so please plan accordingly.

**The project is due on Friday, March 6 at 9:00am PST/12:00pm EST.**

### Project Summary:
* Total time available to complete: 7 days
* Due date/time: Friday, March 6 at 9:00am PST/12:00pm EST
* Expected development time to complete: 24 - 32 hours 
* Required stack/tools: a Mac computer using Swift and Xcode

## App Requirements and Details 🔎

For this project, we want you to build an iOS application that is one of the following: 
* A newsfeed app
* A weather app
* A photo gallery
* An audio/video playback app

Consider which of these projects you’d be most excited to work on, **not** what you think your interviewers or Onramp would like to see. 

**Scope your features and functionality to what you can reasonably accomplish by the due date. Your application must include the following architectural requirements:** 

* Use of at least 3 [UIViewControllers](https://developer.apple.com/documentation/uikit/uiviewcontroller).
* Use of at least one [UIView](https://developer.apple.com/documentation/uikit/uiview). You can subclass UIView and add subviews to that class.
* The usage of the [MVVM](https://www.raywenderlich.com/34-design-patterns-by-tutorials-mvvm) architectural pattern.
* Use of a [REST API](https://medium.com/@arteko/the-best-way-to-use-rest-apis-in-swift-95e10696c980). We suggest using [Codable](https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types) for handling JSON.
* Usage of at least 5 UIView/UIControl subclasses (UITableViews, UISegmentedControl, etc).
* The usage of data persistence - UserDefaults, NSKeyedArchiver, or what makes most sense to you. 

##### NOTE: you will need to detail where and how your iOS App meets these requirements in your repository's README file when you submit your project.


### A Note on Researching and Plagiarism

You are actively encouraged to research the web, books, videos, or tutorials for this project. That said, we expect all code that is submitted to be your own (e.g. this project should NOT be completed with another person). That means that we expect each candidate to refrain from copying and/or pasting code into the project. If we find copied code in your project, we will have to disqualify you. Web and video resources are available at the end of this document.

## What we're looking for 🚀

We will evaluate your project by assessing the overall strength and quality of the following five factors:

### UI Design

iOS users expect your application to look and behave in a way that's consistently intuitive. Your iOS application should adhere to [Apple’s Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/ios/overview/themes/) (HIG). Be thoughtful of the UI elements you use, and refer to the HIG for examples of best practices. 

### Architecture Pattern 

An architecture pattern enables you to define a guide for how a piece of software should function, such that it can be scalable, maintainable, and testable. Common patterns for iOS applications include [MVC](https://www.raywenderlich.com/1000705-model-view-controller-mvc-in-ios-a-modern-approach) (Model-View-Controller), Viper, and [MVVM](https://www.raywenderlich.com/34-design-patterns-by-tutorials-mvvm) (Model-View-ViewModel). Keep in mind the concept of Separation of Concerns (youtube video discussing that here). **Note that it is required that you leverage the MVVM pattern within your iOS app.**

### Core iOS Components

Make sure to use version control with your app using a Github repository. 
A large part of iOS development consists of consuming JSON data to display on the screen. Leverage an API of your choice to fetch data for use within your app. Make sure to meet all app requirements, as laid out above. You can choose your preference of either Storyboard/Interface Builder or programmatic UI.

### iOS Development Best Practices

It's important to subscribe to a set of best practices when designing and implementing an iOS app. Be mindful of these widely accepted principles:

* [DRY](https://code.tutsplus.com/tutorials/3-key-software-principles-you-must-understand--net-25161) (don't repeat yourself). Also view this [Wikipedia Article](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself).
* Maintain a [separation of concerns](https://youtu.be/hIaPdjS5GNo?t=163) within your iOS components. Adhering to MVVM should naturally separate the various components of your app.
* Specify good [project structure](https://www.swiftbysundell.com/articles/structuring-swift-code/).
* Using these principles will result in a high quality user experience while efficiently utilizing phone hardware resources and ensuring other developers can easily navigate through your code.

### Application Description

Each project submission must include a README file providing an overview of the iOS application and details the app's overall MVVM architecture as well as your design decisions. Screenshots of the iOS app taken from the Xcode simulator or your testing device are also required. This task assesses the critical competency of communicating and documenting technical concepts. See details in the submission information section below.

# What we are NOT Evaluating ❌

## Testing

Testing frameworks and strategies are intentionally NOT assessed because we want you to dedicate your time to building a functional application. We do realize that UI and iOS component testing are critical practices of iOS Development, but this project prioritizes a focus on surfacing Swift/iOS development proficiency.

## Feature Depth

You won’t be earning extra points for having a bunch of features. Focus on creating a clean, simple application that addresses all of the requirements and is documented properly for submission.

# Submission Information 🎇

This repository will be your starting point. Please download (not clone or fork) this Github repository and upload changes to a newly created **public** repository. Once the iOS application has been completed, you'll be submitting a link to the new repository you created. Prior to submitting your project, you should update the README file to provide the following information:

* A description of the overall iOS application
* A high level architectural overview of your iOS application. e.g. names, relationships and purposes of all UIViewControllers and UIViews
* Explanations for and descriptions of the design patterns you leveraged
* [Screenshots](https://stackoverflow.com/questions/7092613/take-screenshots-in-the-ios-simulator) of each View and descriptions of the overall user flow

## Submission Deadline + Process

You must submit your project by **9:00am PST/12:00pm EST on Friday, March 6** using this [form](https://docs.google.com/forms/d/e/1FAIpQLSfVu3xnF7UsgZIItpW36ggH9ASrhfozUl3Jo2lwse3tP4bAxg/viewform). 

Once you’ve submitted your project, you are expected to stop working on it. Any commits that occur after submission or the deadline will not be reviewed. 

## Additional Resources
* MVVM [Swift: How to Migrate MVC to MVVM](https://www.youtube.com/watch?v=n06RE9A_8Ks), [Different Flavors of view models in Swift by Sundell](https://www.swiftbysundell.com/articles/different-flavors-of-view-models-in-swift/), [AppCoda: Introduction to MVVM](https://www.appcoda.com/mvvm-vs-mvc/), [objc.io: Introduction to MVVM](https://www.appcoda.com/mvvm-vs-mvc/)
* [Swift Language Guide](https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html)
* [Exhaustive list of iOS Good Practices](https://github.com/futurice/ios-good-practices) 
* [Hacking With Swift blog](https://www.hackingwithswift.com/)
* [Ray Wenderlich blog](https://www.raywenderlich.com/)
* [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/ios/overview/themes/)
* [Separation of Concerns](https://www.youtube.com/watch?v=VtF6aebWe58&feature=youtu.be)
* [SwiftLee blog](https://www.avanderlee.com/)
* [Data Persistence](https://developer.apple.com/library/archive/referencelibrary/GettingStarted/DevelopiOSAppsSwift/PersistData.html)
* [Apple Developer App](https://apps.apple.com/us/app/apple-developer/id640199958)
* [WWDC Videos](https://developer.apple.com/videos/)


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

 

