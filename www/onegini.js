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
        this.OG_CONSTANTS.CORDOVA_CLIENT, this.OG_CONSTANTS.INIT_WITH_CONFIG, [config.sdkConfig, config.certificates]);
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
    }, this.OG_CONSTANTS.CORDOVA_CLIENT, this.OG_CONSTANTS.FETCH_RESOURCE, [path, scopes, requestMethod, paramsEncoding, params]);
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
    }, this.OG_CONSTANTS.CORDOVA_CLIENT, this.OG_CONSTANTS.FETCH_ANONYMOUS_RESOURCE, [path, scopes, requestMethod, paramsEncoding, params]);
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
      if (response.method == this.OG_CONSTANTS.AUTHORIZATION_REQUESTED) {
        router.requestAuthorization(response.url);
      }
      else if (response.method == this.OG_CONSTANTS.PIN_ASK_FOR_CURRENT) {
        // TODO rename function conform response.method name
        router.askForPin();
      }
      else if (response.method == this.OG_CONSTANTS.PIN_ASK_FOR_NEW) {
        // TODO rename function conform response.method name
        router.askForPinWithVerification();
      }
      else if (response == this.OG_CONSTANTS.AUTHORIZATION_SUCCESS) {
        router.authorizationSuccess();
      }
    }, function (error) {
      router.authorizationFailure(error, scopes);
    }, this.OG_CONSTANTS.CORDOVA_CLIENT, this.OG_CONSTANTS.AUTHORIZATION_AUTHORIZE, scopes);
  },

  /**
   * This will remove current session data and invalidate the access token. The refresh token and client credentials
   * remain untouched.
   */
  logout: function (successCallback, errorCallback) {
    exec(successCallback, errorCallback, this.OG_CONSTANTS.CORDOVA_CLIENT, this.OG_CONSTANTS.LOGOUT, []);
    this.invalidateSessionState();
  },

  /**
   * Disconnect from the service, this will clear the refresh token and access token and remove session data.
   * Client credentials remain untouched.
   */
  disconnect: function (successCallback, errorCallback) {
    exec(successCallback, errorCallback, this.OG_CONSTANTS.CORDOVA_CLIENT, this.OG_CONSTANTS.DISCONNECT, []);
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
  checkPin: function (errorCallback, pin) {
    exec(null, function (error) {
    errorCallback(error);
    }, this.OG_CONSTANTS.CORDOVA_CLIENT, this.OG_CONSTANTS.PIN_CONFIRM_CURRENT, [pin]);
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
    }, this.OG_CONSTANTS.CORDOVA_CLIENT, this.OG_CONSTANTS.PIN_CONFIRM_NEW, [pin]);
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
      if (response.method == this.OG_CONSTANTS.PIN_ASK_FOR_NEW_FOR_CHANGE_REQUEST) {
        router.askForNewPinChangePinFlow();
      }
      else if (response.method == this.OG_CONSTANTS.PIN_ASK_FOR_CURRENT_FOR_CHANGE_REQUEST) {
        router.askForPinChangePinFlow();
      }
      else {
        router.changePinSuccess();
      }
    }, function (error) {
      router.changePinError(error);
    }, this.OG_CONSTANTS.CORDOVA_CLIENT, this.OG_CONSTANTS.PIN_CHANGE, []);
  },
  confirmCurrentPinForChangeRequest: function (errorCallback, pin) {
    exec(null, function (error) {
        console.log(error);
        if (errorCallback) {
          errorCallback(error);
        }
    },
        this.OG_CONSTANTS.CORDOVA_CLIENT, this.OG_CONSTANTS.PIN_CONFIRM_CURRENT_FOR_CHANGE_REQUEST, [pin]);
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
    }, this.OG_CONSTANTS.CORDOVA_CLIENT, this.OG_CONSTANTS.PIN_CONFIRM_NEW_FOR_CHANGE_REQUEST, [pin]);
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
    }, this.OG_CONSTANTS.CORDOVA_CLIENT, this.OG_CONSTANTS.PIN_VALIDATE, [pin]);
  },

  /**
   * Cancels started pin change flow and removes related session data.
   */
  cancelPinChange: function () {
    // not implemented in the base app yet
    exec(null, null, this.OG_CONSTANTS.CORDOVA_CLIENT, this.OG_CONSTANTS.PIN_CANCEL_CHANGE, []);
  },

  /**
   * Invalidates session storage data.
   */
  invalidateSessionState: function () {
    var length = sessionStorage.length;
    while(length--) {
      var key = sessionStorage.key(i);
      sessionStorage.removeItem(key);
    }
  },

  /**
   * Preserves in currently displayed page identifier in sessions storage.
   */
  preserveOriginLocaiton: function () {
    var activePage = $.mobile.activePage.attr("id");
    sessionStorage.setItem(this.OG_CONSTANTS.PAGE_OF_ORIGIN, activePage);
  },

  /**
   * List of constant values used in communication with OneginiCordovaPlugin.
   */
  OG_CONSTANTS: {
    PAGE_OF_ORIGIN: "origin_page",

    CORDOVA_CLIENT: "OneginiCordovaClient",

    INIT_WITH_CONFIG: "initWithConfig",

    AUTHORIZATION_AUTHORIZE: "authorize",
    AUTHORIZATION_REQUESTED: "requestAuthorization",
    AUTHORIZATION_SUCCESS: "authorizationSuccess",
    AUTHORIZATION_FAILURE: "authorizationFailure",

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
    PIN_ASK_FOR_CURRENT_FOR_CHANGE_REQUEST: "askCurrentPinForChangeRequest",
    PIN_ASK_FOR_NEW_FOR_CHANGE_REQUEST: "askNewPinForChangeRequest",
    PIN_CONFIRM_NEW_FOR_CHANGE_REQUEST: "confirmNewPinForChangeRequest",
    PIN_CONFIRM_CURRENT_FOR_CHANGE_REQUEST: "confirmCurrentPinForChangeRequest",
    PIN_CANCEL_CHANGE: "cancelPinChange",

    DISCONNECT: "disconnect",
    LOGOUT: "logout",

    FETCH_RESOURCE: "fetchResource",
    FETCH_ANONYMOUS_RESOURCE: "fetchAnonymousResource"
  }
};