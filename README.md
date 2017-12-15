# iOS Example App

The iOS Example App is using the Onegini iOS SDK to perform secure authentication and resource calls. Please have a look at the
[App developer quickstart](https://docs.onegini.com/app-developer-quickstart.html) if you want more information about how to get setup with this
example app.

## Installation

### Setup access to the Onegini Cocoapods repository
The Example app includes the Onegini SDK as a Cocoapod. In order to let Cocoapods download it you need to setup your account details so the SDK can be
automatically downloaded:
1. Make sure that you have access to the Onegini Artifactory repository (https://repo.onegini.com). If not please follow first step of [App developer quickstart](https://docs.onegini.com/app-developer-quickstart.html).
2. Follow [Setting up the project guide](https://docs.onegini.com/ios-sdk/topics/setting-up-the-project.html#cocoapods) in the Onegini SDK documentation for
instructions on configuring access to the Onegini Cocoapods repository.

>**Note** Don't forget to update the Onegini Cocoapods repository with the following command: `pod repo-art update onegini`. If you don't update the repo it may
be that the SDK dependency cannot be found. If that is the case be sure to execute the command above.

### Setup the Cocoapods dependencies
1. Run `pod install` to correctly setup the Cocoapods dependencies
2. Make sure that you open the project referring to `OneginiExampleApp.xcworkspace` in Xcode or AppCode.

## Providing token server configuration
The example app is already configured with the token server out of the box.

### Changing the configuration
If there is a need to change the token server configuration within the example app it is going to be best to do it using the Onegini SDK Configurator. Follow
the steps as described in: `https://github.com/Onegini/sdk-configurator`
