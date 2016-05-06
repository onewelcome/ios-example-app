# 1. OneginiCordovaPlugin interface

This page describes all public methods of OneginiCordovaPlugin.

### awaitPluginInitialization(router)
Awaits notification that the Onegini plugin initialization is finished.

**Param** `router` -  Object that can handle page transition for the outcome of the action. Should at least implement the following methods:
  - `pluginInitialized` - called once plugin is initialized successfully
  - `errorConnectivityProblem` - called whenever plugin isn't able to establish connection with the server
  - `initializationError` - called when other error occurred during plugin initialization


### initPinCallbackSession(router)
Initiates a static PIN callback session. Whenever SDK will require top level application to show PIN dialog, it will use this session.

**Param** `router` - Object that can handle page transition for the outcome of the action. Should at least implement the following methods:
  - `askForCurrentPin` - should display a screen to verify the PIN code. Must call checkPin(errorCallback, pin)
  - `askForNewPin` - should display a screen to set a PIN code. Must call setPin(errorCallback, pin, verifyPin)
  - `askForNewPinChangePinFlow` - should display a screen to set a PIN code. Must call confirmNewPinForChangeRequest(errorCallback, pin)
  - `askForPinChangePinFlow` - should display a screen to verify the PIN code. Must call confirmCurrentPinForChangeRequest(errorCallback, pin)
  - `pinCallbackInitFailed` - method called when PIN callback initialization fails


### initInAppBrowserCallbackSession(errorCallback)
Initiates static callback session to enable control over InAppBrowser from native code.

**Param** `errorCallback` - Function to be called when action fails


### xmlHttpRequest.create(onCompleted)
Overrides standard XmlHttpRequest to pass request through resource server so instead of sending request directly to specified address it will be passed to 
resource server.

**Param** onCompleted callback method called after new XmlHttpRequest is ready to use

### xmlHttpRequest.revert()
Restores original XmlHttpRequest.

### fetchResource(onResponse, path, requestMethod, params, headers)
Fetches a specific resource. The access token validation flow is invoked if no valid access token is available.

**Param** `onResponse` - Callback method called after request has been completed. Method declaration should look like this `onResponse(headers, status, reason, requestUrl, body)`

**Param** `path` - Location on the resource server to return the resource. The base URI of the resource server is.

**Param** `requestMethod` - HTTP request method to retrieve the resource: 'GET', 'PUT', 'POST' or 'DELETE'

**Param** `params` - Parameters to send with the request.

**Param** `headers` - Optional custom headers to send with the request.


### fetchAnonymousResource(onResponse, path, requestMethod, params, headers)
Fetches a specific resource anonymously using a client access token. The access token validation flow is invoked if no valid access token is available.

**Param** `onResponse` - Callback method called after request has been completed. Method declaration should look like this `onResponse(headers, status, reason, requestUrl, body)`

**Param** `path` - Location on the resource server to return the resource. The base URI of the resource server is.

**Param** `requestMethod` - HTTP request method to retrieve the resource: 'GET', 'PUT', 'POST' or 'DELETE'

**Param** `params` - Parameters to send with the request.

**Param** `headers` - Optional custom headers to send with the request.


### isRegistered(successCallback, errorCallback)
Determine if the user is registered.

**Param** `successCallback` - Function to be called when user is already registered

**Param** `errorCallback` - Function to be called when user is not yet registered


### authorize(router, scopes)
Main entry point into the authorization process.

