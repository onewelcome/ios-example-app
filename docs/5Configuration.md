# Configuration

The Onegini Cordova Plugin depends on Onegini Mobile SDK which in turn requires a set of configuration parameters which must be provided by means of "config.json" file which is located in each platform directory. 
The configuration file must contain fallowing properties:

- "kOGAppIdentifier": end application identifier, must correspond to a one configured within the Token Server
- "kOGAppPlatform": application platform [ios, android, windows]
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
        "kOGAppPlatform": "ios",
        "kOGAppScheme": "oneginisdk",
        "kOGAppVersion": "1.0.0",
        "kAppBaseURL": "https://authorization-server.onegini.com",
        "kOGMaxPinFailures": "3",
        "kOGResourceBaseURL": "https://authorization-server.onegini.com",
        "kOGRedirectURL": "oneginisdk://",
        "kOGUseEmbeddedWebview": true
    }
    
    
