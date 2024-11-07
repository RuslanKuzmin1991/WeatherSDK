# WeatherSDK for iOS

## Overview

The WeatherSDK provides a simple way to integrate weather data and forecast views into your iOS application. It supports both UIKit and SwiftUI, offering seamless integration for either framework.

The SDK includes the ability to present a weather view for a given city using either a UIViewController (for UIKit) or a SwiftUI View. Additionally, the SDK supports delegation to allow custom handling of completion events or errors.

## Features
•    Display current weather and forecasts in your app.
•    Compatible with both UIKit and SwiftUI.
•    Provides customizable delegate callbacks for successful or erroneous operations.

## Installation

### Using Swift Package Manager (SPM)

To integrate WeatherSDK into your project using Swift Package Manager:

    1.    In Xcode, open your project settings.
    2.    Select the Swift Packages tab.
    3.    Click the + button to add a package dependency.
    4.    Enter the repository URL for WeatherSDK (https://github.com/ruslan.kuzmin/WeatherSDK)
    5.    Choose the version rules (e.g., “Up to Next Major Version”) and click Add Package.

After this, WeatherSDK will be integrated into your project, and you can start using it.

**Note: SPM Integration**
WeatherSDK is not published on a GitHub. Integration via SPM is written for demonstration purpose

### Manual Installation

1.    Download the WeatherSDK repository or get the source files.
2.    Drag the WeatherSDK.swift and any required resources into your Xcode project.
3.    Ensure that you have imported the necessary frameworks: UIKit, SwiftUI, and Foundation.

## Integration

### Initialization

To use the SDK, you need to initialize to call presentWeatherViewController or presentWeatherView with your API Key and optionally set a delegate to handle events such as completion or errors.

Example:

import WeatherSDK

class MyViewController: UIViewController, WeatherSDKDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // Implement the delegate methods
    func onFinished() {
        print("Weather data loaded successfully.")
    }
    
    func onFinishedWithError(error: Error) {
        print("Failed to load weather data: \(error.localizedDescription)")
    }
}

### Display Weather View

You can display weather data either as a UIViewController (for UIKit) or as a SwiftUI View.

a. Presenting a UIViewController (UIKit):

The presentWeatherViewController(forCity: withApiKey: andDelegate:) method returns a UIViewController that can be presented or pushed onto a navigation stack.

let weatherVC = presentWeatherViewController(forCity: "Munich",
                               withApiKey: "your-api-key",
                               andDelegate: WeatherDelegate()))
self.present(weatherVC, animated: true, completion: nil)

Alternatively, if using a UINavigationController:

let weatherVC = presentWeatherViewController(forCity: "Munich",
                                            withApiKey: "your-api-key",
                                            andDelegate: WeatherDelegate()))
self.navigationController?.pushViewController(weatherVC, animated: true)

b. Embedding a SwiftUI View:

If you are using SwiftUI, you can present the weather view using presentWeatherView(forCity: withApiKey: andDelegate:), which returns a some View.

import SwiftUI
import WeatherSDK

struct ContentView: View {
    var body: some View {
        NavigationView {
            presentWeatherView(forCity: "Munich",
                               withApiKey: "your-api-key",
                               andDelegate: WeatherDelegate())
            .navigationTitle("Weather in Munich")
        }
    }
}

class MyWeatherDelegate: WeatherSDKDelegate {
    func onFinished() {
        print("Weather loaded successfully.")
    }

    func onFinishedWithError(error: Error) {
        print("Error loading weather: \(error.localizedDescription)")
    }
}

### Delegate Protocol

To handle SDK events, you can set a delegate that conforms to the WeatherSDKDelegate protocol. The delegate has two methods:

public protocol WeatherSDKDelegate {
    /// Called when the weather data has been successfully loaded.
    func onFinished()
    
    /// Called when there was an error loading the weather data.
    func onFinishedWithError(error: Error)
}

Example:

extension MyViewController: WeatherSDKDelegate {
    func onFinished() {
        // Handle successful completion
        print("Weather data loaded successfully.")
    }
    
    func onFinishedWithError(error: Error) {
        // Handle error case
        print("Error: \(error.localizedDescription)")
    }
}

## Example Usage

### UIKit Integration Example:

class WeatherViewController: UIViewController, WeatherSDKDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        let weatherVC = presentWeatherViewController(forCity: "Berlin",
                                                     withApiKey: "your-api-key",
                                                     andDelegate: WeatherDelegate())
        self.present(weatherVC, animated: true, completion: nil)
    }

    func onFinished() {
        print("Weather loaded successfully")
    }

    func onFinishedWithError(error: Error) {
        print("Error loading weather: \(error.localizedDescription)")
    }
}

### SwiftUI Integration Example:

struct WeatherScreen: View {
    var body: some View {
        NavigationView {
            presentWeatherView(forCity: "Paris",
            withApiKey: "your-api-key",
            andDelegate: WeatherDelegate())
                .navigationTitle("Weather in Paris")
        }
    }
}

class WeatherDelegate: WeatherSDKDelegate {
    func onFinished() {
        print("Weather loaded successfully.")
    }

    func onFinishedWithError(error: Error) {
        print("Error loading weather: \(error.localizedDescription)")
    }
}   

## Requirements

- iOS 16+
- Xcode 16+

## Author

Ruslan Kuzmin, ruslan.kuzmin.1991@gmail.com

## License

Here should somethig about the license.

## Conclusion

WeatherSDK is a simple and flexible tool for integrating weather views into your iOS app using both UIKit and SwiftUI. With easy setup and delegate-based event handling, you can quickly display weather data in any view of your application.

If you encounter any issues, please refer to the Delegate Protocol section for error handling or adjust the API key and city name used in the provided examples.

For further questions or feedback, feel free to reach out to the SDK development team.