**Param** `router` - Object that can handle page transition for the outcome of the action. Should at least implement the following methods:
  - `authorizationSuccess` - should show the landing page for the authenticated user
  - `errorInvalidCurrentPin(remainingAttempts, scopes)` - indicates that the entered PIN number was invalid and provides an information about remaining PIN attempts
  - `errorTooManyPinAttempts` - method called once user exceeds allowed number of PIN attempts
  - `errorRegistrationFailed` - invoked when client registration fails
  - `errorConnectivityProblem` - method called whenever plugin isn't able to establish connection with the server
  - `errorNotAuthenticated` - invoked when client credentials are invalid
  - `errorNotAuthorized` - called when client was not authorized to perform action
  - `errorInvalidScope` - one or more of the scopes requested authorization for were not available
  - `errorInvalidState` - the state parameter in the authorization request is different than the value in the callback. This indicates a possible man in the middle attack.
  - `errorInvalidRequest` - method called when one or more required parameters were missing in the authorization request.
  - `errorInvalidGrant` - called when access grant or refresh token was invalid
  - `errorPinForgotten` - invoked when user enters "I forgot my PIN" flow from within native pin screen 
  - `errorUnsupportedAppVersion` - invoked when application version is not valid and update is needed

**Param** `scopes` - Array with Strings that represent the scopes for the access token

### logout:(successCallback, errorCallback)
This will remove current session data and invalidate the access token. The refresh token and client credentials remain untouched.

**Param** `successCallback` - Function to be called once user is successfully logged out

**Param** `errorCallback` - Function to be called when logout action fails


### disconnect(successCallback, errorCallback)
Disconnect from the service, this will clear the refresh token and access token and remove session data. Client credentials remain untouched.

**Param** `successCallback` - Function to be called once disconnect action succeed

**Param** `errorCallback` - Function to be called when disconnection fails


### checkPin(successCallback, errorCallback, pin)
Validates the PIN entered by the user. Can only be called within the authorization flow. In case of success, the authorize function decides the next step. If something goes wrong, the errorCallback is called.

If the PIN has an invalid format (too long, too short, invalid characters), it will count as verification attempt. If application uses native pin screens, PIN validation is done internally.

An INVALID_ACTION is returned if no authorization transaction is registered.

**Param** `errorCallback` - Function to call when the PIN verification fails. Is called with an error object as argument.
**Param** `pin` - The PIN code to verify


### setPin(errorCallback, pin) 
Sets a PIN for the user. Can only be called within the authorization flow. In case of success, the authorize function decides the next step. If something goes wrong, the errorCallback is called. Callback is performed on initiating authorize callback handler.

The app should first verify whether the PIN has the correct format and the verifyPin matches the firstly provided pin. If application uses native pin screens, PIN validation is done internally by the plugin.

An INVALID_ACTION is returned if no authorization transaction is registered.

**Param** `errorCallback` - Function to call when the PIN verification fails. Is called with an error object containing a 'reason' and potentially additional key:
  - `pinBlackListed` - entered PIN is black listed
  - `pinShouldNotBeASequence` - PIN cannot contain a sequence
  - `pinShouldNotUseSimilarDigits(maxSimilarDigits)` - PIN can contain only `maxSimilarDigits` same digits
  - `pinTooShort` - entered PIN is too short
  - `pinEntryError` - PIN retrieval error

**Param** `pin` - The PIN code to set


### changePin(router) 
Changes PIN number. User will firstly be prompted to enter current PIN number and once validation success will enter PIN creation flow.

**Param** `router` - Object that can handle page transition for the outcome of the change pin. Should at least implement the following methods:
  - `changePinSuccess` - should handle completion of change PIN flow
  - `changePinError` - should show the landing page for the authenticated user
  - `invalidCurrentPin(remainingAttempts)` - should handle invalid current PIN in change PIN flow
  - `tooManyPinAttempts` - method called once user exceeds allowed number of PIN attempts
  - `errorConnectivityProblem` - method called whenever plugin isn't able to establish connection with the server
  - `errorPinForgotten` - invoked when user enters "I forgot my PIN" flow from within native pin screen 

### confirmCurrentPinForChangeRequest(errorCallback, pin)
Verifies if entered PIN is currently valid, if true proceeds with new PIN creation in change PIN flow.  
If application uses native pin screens, current pin verification is done internally by the plugin.

**Param** `errorCallback` - Function to call when PIN verification fails

**Param** `pin` - Entered PIN number


### confirmNewPinForChangeRequest(router, pin)    
Sets a new PIN for the user. Can only be called within the change PIN flow. In case of success, the changePin function decides the next step. If something goes wrong, the errorCallback is called. Callback is performed on initiating changePin callback handler.

