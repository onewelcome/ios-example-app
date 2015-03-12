var exec = require('cordova/exec');

module.exports = {
  /**
   * Initialises the Onegini SDK with config. The config object has a property sdkConfig and an array of certificates.
   * The sdkConfig depends on the platform.
   * @param {Object} config             Configuration for the Onegini SDK.
   */
  initWithConfig: function (config) {
    exec(function (response) {
          console.log(response);
        }, function (error) {

        },
        'OneginiCordovaClient', 'initWithConfig', [config.sdkConfig, config.certificates]);
  },

  /**
   * Fetches a specific resource.
   * The access token validation flow is invoked if no valid access token is available.
   *
   * @param {Function} successCallback  Function that can handle the successful resource call. Is called with a JSON
   *                                    response object as argument.
   * @param {Function} errorCallback    Function that can handle an unsuccessful resource call. Is called with the
   *                                    error object as argument.
   * @param {String} path               Location on the resource server to return the resource. The base URI of the
   *                                    resource server is.
   * @param {Array} scopes              Array of Strings with scopes to fetch the resource.
   * @param {String} requestMethod      HTTP request method to retrieve the resource: 'GET', 'PUT', 'POST' or 'DELETE'
   * @param {String} paramsEncoding     Encoding of parameters, 'FORM', 'JSON' or 'PROPERTY'
   * @param {Object} params             Parameters to send with the request.
   */
  fetchResource: function (successCallback, errorCallback, path, scopes, requestMethod, paramsEncoding, params) {
    exec(function (response) {
      if (successCallback) {
        successCallback(response);
      }
    }, function (error) {
      if (errorCallback) {
        errorCallback(error);
      }
    }, 'OneginiCordovaClient', 'fetchResource', [path, scopes, requestMethod, paramsEncoding, params]);
  },

  /**
   * Fetches a specific resource anonymously using a client access token.
   * The access token validation flow is invoked if no valid access token is available.
   *
   * @param {Function} successCallback  Function that can handle the successful resource call. Is called with a JSON
   *                                    response object as argument.
   * @param {Function} errorCallback    Function that can handle an unsuccessful resource call. Is called with the
   *                                    error object as argument.
   * @param {String} path               Location on the resource server to return the resource. The base URI of the
   *                                    resource server is.
   * @param {Array} scopes              Array of Strings with scopes to fetch the resource.
   * @param {String} requestMethod      HTTP request method to retrieve the resource: 'GET', 'PUT', 'POST' or 'DELETE'
   * @param {String} paramsEncoding     Encoding of parameters, 'FORM', 'JSON' or 'PROPERTY'
   * @param {Object} params             Parameters to send with the request.
   */
  fetchAnonymousResource: function (successCallback, errorCallback, path, scopes, requestMethod, paramsEncoding,
                                    params) {
    // not implemented in the base app yet
    exec(function (response) {
      if (successCallback) {
        successCallback(response);
      }
    }, function (error) {
      if (errorCallback) {
        errorCallback(error);
      }
    }, 'OneginiCordovaClient', 'fetchAnonymousResource', [path, scopes, requestMethod, paramsEncoding, params]);
  },

  /**
   * Main entry point into the authorization process.
   *
   * @param {Object} router   Object that can handle page transition for the outcome of the authorization. Should at
   *                          least implement the following methods:
   *                          - requestAuthorization(url) -> redirects the user to the given url to log in
   *                          - askForCurrentPin -> should display a screen to verify the PIN code. Must call
   *                                         checkPin(errorCallback, pin)
   *                          - askForNewPin -> should display a screen to set a PIN code. Must call
   *                                         setPin(errorCallback, pin, verifyPin)
   *                          - authorizationSuccess -> should show the landing page for the authenticated user
   *                          - authorizationFailure(error) -> should handle authentication failure. If this method
   *                                         is called, the authorization transaction is lost. The authorize method
   *                                         must be called again to continue with the authorization flow. It may
   *                                         require to keep an internal state to display error messages such as
   *                                         'Invalid PIN code, try again'.
   * @param {Array} scopes    {Array} with {String}s that represent the scopes for the access token
   */
  authorize: function (router, scopes) {
    exec(function (response) {
      /*
       The response method contains the name of the method in the OGAuthorizationDelegate protocol
       */
      if (response.method == 'requestAuthorization') {
        router.requestAuthorization(response.url);
      }
      else if (response.method == 'askForCurrentPin') {
        // TODO rename function conform response.method name
        router.askForPin();
      }
      else if (response.method == 'askForNewPin') {
        // TODO rename function conform response.method name
        router.askForPinWithVerification();
      }
      else if (response == 'authorizationSuccess') {
        router.authorizationSuccess();
      }
    }, function (error) {
      router.authorizationFailure(error, scopes);
    }, 'OneginiCordovaClient', 'authorize', scopes);
  },

  /**
   * This will end the current session and invalidate the access token. The refresh token and client credentials
   * remain untouched.
   */
  logout: function (successCallback, errorCallback) {
    exec(successCallback, errorCallback, 'OneginiCordovaClient', 'logout', []);
  },

  /**
   * Disconnect from the service, this will clear the refresh token and access token. Client credentials remain
   * untouched.
   */
  disconnect: function (successCallback, errorCallback) {
    exec(successCallback, errorCallback, 'OneginiCordovaClient', 'disconnect', []);
  },

  /**
   * For testing purpose only: Clear the client credentials. A new dynamic client registration has to be performed
   * on the next authorization request.
   */
  clearCredentials: function () {
    exec(null, null, 'OneginiCordovaClient', 'clearCredentials', []);
  },

  /**
   * For testing purpose only: Clear all tokens and reset the pin attempt count.
   */
  clearTokens: function () {
    exec(null, null, 'OneginiCordovaClient', 'clearTokens', []);
  },

  /**
   * Validates the PIN entered by the user. Can only be called within the authorization flow. In case of success, the
   * authorize function decides the next step. If something goes wrong, the errorCallback is called.
   *
   * If the PIN has an invalid format (too long, too short, invalid characters), it will count as verification
   * attempt.
   *
   * An INVALID_ACTION is returned if no authorization transaction is registered.
   *
   * @param {Function} errorCallback  Function to call when the PIN verification fails. Is called with an error object
   *                                  as argument.
   * @param {String} pin              The PIN code to verify
   */
  checkPin: function (errorCallback, pin) {
    exec(null, function (error) {
    errorCallback(error);
    }, 'OneginiCordovaClient', 'confirmCurrentPin', [pin]);
  },

  /**
   * Sets a PIN for the user. Can only be called within the authorization flow. In case of success, the
   * authorize function decides the next step. If something goes wrong, the errorCallback is called.
   * Callback is performed on initiating authorize callback handler.
   *
   * The app should first verify whether the PIN has the correct format and the verifyPin matches the pin.
   *
   * An INVALID_ACTION is returned if no authorization transaction is registered.
   *
   * @param errorCallback     Function to call when the PIN verification fails. Is called with an error object
   *                          containing a 'reason' and potentially additional key:
   *                          - pinBlackListed -> entered PIN is black listed
   *                          - pinShouldNotBeASequence -> PIN cannot contain a sequence
   *                          - pinShouldNotUseSimilarDigits with maxSimilarDigits key -> PIN can contain only
   *                                         'maxSimilarDigits' same digits
   *                          - pinTooShort -> entered PIN is too short
   *                          - pinEntryError -> PIN retrieval error
   * @param {String} pin      The PIN code to set
   */
  setPin: function (errorCallback, pin) {
    exec(null, function (error) {
      console.log(error);
      errorCallback(error);
    }, 'OneginiCordovaClient', 'confirmNewPin', [pin]);
  },

  /**
   * Changes PIN number. User will firstly be prompted to enter current PIN number and once validation success
   * will enter PIN creation flow.
   *
   * @param {Object} router   Object that can handle page transition for the outcome of the change pin. Should at
   *                          least implement the following methods:
   *                          - askForNewPinChangePinFlow -> should display a screen to set a PIN code. Must call
   *                                         confirmNewPinForChangeRequest(errorCallback, pin)
   *                          - askForPinChangePinFlow -> should display a screen to verify the PIN code. Must call
   *                                         confirmCurrentPinForChangeRequest(errorCallback, pin)
   *                          - changePinSuccess -> should handle completion of change PIN flow
   *                          - changePinError -> should show the landing page for the authenticated user
   *                          - authorizationFailure(error) -> should handle change PIN failure. If this method
   *                                         is called, the change PIN transaction is lost.
   *                                         Method must handle errors with following 'reason' properties:
   *                                         'invalidCurrentPin'
   *                                         'pinChangeError'
   */
  changePin: function (router) {
    exec(function (response) {
      if (response.method == 'askNewPinForChangeRequest') {
        router.askForNewPinChangePinFlow();
      }
      else if (response.method == 'askCurrentPinForChangeRequest') {
        router.askForPinChangePinFlow();
      }
      else {
        router.changePinSuccess();
      }
    }, function (error) {
      router.changePinError(error);
    }, 'OneginiCordovaClient', 'changePin', []);
  },
  confirmCurrentPinForChangeRequest: function (errorCallback, pin) {
    exec(null, function (error) {
        console.log(error);
        if (errorCallback) {
          errorCallback(error);
        }
    },
    'OneginiCordovaClient', 'confirmCurrentPinForChangeRequest', [pin]);
  },

  /**
   * Sets a new PIN for the user. Can only be called within the change PIN flow. In case of success, the
   * changePin function decides the next step. If something goes wrong, the errorCallback is called.
   * Callback is performed on initiating changePin callback handler.
   *
   * The app should first verify whether the PIN has the correct format and the verifyPin matches the pin.
   *
   * An INVALID_ACTION is returned if no change PIN transaction is registered.
   *
   * @param errorCallback     Function to call when the PIN verification fails. Is called with an error object
   *                          containing a 'reason' and potentially additional key:
   *                          - pinBlackListed -> entered PIN is black listed
   *                          - pinShouldNotBeASequence -> PIN cannot contain a sequence
   *                          - pinShouldNotUseSimilarDigits with maxSimilarDigits key -> PIN can contain only
   *                                         'maxSimilarDigits' same digits
   *                          - pinTooShort -> entered PIN is too short
   *                          - pinEntryError -> PIN retrieval error
   * @param {String} pin      The PIN code to set
   */
  confirmNewPinForChangeRequest: function (errorCallback, pin) {
    exec(null, function (error) {
      console.log(error);
      errorCallback(error);
    }, 'OneginiCordovaClient', 'confirmNewPinForChangeRequest', [pin]);
  },

  /**
   * Validates provided PIN number against clients pin policy.
   *
   * @param errorCallback     Function to call when the PIN verification fails. Is called with an error object
   *                          containing a 'reason' and potentially additional key:
   *                          - pinBlackListed -> entered PIN is black listed
   *                          - pinShouldNotBeASequence -> PIN cannot contain a sequence
   *                          - pinShouldNotUseSimilarDigits with maxSimilarDigits key -> PIN can contain only
   *                                         'maxSimilarDigits' same digits
   *                          - pinTooShort -> entered PIN is too short
   *                          - pinEntryError -> PIN retrieval error
   * @param {String} pin      The PIN code to set
   */
  validatePin: function (errorCallback, pin) {
    exec(null, function (error) {
      errorCallback(error);
    }, 'OneginiCordovaClient', 'validatePin', [pin]);
  },

  cancelPinChange: function () {
    // not implemented in the base app yet
    exec(null, null, 'OneginiCordovaClient', 'cancelPinChange', []);
  }
};