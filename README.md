# iOS Example App secured by Onegini iOS SDK

iOS Example App is using Onegini iOS SDK to perform secure authentication and resource calls. Documentation about Onegini iOS SDK is available at https://docs.onegini.com/public/ios-sdk. 

## Installation

### Downloading Onegini iOS SDK
1. Go to https://repo.onegini.com
2. Login using your credentials (provided to you by Onegini support via `support@onegini.com`). If you don't have these, feel free to create an account on `http://support.onegini.com` and request credentials. 
3. CLick the 'Artifacts' tab on the left side 
4. Navigate to the `onegini-sdk/com/onegini/mobile/sdk/ios/OneginiSDKiOS/` folder. 
5. download the latest 4.x version of the OneginiSDK, e.g.: `OneginiSDKiOS-4.10.00-Release-fat-binary.a` + headers file. They should be bundled as well in a zip file. 

### Adding Onegini iOS SDK to Example App
1. Copy OneginiSDKiOS-4.xx.xx-Release-fat-binary.a binary and Headers folder to ./OneginiDemoApp/OneginiSDK folder. This path is relative to the project file.
2. In Xcode, make sure the binary and headers are added to Framework/OneginiSDK group. If not, add them.

## Providing token server configuration
The example app is already configured with token server out of the box. 

### Changing the configuration
If there is a need to change token server configuration within the example app it is going to be best to do it using the OneginiConfigurator. Follow the steps as described in: `https://github.com/Onegini/sdk-configurator`
