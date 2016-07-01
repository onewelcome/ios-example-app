# iOS Example App secured by Onegini iOS SDK

iOS Example App is using Onegini iOS SDK to perform secure authentication and resource calls. Documentation about Onegini iOS SDK is available at https://docs.onegini.com/public/ios-sdk. 

## Installation

### Downloading Onegini iOS SDK
1. Go to https://repo.onegini.com
2. Login using your credentials (provided to you by Onegini support via `support@onegini.com`).
3. CLick the 'Artifacts' tab on the left side 
4. Navigate to the `OneginiSDK` folder
5. Download OneginiSDK.zip

### Adding Onegini iOS SDK to Example App
1. Unzip OneginiSDK.zip
2. Copy OneginiSDKiOS-4.08.04-Release-fat-binary.a binary and Headers folder to ./OneginiDemoApp/OneginiSDK folder. This path is relative to the project file.
3. In Xcode, make sure the binary and headers are added to Framework/OneginiSDK group. If not, add them.

## Providing token server configuration
Example app is configured with token server out of the box. If there is a need to change token server configuration within the example app it is best to do it using OneginiConfigurator. 
To configure example app with OneginiConfigurator follow this steps:
1. Download app configuration from token-server.
2. Run the configurator script from https://github.com/Onegini/sdk-configurator.
3. Follow the instructions given by configurator. Preferably use absolute paths.