The app should first verify whether the PIN has the correct format and the verifyPin matches the pin. If application uses native pin screens, both validation and new PIN set are done internally by the plugin.

An INVALID_ACTION is returned if no change PIN transaction is registered.

**Param** `router` - Object that can handle PIN verification failure. Should at least implement the following methods:
  - `pinBlackListed` - entered PIN is black listed
  - `pinShouldNotBeASequence` - PIN cannot contain a sequence
  - `pinShouldNotUseSimilarDigits(maxSimilarDigits)` - PIN can contain only `maxSimilarDigits` same digits
  - `pinTooShort` - entered PIN is too short
  - `pinEntryError` - PIN retrieval error

**Param** `pin` - The PIN code to set


### validatePin(router, pin)
Validates provided PIN number against clients pin policy.

If application uses native pin screens, PIN validation is done internally by the plugin.

**Param** `router` - Object that can handle PIN verification failure. Should at least implement the following methods:
  - `pinValid` - PIN validation succeeded
  - `pinBlackListed` - entered PIN is black listed
  - `pinShouldNotBeASequence` - PIN cannot contain a sequence
  - `pinShouldNotUseSimilarDigits(maxSimilarDigits)` - PIN can contain only 'maxSimilarDigits' same digits
  - `pinTooShort` - entered PIN is too short
  - `pinEntryError` - PIN retrieval error
  
**Param** `pin` - The PIN code to set


### cancelPinChange
Cancels started pin change flow and removes related session data.


### setupScreenOrientation
Detect and lock in prefered screen orientation (tablet in landscape, phone in portrait).


### invalidateSessionState
Invalidates session storage data.


### preserveCurrentLocation
Preserves currently displayed page identifier in sessions storage.


### preserveLocation(pageId)
Preserves specified page identifier in sessions storage.

**Param** `pageId` - page to preserve


### openInAppBrowser(url)
Opens specified URL using inAppBrowser, should be used only if inAppBrowser plugin is active.

**Param** `url` - URL to open


### closeInAppBrowser
Closes inAppBrowser.

### enrollForMobileAuthentication(router, scopes)
Enrolls currently connected device for mobile push authentication.

**Param** `router` - Object that can handle page transition for the outcome of the action. Should at least implement the following methods:
  - `enrollmentSuccess` - enrollment success
  - `error` - indicated general enrollment error
  - `errorAuthenticationError` - failed to authenticate the user for enrollment
  - `errorDeviceAlreadyEnrolled` -  the device is already enrolled
  - `errorInvalidClientCredentials` - provided client credentials are invalid
  - `errorInvalidRequest` - one or more request parameters missing
  - `errorInvalidTransaction` - the transaction id used during enrollment is invalid, probably because the transaction validity period is expired
  - `errorNotAvailable` - enrollment for mobile authentication is currently disabled
  - `errorUserAlreadyEnrolled` - user is already enrolled for mobile authentication
  
**Param** `scopes` - Array with Strings that represent the scopes for the access token

### enrollForFingerprintAuthentication(router)
Enrolls currently connected device for fingerprint authentication

**Param** `router` - Object that can handle page transition for the outcome of the action. Should at least implement the following methods:
  - `enrollmentSuccess` - enrollment success
  - `error` - indicated general enrollment error
  - `errorTooManyPinAttempts` - method called once user exceeds allowed number of PIN attempts


### checkFingerpringAuthenticationState(successCallback, errorCallback)
Determine if the user is enrolled for fingerprint authentication.

**Param** `successCallback` - Function to be called when user is already enrolled for fingerprint authentication

**Param** `errorCallback` - Function to be called when user is not yet enrolled for fingerprint authentication

### disableFingerprintAuthentication 
Disable fingerprint authentication. Fingerprint data are deleted from device and revoked from token server. If revoke request fails local data are nethertheless deleted from device.


### isAndroid
Determines whenever userAgent is Android.


### isiOS
Determines whenever userAgent is iOS.