# 1. Environment configuration
Download and install node.js (http://nodejs.org/download) for the platform of your choice. <br>
Once it's done execute

    npm install -g cordova

to install cordova.
Depending on planned usage additionally install 

    npm install -g ios-deploy

for iOS real device deployment support, or/and

    npm install -g ios-sim
for iOS simulator.

#### Resolving dependencies
Plugin dependencies needs to be resolved before it can be installed in Cordova application.

    gradle clean resolveDependencies


# 2. Package contents.
Cordova-plugin package contents: <br>
./platforms - contains platform specific plugin implementation - currently iOS <br>
./www - top level application, contains HTML together with javascripts responsible for handling the communication with OneginiCordovaPlugin and OneginiSDKiOS. If using the cordova CLI, all front-end changes should be applied within this folder.
...

# 3. Running the BaseApp.
#### Cordova CLI
Navigate to project root folder (where ./platforms directory is located) and execute: <br>

    cordova build ios   // to build the app for iOS platform
    cordova run ios     // to deploy and run application directly on connected physical iOS device
    cordova emulate ios // to deploy and run application on iOS emulator
    
Please note that the xCode should not be running when using the cordova CLI. 

#### xCode
Package comes with OneginiCordovaPlugin xCode project which can be used to execute the cordova application. To access it open ./platforms/ios/OneginiCordovaPlugin.xcworkspace

# 4. Dependencies
Currently OneginiCordovaPlugin has only one dependency (OneginiSDKiOS) which is included within the package, we're now working on project structure changes so it may change soon.

# 5. Functionalities
OneginiCordovaPlugin contains already all APIs implemenetions, so it is possible to use the plugin to perform all basic flows. <br>
BaseApp implementation covers most of the flows available within the OneginiCordovaPlugin expect change pin functionallity.

# 6. Todo
- BaseApp change pin functionality implementation.
- BaseApp styling.
- Project cleanup and optimization. 