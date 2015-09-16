# 5. Configuration

## 5.1 config.json
The Onegini Cordova Plugin depends on Onegini Mobile SDK which in turn requires a set of configuration parameters which must be provided by means of "config.json" file which is located in `src/generic` directory.
The configuration file must contain fallowing properties:

- "kOGAppIdentifier": end application identifier, must correspond to a one configured within the Token Server
- "kOGAppScheme": custom end application scheme, used to perform a back-to-the-app redirect
- "kOGAppVersion": end application version, must correspond to a one configured within the Token Server
- "kAppBaseURL": Token Server instance address, for secure HTTPS connection please refer to [Certificate pinning](4Certificatepinning.md)
- "kOGMaxPinFailures": allowed number of PIN attempts
- "kOGResourceBaseURL": Resource Server instance address, for secure HTTPS connection please refer to [Certificate pinning](4Certificatepinning.md)
- "kOGRedirectURL": redirection URL prefix which should be accepted by the SDK within authorization flow 
- "kOGUseEmbeddedWebview": indicates whenever the Cordova App should use embedded InAppBrowser for opening external URLs

Example of "config.json" file:

    {
        "kOGAppIdentifier": "DemoApp",
        "kOGAppScheme": "oneginisdk",
        "kOGAppVersion": "1.0.0",
        "kAppBaseURL": "https://authorization-server.onegini.com",
        "kOGMaxPinFailures": "3",
        "kOGResourceBaseURL": "https://authorization-server.onegini.com",
        "kOGRedirectURL": "oneginisdk://",
        "kOGUseEmbeddedWebview": true
    }
    
## 5.2. plugin.xml    

The `plugin.xml` file is used to provide properties to end-application manifest - `AndroidManifest.xml`. All configuration changes describe within this chapter should be done within `<platform name="android">` XML node.


### 5.2.1. Custom application scheme
In order to perform back to the app redirection from in-app browser after following the registration process on Android application needs to declare the scheme to which it will respond. 

```xml
    <config-file target="AndroidManifest.xml" parent="/*/application/activity">
      <intent-filter>
        ...
        <data android:scheme="oneginisdk"/>
        ...
      </intent-filter>
    </config-file>
```

### 5.2.2. Permissions
The Onegini SDK is capable of performing Push Authentication, therefore it needs appropriate permission set to access specific features of the OS. 
To avoid permission declaration conflicts during apps installation it is necessary to update below lines replacing `com.onegini.mobile.sdk.android.demo` with your application identifier/package `${YOUR_APPLICATION_ID}.permission.C2D_MESSAGE`.
```xml
    <config-file target="AndroidManifest.xml" parent="/manifest">
        ...
        <permission android:name="com.onegini.mobile.sdk.android.demo.permission.C2D_MESSAGE"
                      android:protectionLevel="signature"/>
        <uses-permission android:name="com.onegini.mobile.sdk.android.demo.permission.C2D_MESSAGE"/>
        ...
    </config-file>        
```
