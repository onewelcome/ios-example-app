# iOS Example App

The iOS Example App is using the Onegini iOS SDK to perform secure authentication and resource calls. Please have a look at the 
[App developer quickstart](https://docs.onegini.com/app-developer-quickstart.html) if you want more information about how to get setup with this 
example app.

## Installation

### Downloading the Onegini iOS SDK
1. Go to https://repo.onegini.com
2. Login using your credentials (provided to you by Onegini support via `support@onegini.com`). If you don't have these, no problem just go to the 
[App developer quickstart](https://docs.onegini.com/app-developer-quickstart.html#step1) and perform the first step.
3. Click the 'Artifacts' tab on the left side 
4. Navigate to the `onegini-sdk/com/onegini/mobile/sdk/ios/libOneginiSDKiOS/` folder. 
5. download the latest 5.x version of the OneginiSDK, e.g.: `libOneginiSDKiOS-5.00.01.a` + headers file. They should be bundled as well in a zip file. 

### Adding the Onegini iOS SDK to the Example App
1. Copy libOneginiSDKiOS-5.xx.xx.a binary to the ./OneginiExampleApp/OneginiSDK folder. This path is relative to the project file.
2. In Xcode, make sure the binary is added to the `Framework/OneginiSDK` group. If not, add it.

### Setup the Cocoapods dependencies
1. Run `pod install` to correctly setup the Cocoapods dependencies
2. Make sure that you open the project referring to `OneginiExampleApp.xcworkspace` in Xcode or AppCode.

## Providing token server configuration
The example app is already configured with the token server out of the box. 

### Changing the configuration
If there is a need to change the token server configuration within the example app it is going to be best to do it using the Onegini SDK Configurator. Follow 
the steps as described in: `https://github.com/Onegini/sdk-configurator`
