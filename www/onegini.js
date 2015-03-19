var exec = require('cordova/exec');

module.exports = {
  /**
   * Awaits notification that the Onegini plugin initialization is finished.
   * @param successCallback   Function to be called on plugin initialisation complete
   * @param errorCallback     Function to be called on plugin initialisation failure
   */
  awaitPluginInitialization: function (successCallback, errorCallback) {
    exec(successCallback, errorCallback,
        oneginiCordovaPlugin.OG_CONSTANTS.CORDOVA_CLIENT, oneginiCordovaPlugin.OG_CONSTANTS.AWAIT_PLUGIN_INITIALIZATION, []);
  },

  /**
   * Initiates static PIN callback session. Whenever SDK will require top level application to show PIN dialog,
   * it will use this session.
   * @param {Object} router   Object that can handle page transition for the outcome of the authorization. Should at
   *                          least implement the following methods:
   *                          - askForCurrentPin -> should display a screen to verify the PIN code. Must call
   *                                         checkPin(errorCallback, pin)
   *                          - askForNewPin -> should display a screen to set a PIN code. Must call
   *                                         setPin(errorCallback, pin, verifyPin)
   *                          - askForNewPinChangePinFlow -> should display a screen to set a PIN code. Must call
   *                                         confirmNewPinForChangeRequest(errorCallback, pin)
   *                          - askForPinChangePinFlow -> should display a screen to verify the PIN code. Must call
   *                                         confirmCurrentPinForChangeRequest(errorCallback, pin)
   * @param errorCallback
   */
  initPinCallbackSession: function (router, errorCallback) {
    exec(function (response) {
          if (response.method == oneginiCordovaPlugin.OG_CONSTANTS.PIN_ASK_FOR_NEW_FOR_CHANGE_REQUEST) {
            router.askForNewPinChangePinFlow(oneginiCordovaPlugin.confirmNewPinForChangeRequest);
          }
          else if (response.method == oneginiCordovaPlugin.OG_CONSTANTS.PIN_ASK_FOR_CURRENT_FOR_CHANGE_REQUEST) {
            router.askForPinChangePinFlow();
          }
          else if (response.method == oneginiCordovaPlugin.OG_CONSTANTS.PIN_ASK_FOR_CURRENT) {
            router.askForPin();
          }
          else if (response.method == oneginiCordovaPlugin.OG_CONSTANTS.PIN_ASK_FOR_NEW) {
            router.askForNewPin(oneginiCordovaPlugin.setPin);
          }
        }, function (error) {
          errorCallback(error);
        },
        oneginiCordovaPlugin.OG_CONSTANTS.CORDOVA_CLIENT, oneginiCordovaPlugin.OG_CONSTANTS.INIT_PIN_CALLBACK_SESSION, []);
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
    }, oneginiCordovaPlugin.OG_CONSTANTS.CORDOVA_CLIENT, oneginiCordovaPlugin.OG_CONSTANTS.FETCH_RESOURCE, [path, scopes, requestMethod, paramsEncoding, params]);
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
    }, oneginiCordovaPlugin.OG_CONSTANTS.CORDOVA_CLIENT, oneginiCordovaPlugin.OG_CONSTANTS.FETCH_ANONYMOUS_RESOURCE, [path, scopes, requestMethod, paramsEncoding, params]);
  },

  /**
   * Main entry point into the authorization process.
   *
   * @param {Object} router   Object that can handle page transition for the outcome of the authorization. Should at
   *                          least implement the following methods:
   *                          - requestAuthorization(url) -> redirects the user to the given url to log in
   *                          - authorizationSuccess -> should show the landing page for the authenticated user
   *                          - invalidCurrentPin(remainingAttempts, scopes) -> indicates that the entered PIN number
   *                                         was invalid and provides an information about remaining PIN attempts
   *                          - tooManyPinAttempts -> method called once user exceeds allowed number of PIN attempts
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
      if (response == oneginiCordovaPlugin.OG_CONSTANTS.AUTHORIZATION_SUCCESS) {
        router.authorizationSuccess();
      }
      else if (response.method == oneginiCordovaPlugin.OG_CONSTANTS.AUTHORIZATION_REQUESTED) {
        router.requestAuthorization(response.url);
      }
    }, function (error) {
      if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.AUTHORIZATION_ERROR_INVALID_PIN) {
        router.invalidCurrentPin(error.remainingAttempts, scopes);
      }
      else if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.AUTHORIZATION_ERROR_TOO_MANY_PIN_ATTEMPTS) {
        router.tooManyPinAttempts();
      } else {
        router.authorizationFailure(error, scopes)
      };
    }, oneginiCordovaPlugin.OG_CONSTANTS.CORDOVA_CLIENT, oneginiCordovaPlugin.OG_CONSTANTS.AUTHORIZATION_AUTHORIZE, scopes);
  },

  /**
   * This will remove current session data and invalidate the access token. The refresh token and client credentials
   * remain untouched.
   *
   * @param successCallback   Function to be called once user is successfully logged out
   * @param errorCallback     Function to be called when logout action fails
   */
  logout: function (successCallback, errorCallback) {
    exec(function (response) {
      oneginiCordovaPlugin.shouldRestoreLocationAfterReauthorization = false;
      successCallback();
    }, errorCallback, oneginiCordovaPlugin.OG_CONSTANTS.CORDOVA_CLIENT, oneginiCordovaPlugin.OG_CONSTANTS.LOGOUT, []);
    this.invalidateSessionState();
  },

  /**
   * Disconnect from the service, this will clear the refresh token and access token and remove session data.
   * Client credentials remain untouched.
   *
   * @param successCallback   Function to be called once disconnect action succeed
   * @param errorCallback     Function to be called when disconnection fails
   */
  disconnect: function (successCallback, errorCallback) {
    exec(function (response) {
      oneginiCordovaPlugin.shouldRestoreLocationAfterReauthorization = false;
      successCallback();
    }, errorCallback, oneginiCordovaPlugin.OG_CONSTANTS.CORDOVA_CLIENT, oneginiCordovaPlugin.OG_CONSTANTS.DISCONNECT, []);
    this.invalidateSessionState();
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
  checkPin: function (successCallback, errorCallback, pin) {
    exec(function (response) {
      successCallback();
    }, function (error) {
      errorCallback(error);
    }, oneginiCordovaPlugin.OG_CONSTANTS.CORDOVA_CLIENT, oneginiCordovaPlugin.OG_CONSTANTS.PIN_CONFIRM_CURRENT, [pin]);
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
    }, oneginiCordovaPlugin.OG_CONSTANTS.CORDOVA_CLIENT, oneginiCordovaPlugin.OG_CONSTANTS.PIN_CONFIRM_NEW, [pin]);
  },

  /**
   * Changes PIN number. User will firstly be prompted to enter current PIN number and once validation success
   * will enter PIN creation flow.
   *
   * @param {Object} router   Object that can handle page transition for the outcome of the change pin. Should at
   *                          least implement the following methods:
   *                          - changePinSuccess -> should handle completion of change PIN flow
   *                          - changePinError -> should show the landing page for the authenticated user
   *                          - invalidCurrentPin(remainingAttempts) -> should handle invalid current PIN
   *                                          in change PIN flow
   *                          - tooManyPinAttempts -> method called once user exceeds allowed number of PIN attempts
   */
  changePin: function (router) {
    exec(function (response) {
      router.changePinSuccess();
    }, function (error) {
      if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.PIN_INVALID) {
        router.invalidCurrentPin(error.remainingAttempts);
      }
      else if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.PIN_CHANGE_ERROR_TOO_MANY_ATTEMPTS) {
        router.tooManyPinAttempts();
      }
      else if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.PIN_CHANGE_ERROR) {
        router.changePinError();
      }
    }, oneginiCordovaPlugin.OG_CONSTANTS.CORDOVA_CLIENT, oneginiCordovaPlugin.OG_CONSTANTS.PIN_CHANGE, []);
  },

  /**
   * Verifies if entered PIN is currently valid, if true proceeds with new PIN creation in change PIN flow.
   *
   * @param errorCallback   Function to call PIN verification fails
   * @param pin             Entered PIN number
   */
  confirmCurrentPinForChangeRequest: function (errorCallback, pin) {
    exec(null, function (error) {
          console.log(error);
          if (errorCallback) {
            errorCallback(error);
          }
        },
        oneginiCordovaPlugin.OG_CONSTANTS.CORDOVA_CLIENT, oneginiCordovaPlugin.OG_CONSTANTS.PIN_CONFIRM_CURRENT_FOR_CHANGE_REQUEST, [pin]);
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
    }, oneginiCordovaPlugin.OG_CONSTANTS.CORDOVA_CLIENT, oneginiCordovaPlugin.OG_CONSTANTS.PIN_CONFIRM_NEW_FOR_CHANGE_REQUEST, [pin]);
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
    }, oneginiCordovaPlugin.OG_CONSTANTS.CORDOVA_CLIENT, oneginiCordovaPlugin.OG_CONSTANTS.PIN_VALIDATE, [pin]);
  },

  /**
   * Cancels started pin change flow and removes related session data.
   */
  cancelPinChange: function () {
    // not implemented in the base app yet
    exec(null, null, oneginiCordovaPlugin.OG_CONSTANTS.CORDOVA_CLIENT, oneginiCordovaPlugin.OG_CONSTANTS.PIN_CANCEL_CHANGE, []);
  },

  /**
   * Checks if user is currently registered (if he has refresh token)
   * @param successCallback   Function to be called if user is registered
   * @param errorCallback     Function to be called is user isn't registered
   */
  checkIsRegistered: function (successCallback, errorCallback) {
    exec(function (response) {
      console.log("user is registered");
      successCallback();
    }, function (error) {
      console.log("user is unregistered");
      errorCallback(error);
    }, oneginiCordovaPlugin.OG_CONSTANTS.CORDOVA_CLIENT, oneginiCordovaPlugin.OG_CONSTANTS.CHECK_IS_REGISTERED, []);
  },

  /**
   * Invalidates session storage data.
   */
  invalidateSessionState: function () {
    var length = sessionStorage.length;
    while (length--) {
      var key = sessionStorage.key(i);
      sessionStorage.removeItem(key);
    }
  },

  /**
   * Preserves in currently displayed page identifier in sessions storage.
   */
  preserveCurrentLocaiton: function () {
    var activePage = $.mobile.activePage.attr("id");
    sessionStorage.setItem(oneginiCordovaPlugin.OG_CONSTANTS.PAGE_OF_ORIGIN, activePage);
  },

  inAppBrowser: {},

  /**
   * Opens specified URL using inAppBrowser, should be used only if inAppBrowser plugin is active.
   * @param url   URL to open
   */
  openInAppBrowser: function (url) {
    oneginiCordovaPlugin.inAppBrowser = window.open(url, '_blank', 'location=no,toolbar=no');
  },

  /**
   * Closes inAppBrowser.
   */
  closeInAppBrowser: function () {
    if (oneginiCordovaPlugin.inAppBrowser && oneginiCordovaPlugin.inAppBrowser.close) {
      oneginiCordovaPlugin.inAppBrowser.close();
    }
  },

  /**
   * List of constant values used in communication with OneginiCordovaPlugin.
   */
  OG_CONSTANTS: {
    PAGE_OF_ORIGIN: "origin_page",

    CORDOVA_CLIENT: "OneginiCordovaClient",

    AWAIT_PLUGIN_INITIALIZATION: "awaitPluginInitialization",
    INIT_PIN_CALLBACK_SESSION: "initPinCallbackSession",

    AUTHORIZATION_AUTHORIZE: "authorize",
    AUTHORIZATION_REQUESTED: "requestAuthorization",
    AUTHORIZATION_SUCCESS: "authorizationSuccess",
    AUTHORIZATION_FAILURE: "authorizationFailure",
    AUTHORIZATION_ERROR_INVALID_PIN: "authorizationErrorInvalidGrant",
    AUTHORIZATION_ERROR_TOO_MANY_PIN_ATTEMPTS: "authorizationErrorTooManyPinFailures",

    PIN_ASK_FOR_CURRENT: "askForCurrentPin",
    PIN_ASK_FOR_NEW: "askForNewPin",
    PIN_CONFIRM_NEW: "confirmNewPin",
    PIN_CONFIRM_CURRENT: "confirmCurrentPin",
    PIN_VALIDATE: "validatePin",
    PIN_BLACK_LISTED: "pinBlackListed",
    PIN_SHOULD_NOT_BE_A_SEQUENCE: "pinShouldNotBeASequence",
    PIN_SHOULD_NUT_USE_SIMILAR_DIGITS: "pinShouldNotUseSimilarDigits",
    PIN_MAX_SIMILAR_DIGITS: "maxSimilarDigits",
    PIN_TOO_SHORT: "pinTooShort",
    PIN_ENTRY_ERROR: "pinEntryError",
    PIN_CHANGE: "changePin",
    PIN_CHANGE_ERROR: "pinChangeError",
    PIN_CHANGE_ERROR_TOO_MANY_ATTEMPTS: "pinChangeErrorTooManyAttempts",
    PIN_ASK_FOR_CURRENT_FOR_CHANGE_REQUEST: "askCurrentPinForChangeRequest",
    PIN_ASK_FOR_NEW_FOR_CHANGE_REQUEST: "askNewPinForChangeRequest",
    PIN_CONFIRM_NEW_FOR_CHANGE_REQUEST: "confirmNewPinForChangeRequest",
    PIN_CONFIRM_CURRENT_FOR_CHANGE_REQUEST: "confirmCurrentPinForChangeRequest",
    PIN_CANCEL_CHANGE: "cancelPinChange",
    PIN_INVALID: "invalidCurrentPin",

    DISCONNECT: "disconnect",
    LOGOUT: "logout",
    CHECK_IS_REGISTERED: "isRegistered",

    FETCH_RESOURCE: "fetchResource",
    FETCH_ANONYMOUS_RESOURCE: "fetchAnonymousResource",
    FETCH_RESOURCE_AUTH_FAILED: "resourceCallErrorAuthenticationFailed"
  }
};