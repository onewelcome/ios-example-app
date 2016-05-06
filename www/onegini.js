var exec = require('cordova/exec');

module.exports = {

  /**
   * Handles wrapped XmlHttpRequest responsible for fetching resources from onegini resource server. It gives possibility to load resources by calling standard
   * ajax request.
   * Attention! It take some time to prepare XmlHttpRequest because of internal configuration requests.
   *
   * With JQuery it will look like:
   *
   * // override XmlHttpRequest
   * var onCreated = function() {
   *   console.log(''wrapped xhr created);
   *   $.ajax({
   *     url: 'http://resource-server.com/my/resource',
   *     method: 'GET',
   *     success: function(response) {
   *       console.log('resource fetched');
   *     },
   *     fail: function(error) {
   *       console.log('fail to fetch resource');
   *     },
   *   });
   * };
   * // revert XmlHttpRequest if needed
   * oneginiCordovaPlugin.xmlHttpRequest.create(onCreated);
   * oneginiCordovaPlugin.xmlHttpRequest.revert();
   *
   */
  xmlHttpRequest: {

    ProxiedXMLHttpRequest: XMLHttpRequest,

    revert: function() {
      XMLHttpRequest = this.ProxiedXMLHttpRequest;
    },

    create: function(onCompleted) {
      var LocalProxiedXMLHttpRequest = this.ProxiedXMLHttpRequest;
      oneginiCordovaPlugin.readConfigProperty(oneginiCordovaPlugin.OG_CONSTANTS.RESOURCE_SERVER_BASE_URL_CONFIG_KEY, function(appBaseUrl) {
        create(appBaseUrl);
        onCompleted();
      });

      function create(appBaseUrl) {
        XMLHttpRequest = function () {
          var proxied = new LocalProxiedXMLHttpRequest();
          var proxy = this;
          var $path, $method, $status, $isRequestToResourceServer = true;

          proxy.open = function() {
            var _arguments = arguments;
            var requestUrl = _arguments[1];
            $isRequestToResourceServer = (function() {
              var start = requestUrl.indexOf(appBaseUrl);
              return start != -1;
            })();

            if ($isRequestToResourceServer) {
              $path = requestUrl.substring(appBaseUrl.length);
              $method = _arguments[0];
              return proxied.open.apply(proxied, _arguments);
            } else {
              ["status", "responseText", "readyState"].forEach(function (item) {
                Object.defineProperty(proxy, item, {
                  get: function () {
                    return proxied[item];
                  }
                });
              });
              return proxied.open.apply(proxied, _arguments);
            }
          };

          proxy.send = function () {
            if ($isRequestToResourceServer) {
              var prepareBody = function () {
                var requestBody = arguments[0];
                if (requestBody === null || requestBody === undefined) {
                  return JSON.parse("{}");
                }
                else {
                  return (JSON.parse(requestBody));
                }
              };
              var onResponse = function (headers, status, reason, requestUrl, body) {
                proxy.responseText = body;
                proxy.readyState = 4;
                proxy.status = status;
                proxied.onload.apply(proxied, arguments);
              };
              oneginiCordovaPlugin.fetchResource(onResponse, $path, $method, prepareBody());
            } else {
              return proxied.send.apply(proxied, arguments);
            }
          };

          ["statusText", "responseType", "response", "responseXML", "upload"].forEach(function (item) {
            Object.defineProperty(proxy, item, {
              get: function () {
                return proxied[item];
              }
            });
          });

          ["ontimeout", "timeout", "withCredentials", "onload", "onerror", "onprogress", "onreadystatechange"].forEach(function (item) {
            Object.defineProperty(proxy, item, {
              get: function () {
                return proxied[item];
              },
              set: function (val) {
                proxied[item] = val;
              }
            });
          });

          ["addEventListener", "abort", "getAllResponseHeaders", "getResponseHeader", "overrideMimeType", "setRequestHeader"].forEach(function (item) {
            Object.defineProperty(proxy, item, {
              value: function () {
                return proxied[item].apply(proxied, arguments);
              }
            });
          });
        }
      }
    }
  },

  /**
   * Awaits notification that the Onegini plugin initialization is finished.
   * @param {Object} router   Object that can handle page transition for the outcome of the action. Should at
   *                          least implement the following methods:
   *                          - pluginInitialized -> called once plugin is initialized successfully
   *                          - errorConnectivityProblem -> method called whenever plugin isn't able to establish
   *                          connection with the server
   *                          - initializationError -> called when other error occurred during plugin initialization
   */
  awaitPluginInitialization: function (router) {
    var onSuccess = function (response) {
      router.pluginInitialized();
    };

    var onError = function (error) {
      if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.CONNECTIVITY_PROBLEM) {
        router.errorConnectivityProblem();
      }
      else {
        router.initializationError();
      }
    };

    exec(onSuccess, onError, oneginiCordovaPlugin.OG_CONSTANTS.CORDOVA_CLIENT, oneginiCordovaPlugin.OG_CONSTANTS.AWAIT_PLUGIN_INITIALIZATION, []);
  },

  /**
   * Initiates static PIN callback session. Whenever SDK will require top level application to show PIN dialog,
   * it will use this session.
   * @param {Object} router   Object that can handle page transition for the outcome of the action. Should at
   *                          least implement the following methods:
   *                          - askForCurrentPin -> should display a screen to verify the PIN code. Must call
   *                                         checkPin(errorCallback, pin)
   *                          - askForNewPin -> should display a screen to set a PIN code. Must call
   *                                         setPin(errorCallback, pin, verifyPin)
   *                          - askForNewPinChangePinFlow -> should display a screen to set a PIN code. Must call
   *                                         confirmNewPinForChangeRequest(errorCallback, pin)
   *                          - askForPinChangePinFlow -> should display a screen to verify the PIN code. Must call
   *                                         confirmCurrentPinForChangeRequest(errorCallback, pin)
   *                          - pinCallbackInitFailed -> method called when PIN callback initialization fails
   */
  initPinCallbackSession: function (router) {
    var onSuccess = function (response) {
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
    };

    var onError = function (error) {
      router.pinCallbackInitFailed(error);
    };

    exec(onSuccess, onError, oneginiCordovaPlugin.OG_CONSTANTS.CORDOVA_CLIENT, oneginiCordovaPlugin.OG_CONSTANTS.INIT_PIN_CALLBACK_SESSION, []);
  },

  /**
   * Initiates static callback session to enable control over InAppBrowser from native code.
   * @param errorCallback
   */
  initInAppBrowserCallbackSession: function (errorCallback) {
    var onSuccess = function (response) {
      if (response.method == oneginiCordovaPlugin.OG_CONSTANTS.CLOSE_IN_APP_BROWSER) {
        oneginiCordovaPlugin.closeInAppBrowser();
      }
    };

    exec(onSuccess, errorCallback, oneginiCordovaPlugin.OG_CONSTANTS.CORDOVA_CLIENT, oneginiCordovaPlugin.OG_CONSTANTS.INIT_IN_APP_BROWSER_CONTROL_SESSION, []);

  },

  /**
   * Fetches a specific resource.
   *
   * @param onResponse                  Callback method executed on success, should have definition like this:
   *                                    - onResponse(headers, status, reason, requestUrl, body);
   * @param {String} path               Location on the resource server to return the resource. The base URI of the
   *                                    resource server is.
   * @param {String} requestMethod      HTTP request method to retrieve the resource: 'GET', 'PUT', 'POST' or 'DELETE'
   * @param {Object} params             Parameters to send with the request.
   * @param {Object} headers            Optional custom headers to send with the request.
   */
  fetchResource: function (onResponse, path, requestMethod, params, headers) {
    oneginiCordovaPlugin.preserveCurrentLocation();

    var methodArgs = [path, requestMethod, params, headers];

    var responseCallback = function(response) {
      var headers = JSON.stringify(response.headers);
      var status = JSON.stringify(response.status);
      var reason = JSON.stringify(response.reason);
      var requestUrl = JSON.stringify(response.url);
      var body = window.atob(response.body);

      onResponse(headers, status, reason, requestUrl, body);
    };

    exec(responseCallback, responseCallback, oneginiCordovaPlugin.OG_CONSTANTS.CORDOVA_CLIENT, oneginiCordovaPlugin.OG_CONSTANTS.FETCH_RESOURCE, methodArgs);
  },

  /**
   * Fetches a specific resource anonymously.
   *
   * @param onResponse                  Callback method executed on success, should have definition like this:
   *                                    - onResponse(headers, status, reason, requestUrl, body);
   * @param {String} path               Location on the resource server to return the resource. The base URI of the
   *                                    resource server is.
   * @param {String} requestMethod      HTTP request method to retrieve the resource: 'GET', 'PUT', 'POST' or 'DELETE'
   * @param {Object} params             Parameters to send with the request.
   * @param {Object} headers            Optional custom headers to send with the request.
   */
  fetchAnonymousResource: function (onResponse, path, requestMethod, params, headers) {
    oneginiCordovaPlugin.preserveCurrentLocation();

    var methodArgs = [path, requestMethod, params, headers];

    var responseCallback = function(response) {
      var headers = JSON.stringify(response.headers);
      var status = JSON.stringify(response.status);
      var reason = JSON.stringify(response.reason);
      var requestUrl = JSON.stringify(response.url);
      var body = window.atob(response.body);

      onResponse(headers, status, reason, requestUrl, body);
    };

    exec(responseCallback, responseCallback, oneginiCordovaPlugin.OG_CONSTANTS.CORDOVA_CLIENT, oneginiCordovaPlugin.OG_CONSTANTS.FETCH_ANONYMOUS_RESOURCE, methodArgs);
  },

  /**
   * Enrolls the currently connected device for mobile push authentication.
   *
   * @param {Object} router   Object that can handle page transition for the outcome of the action. Should at
   *                          least implement the following methods:
   *                          - enrollmentSuccess -> enrollment success
   *                          - error -> generic enrollment error handler
   *                          - errorAuthenticationError -> failed to authenticate the user for enrollment
   *                          - errorDeviceAlreadyEnrolled -> the device is already enrolled
   *                          - errorInvalidClientCredentials -> provided client credentials are invalid
   *                          - errorInvalidRequest -> one or more request parameters missing
   *                          - errorInvalidTransaction -> the transaction id used during enrollment is invalid, probably because the transaction validity period is expired
   *                          - errorNotAvailable -> enrollment for mobile authentication is currently disabled
   *                          - errorUserAlreadyEnrolled -> user is already enrolled for mobile authentication
   * @param {Array} scopes    {Array} with {String}s that represent the scopes for the access token
   */
  enrollForMobileAuthentication: function (router, scopes) {
    var onSuccess = function (response) {
        router.enrollmentSuccess();
    };

    var onError = function (error) {
      if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.MOBILE_AUTHENTICATION_ENROLLMENT_ERROR_AUTHENTICATION_ERROR) {
        router.errorAuthenticationError();
      }
      else if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.MOBILE_AUTHENTICATION_ENROLLMENT_ERROR_DEVICE_ALREADY_ENROLLED) {
        router.errorDeviceAlreadyEnrolled();
      }
      else if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.MOBILE_AUTHENTICATION_ENROLLMENT_ERROR_INVALID_CLIENT_CREDENTIALS) {
        router.errorInvalidClientCredentials();
      }
      else if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.MOBILE_AUTHENTICATION_ENROLLMENT_ERROR_INVALID_REQUEST) {
        router.errorInvalidRequest();
      }
      else if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.MOBILE_AUTHENTICATION_ENROLLMENT_ERROR_INVALID_TRANSACTION) {
        router.errorInvalidTransaction();
      }
      else if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.MOBILE_AUTHENTICATION_ENROLLMENT_ERROR_NOT_AVAILABLE) {
        router.errorNotAvailable();
      }
      else if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.MOBILE_AUTHENTICATION_ENROLLMENT_ERROR_USER_ALREADY_ENROLLED) {
        router.errorUserAlreadyEnrolled();
      }
      else {
        router.error();
      }
    };
    var methodArgs;
    if (scopes && scopes.length > 0) {
      methodArgs = [scopes];
    } else {
      methodArgs = [];
    }
    exec(onSuccess, onError, oneginiCordovaPlugin.OG_CONSTANTS.CORDOVA_CLIENT, oneginiCordovaPlugin.OG_CONSTANTS.MOBILE_AUTHENTICATION_ENROLL, methodArgs);
  },


  /**
   * Enrolls the currently connected device for fingerprint authentication.
   *
   * @param {Object} router   Object that can handle page transition for the outcome of the action. Should at
   *                          least implement the following methods:
   *                          - enrollmentSuccess -> enrollment success
   *                          - error -> generic enrollment error handler
   *                          - errorTooManyPinAttempts -> method called once user exceeds allowed number of PIN attempts
   */
  enrollForFingerprintAuthentication: function (router) {
    var onSuccess = function (response) {
      router.enrollmentSuccess();
    };

    var onError = function (error) {
      if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.FINGERPRINT_ENROLMENT_FAILURE_TOO_MANY_PIN_ATTEMPTS) {
        router.errorTooManyPinAttempts();
      }
      else if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.FINGERPRINT_ENROLMENT_FAILURE) {
        router.error();
      }
    }
    exec(onSuccess, onError, oneginiCordovaPlugin.OG_CONSTANTS.CORDOVA_CLIENT, oneginiCordovaPlugin.OG_CONSTANTS.FINGERPRINT_ENROLL_FOR_FINGERPRINT_AUTHENTICATION, []);
  },

  disableFingerprintAuthentication: function() {
    exec(null, null, oneginiCordovaPlugin.OG_CONSTANTS.CORDOVA_CLIENT, oneginiCordovaPlugin.OG_CONSTANTS.FINGERPRINT_AUTHENTICATION_DISABLE, []);
  },

  checkFingerpringAuthenticationState: function(fingerprintEnabledCallback, fingerprintDisabledCallback) {
    var onFingerprintEnabledCallback = function () {
      fingerprintEnabledCallback();
    };
    var onFingerprintDisabledCallback = function () {
      fingerprintDisabledCallback();
    };
    exec(onFingerprintEnabledCallback, onFingerprintDisabledCallback, oneginiCordovaPlugin.OG_CONSTANTS.CORDOVA_CLIENT, oneginiCordovaPlugin.OG_CONSTANTS.FINGERPRINT_AUTHENTICATION_STATE, []);
  },

  /**
   * Determine if the user is registered.
   *
   * @param successCallback   Function to be called when user is already registered
   * @param errorCallback     Function to be called when user is not yet registered
   */
  isRegistered: function (successCallback, errorCallback) {
    var onSuccess = function (response) {
      successCallback();
    };
    var onError = function (error) {
      errorCallback();
    };

    exec(onSuccess, onError, oneginiCordovaPlugin.OG_CONSTANTS.CORDOVA_CLIENT, oneginiCordovaPlugin.OG_CONSTANTS.IS_REGISTERED, []);
  },

  /**
   * Main entry point into the authorization process.
   *
   * @param {Object} router   Object that can handle page transition for the outcome of the action. Should at
   *                          least implement the following methods:
   *                          - requestAuthorization(url) -> redirects the user to the given url to log in
   *                          - authorizationSuccess -> should show the landing page for the authenticated user
   *                          - errorInvalidCurrentPin(remainingAttempts, scopes) -> indicates that the entered PIN
   *                          number was invalid and provides an information about remaining PIN attempts
   *                          - errorTooManyPinAttempts -> method called once user exceeds allowed number of PIN
   *                          attempts
   *                          - errorRegistrationFailed -> invoked when client registration fails
   *                          - errorConnectivityProblem -> method called whenever plugin isn't able to establish
   *                          connection with the server
   *                          - errorNotAuthenticated -> invoked when client credentials are invalid
   *                          - errorNotAuthorized -> called when client was not authorized to perform action
   *                          - errorInvalidScope -> one or more of the scopes requested authorization for were not
   *                          available
   *                          - errorInvalidState -> the state parameter in the authorization request is different than
   *                          the value in the callback. This indicates a possible man in the middle attack.
   *                          - errorInvalidRequest -> method called when one or more required parameters were missing
   *                          in the authorization request.
   *                          - errorInvalidGrant -> called when access grant or refresh token was invalid
   *                          - errorUnsupportedAppVersion -> invoked when application version is not valid and update
   *                          is needed
   *                          - errorPinForgotten -> invoked when user clicked "I forgot my PIN" button
   * @param {Array} scopes    {Array} with {String}s that represent the scopes for the access token
   */
  authorize: function (router, scopes) {
    new AuthorizationAction(oneginiCordovaPlugin).authorize(router, scopes);
  },

  /**
   * Starts authentication flow regardless if the application contains the AccessToken.
   *
   * @param {Object} router   Object that can handle page transition for the outcome of the action. Should at
   *                          least implement the following methods:
   *                          - requestAuthorization(url) -> redirects the user to the given url to log in
   *                          - authorizationSuccess -> should show the landing page for the authenticated user
   *                          - errorInvalidCurrentPin(remainingAttempts, scopes) -> indicates that the entered PIN
   *                          number was invalid and provides an information about remaining PIN attempts
   *                          - errorTooManyPinAttempts -> method called once user exceeds allowed number of PIN
   *                          attempts
   *                          - errorRegistrationFailed -> invoked when client registration fails
   *                          - errorConnectivityProblem -> method called whenever plugin isn't able to establish
   *                          connection with the server
   *                          - errorNotAuthenticated -> invoked when client credentials are invalid
   *                          - errorNotAuthorized -> called when client was not authorized to perform action
   *                          - errorInvalidScope -> one or more of the scopes requested authorization for were not
   *                          available
   *                          - errorInvalidState -> the state parameter in the authorization request is different than
   *                          the value in the callback. This indicates a possible man in the middle attack.
   *                          - errorInvalidRequest -> method called when one or more required parameters were missing
   *                          in the authorization request.
   *                          - errorInvalidGrant -> called when access grant or refresh token was invalid
   *                          - errorUnsupportedAppVersion -> invoked when application version is not valid and update
   *                          is needed
   *                          - errorPinForgotten -> invoked when user clicked "I forgot my PIN" button
   * @param {Array} scopes    {Array} with {String}s that represent the scopes for the access token
   */
  reauthorize: function (router, scopes) {
    new AuthorizationAction(oneginiCordovaPlugin).reauthorize(router, scopes);
  },

  /**
   * This will remove current session data and invalidate the access token. The refresh token and client credentials
   * remain untouched.
   *
   * @param successCallback   Function to be called once user is successfully logged out
   * @param errorCallback     Function to be called when logout action fails
   */
  logout: function (successCallback, errorCallback) {
    var onSuccess = function (response) {
      successCallback();
    };
    exec(onSuccess, errorCallback, oneginiCordovaPlugin.OG_CONSTANTS.CORDOVA_CLIENT, oneginiCordovaPlugin.OG_CONSTANTS.LOGOUT, []);
  },

  /**
   * Disconnect from the service, this will clear the refresh token and access token and remove session data.
   * Client credentials remain untouched.
   *
   * @param successCallback   Function to be called once disconnect action succeed
   * @param errorCallback     Function to be called when disconnection fails
   */
  disconnect: function (successCallback, errorCallback) {
    var onSuccess = function (response) {
      successCallback();
    };
    exec(onSuccess, errorCallback, oneginiCordovaPlugin.OG_CONSTANTS.CORDOVA_CLIENT, oneginiCordovaPlugin.OG_CONSTANTS.DISCONNECT, []);
    oneginiCordovaPlugin.invalidateSessionState();
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
    var onSuccess = function (response) {
      successCallback();
    };
    exec(onSuccess, errorCallback, oneginiCordovaPlugin.OG_CONSTANTS.CORDOVA_CLIENT, oneginiCordovaPlugin.OG_CONSTANTS.PIN_CONFIRM_CURRENT, [pin]);
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
    var onError = function (error) {
      console.log(error);
      errorCallback(error);
    };

    exec(null, onError, oneginiCordovaPlugin.OG_CONSTANTS.CORDOVA_CLIENT, oneginiCordovaPlugin.OG_CONSTANTS.PIN_CONFIRM_NEW, [pin]);
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
   *                          in change PIN flow
   *                          - tooManyPinAttempts -> method called once user exceeds allowed number of PIN attempts
   *                          - errorConnectivityProblem -> method called whenever plugin isn't able to establish
   *                          connection with the server
   *                          - errorPinForgotten -> invoked when user clicked "I forgot my PIN" button
   */
  changePin: function (router) {
    var onSuccess = function (response) {
      router.changePinSuccess();
    };

    var onError = function (error) {
      if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.PIN_INVALID) {
        router.errorInvalidCurrentPin(error.remainingAttempts);
      }
      else if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.PIN_CHANGE_ERROR_TOO_MANY_ATTEMPTS) {
        router.errorTooManyPinAttempts();
      }
      else if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.PIN_CHANGE_ERROR) {
        router.errorChangingPin();
      }
      else if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.CONNECTIVITY_PROBLEM) {
        router.errorConnectivityProblem();
      }
      else if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.AUTHORIZATION_ERROR_PIN_FORGOTTEN) {
        router.errorPinForgotten();
      }
    };

    exec(onSuccess, onError, oneginiCordovaPlugin.OG_CONSTANTS.CORDOVA_CLIENT, oneginiCordovaPlugin.OG_CONSTANTS.PIN_CHANGE, []);
  },

  /**
   * Verifies if entered PIN is currently valid, if true proceeds with new PIN creation in change PIN flow.
   *
   * @param errorCallback   Function to call when PIN verification fails
   * @param pin             Entered PIN number
   */
  confirmCurrentPinForChangeRequest: function (errorCallback, pin) {
    var onError = function (error) {
      console.log(error);
      if (errorCallback) {
        errorCallback(error);
      }
    };

    exec(null, onError, oneginiCordovaPlugin.OG_CONSTANTS.CORDOVA_CLIENT, oneginiCordovaPlugin.OG_CONSTANTS.PIN_CONFIRM_CURRENT_FOR_CHANGE_REQUEST, [pin]);
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
   * @param {object} router   Object that can handle PIN verification failure. Should at least implement the
   *                          following methods:
   *                          - pinBlackListed -> entered PIN is black listed
   *                          - pinShouldNotBeASequence -> PIN cannot contain a sequence
   *                          - pinShouldNotUseSimilarDigits with maxSimilarDigits key -> PIN can contain only
   *                                         'maxSimilarDigits' same digits
   *                          - pinTooShort -> entered PIN is too short
   *                          - pinEntryError -> PIN retrieval error
   * @param {String} pin      The PIN code to set
   */
  confirmNewPinForChangeRequest: function (router, pin) {
    var onError = function (error) {
      if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.PIN_BLACK_LISTED) {
        router.pinBlackListed();
      }
      else if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.PIN_SHOULD_NOT_BE_A_SEQUENCE) {
        router.pinShouldNotBeASequence();
      }
      else if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.PIN_SHOULD_NUT_USE_SIMILAR_DIGITS) {
        router.pinShouldNotUseSimilarDigits();
      }
      else if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.PIN_TOO_SHORT) {
        router.pinTooShort();
      }
      else if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.PIN_ENTRY_ERROR) {
        router.pinEntryError();
      }
    };

    exec(null, onError, oneginiCordovaPlugin.OG_CONSTANTS.CORDOVA_CLIENT, oneginiCordovaPlugin.OG_CONSTANTS.PIN_CONFIRM_NEW_FOR_CHANGE_REQUEST, [pin]);
  },

  /**
   * Validates provided PIN number against clients pin policy.
   *
   * @param {object} router   Object that can handle PIN verification failure. Should at least implement the
   *                          following methods:
   *                          - pinValid -> PIN validation succeeded
   *                          - pinBlackListed -> entered PIN is black listed
   *                          - pinShouldNotBeASequence -> PIN cannot contain a sequence
   *                          - pinShouldNotUseSimilarDigits with maxSimilarDigits key -> PIN can contain only
   *                                         'maxSimilarDigits' same digits
   *                          - pinTooShort -> entered PIN is too short
   *                          - pinEntryError -> PIN retrieval error
   * @param {String} pin      The PIN code to set
   */
  validatePin: function (router, pin) {
    var onSuccess = function (response) {
      router.pinValid(pin);
    };

    var onError = function (error) {
      if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.PIN_BLACK_LISTED) {
        router.pinBlackListed();
      }
      else if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.PIN_SHOULD_NOT_BE_A_SEQUENCE) {
        router.pinShouldNotBeASequence();
      }
      else if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.PIN_SHOULD_NUT_USE_SIMILAR_DIGITS) {
        router.pinShouldNotUseSimilarDigits(error.maxSimilarDigits);
      }
      else if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.PIN_TOO_SHORT) {
        router.pinTooShort();
      }
      else if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.PIN_ENTRY_ERROR) {
        router.pinEntryError();
      }
    };

    exec(onSuccess, onError, oneginiCordovaPlugin.OG_CONSTANTS.CORDOVA_CLIENT, oneginiCordovaPlugin.OG_CONSTANTS.PIN_VALIDATE, [pin]);
  },

  /**
   * Cancels started pin change flow and removes related session data.
   */
  cancelPinChange: function () {
    // not implemented in the base app yet
    exec(null, null, oneginiCordovaPlugin.OG_CONSTANTS.CORDOVA_CLIENT, oneginiCordovaPlugin.OG_CONSTANTS.PIN_CANCEL_CHANGE, []);
  },


  /**
   * Detect and lock in prefered screen orientation
   * (tablet in landscape, phone in portrait)
   */
  setupScreenOrientation: function () {
    exec(null, null, oneginiCordovaPlugin.OG_CONSTANTS.CORDOVA_CLIENT, oneginiCordovaPlugin.OG_CONSTANTS.SETUP_SCREEN_ORIENTATION, []);
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
    oneginiCordovaPlugin.shouldRestoreSessionData = false;
  },

  /**
   * Preserves currently displayed page identifier in sessions storage.
   */
  preserveCurrentLocation: function () {
    var activePage = $.mobile.activePage.attr("id");
    oneginiCordovaPlugin.preserveLocation(activePage);
  },

  /**
   * Preserves specified page identifier in sessions storage.
   */
  preserveLocation: function (pageId) {
    sessionStorage.setItem(oneginiCordovaPlugin.OG_CONSTANTS.PAGE_OF_ORIGIN, pageId);
    oneginiCordovaPlugin.shouldRestoreSessionData = true;
  },

  inAppBrowser: {},

  /**
   * Opens specified URL using inAppBrowser, should be used only if inAppBrowser plugin is active.
   * @param url   URL to open
   */
  openInAppBrowser: function (url) {
    oneginiCordovaPlugin.inAppBrowser = window.open(url, '_blank', 'location=no,toolbar=no,clearcache=yes,hardwareback=no,dismissablewithbackbutton=no');
  },

  /**
   * Closes inAppBrowser.
   */
  closeInAppBrowser: function () {
    if (!oneginiCordovaPlugin.inAppBrowser) {
      return;
    }
    if (oneginiCordovaPlugin.isAndroid() && oneginiCordovaPlugin.inAppBrowser.hide) {
      oneginiCordovaPlugin.inAppBrowser.open("about:blank", '_blank', 'location=no,toolbar=no,clearcache=yes');
      oneginiCordovaPlugin.inAppBrowser.hide();
    }
    else if (oneginiCordovaPlugin.isiOS() && oneginiCordovaPlugin.inAppBrowser.close) {
      oneginiCordovaPlugin.inAppBrowser.close();
    }
  },

  /**
   * Determines whenever userAgent is Android.
   * @returns {boolean}
   */
  isAndroid: function () {
    return navigator.userAgent.indexOf("Android") > 0;
  },

  /**
   * Determines whenever userAgent is iOS.
   * @returns {boolean}
   */
  isiOS: function () {
    return ( navigator.userAgent.indexOf("iPhone") > 0 || navigator.userAgent.indexOf("iPad") > 0 || navigator.userAgent.indexOf("iPod") > 0);
  },

  readConfigProperty: function(propertyKey, onFetched) {
    var onSuccess = function(propertyValue) {
      onFetched(propertyValue);
    };
    var onError = function(propertyValue) {
      onFetched(propertyValue);
    };
    var methodArgs = [propertyKey];
    exec(onSuccess, onError, oneginiCordovaPlugin.OG_CONSTANTS.CORDOVA_CLIENT, oneginiCordovaPlugin.OG_CONSTANTS.READ_CONFIG_PROPERTY_ACTION, methodArgs);
  },

  /**
   * List of constant values used in communication with OneginiCordovaPlugin.
   */
  OG_CONSTANTS: {
    PAGE_OF_ORIGIN: "origin_page",

    CORDOVA_CLIENT: "OneginiCordovaClient",

    AWAIT_PLUGIN_INITIALIZATION: "awaitPluginInitialization",
    INIT_PIN_CALLBACK_SESSION: "initPinCallbackSession",
    INIT_IN_APP_BROWSER_CONTROL_SESSION: "inAppBrowserControlSession",
    CLOSE_IN_APP_BROWSER: "closeInAppBrowser",

    CONNECTIVITY_PROBLEM: "connectivityProblem",
    UNSUPPORTED_APP_VERSION: "unsupportedAppVersion",

    IS_REGISTERED: "isRegistered",

    AUTHORIZATION_AUTHORIZE: "authorize",
    AUTHORIZATION_REAUTHORIZE: "reauthorize",
    AUTHORIZATION_REQUESTED: "requestAuthorization",
    AUTHORIZATION_SUCCESS: "authorizationSuccess",
    AUTHORIZATION_FAILURE: "authorizationFailure",
    AUTHORIZATION_ERROR_INVALID_PIN: "authorizationErrorInvalidGrant",
    AUTHORIZATION_ERROR_TOO_MANY_PIN_ATTEMPTS: "authorizationErrorTooManyPinFailures",
    AUTHORIZATION_ERROR_CLIENT_REGISTRATION_FAILED: "authorizationErrorClientRegistrationFailed",
    AUTHORIZATION_ERROR_NOT_AUTHENTICATED: "authorizationErrorNotAuthenticated",
    AUTHORIZATION_ERROR_INVALID_SCOPE: "authorizationErrorInvalidScope",
    AUTHORIZATION_ERROR_INVALID_STATE: "authorizationErrorInvalidState",
    AUTHORIZATION_ERROR_NOT_AUTHORIZED: "authorizationErrorNotAuthorized",
    AUTHORIZATION_ERROR_INVALID_REQUEST: "authorizationErrorInvalidRequest",
    AUTHORIZATION_ERROR_INVALID_GRANT_TYPE: "authorizationErrorInvalidGrantType",
    AUTHORIZATION_ERROR_PIN_FORGOTTEN: "authorizationErrorPinForgotten",

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

    FETCH_RESOURCE: "fetchResource",
    FETCH_ANONYMOUS_RESOURCE: "fetchAnonymousResource",
    RESOURCE_CALL_ERROR: "resourceCallError",
    RESOURCE_CALL_AUTH_FAILED: "resourceErrorAuthenticationFailed",
    RESOURCE_CALL_SCOPE_ERROR: "scopeError",
    RESOURCE_CALL_BAD_REQUEST: "resourceBadRequest",
    RESOURCE_CALL_UNAUTHORIZED: "unauthorizedClient",
    RESOURCE_CALL_INVALID_GRANT: "invalidGrant",

    SETUP_SCREEN_ORIENTATION: "setupScreenOrientation",

    MOBILE_AUTHENTICATION_ENROLL: "enrollForMobileAuthentication",
    MOBILE_AUTHENTICATION_ENROLLMENT_SUCCESS: "enrollmentSuccess",
    MOBILE_AUTHENTICATION_ENROLLMENT_ERROR: "enrollmentError",
    MOBILE_AUTHENTICATION_ENROLLMENT_ERROR_NOT_AVAILABLE: "enrollmentErrorNotAvailable",
    MOBILE_AUTHENTICATION_ENROLLMENT_ERROR_INVALID_REQUEST: "enrollmentErrorInvalidRequest",
    MOBILE_AUTHENTICATION_ENROLLMENT_ERROR_INVALID_TRANSACTION: "enrollmentErrorInvalidTransaction",
    MOBILE_AUTHENTICATION_ENROLLMENT_ERROR_AUTHENTICATION_ERROR: "enrollmentErrorAuthenticationError",
    MOBILE_AUTHENTICATION_ENROLLMENT_ERROR_USER_ALREADY_ENROLLED: "enrollmentErrorUserAlreadyEnrolled",
    MOBILE_AUTHENTICATION_ENROLLMENT_ERROR_DEVICE_ALREADY_ENROLLED: "enrollmentErrorDeviceAlreadyEnrolled",
    MOBILE_AUTHENTICATION_ENROLLMENT_ERROR_INVALID_CLIENT_CREDENTIALS: "enrollmentErrorInvalidClientCredentials",

    FINGERPRINT_AUTHENTICATION_STATE: "checkFingerpringAuthenticationState",
    FINGERPRINT_AUTHENTICATION_DISABLE: "disableFingerprintAuthentication",
    FINGERPRINT_ENROLL_FOR_FINGERPRINT_AUTHENTICATION: "enrollForFingerprintAuthentication",
    FINGERPRINT_ENROLMENT_SUCCESS: "fingerprint_enrolment_success",
    FINGERPRINT_ENROLMENT_FAILURE: "fingerprint_enrolment_failure",
    FINGERPRINT_ENROLMENT_FAILURE_TOO_MANY_PIN_ATTEMPTS: "fingerprint_enrolment_failure_too_many_attempts",

    READ_CONFIG_PROPERTY_ACTION: "readConfigProperty",

    RESOURCE_SERVER_BASE_URL_CONFIG_KEY: "kOGResourceBaseURL"
  }
};

function AuthorizationAction(oneginiCordovaPlugin) {
  var authorize = function(authorizationType) {
    return function (router, scopes) {
      var onSuccess = function (response) {
        /*
         The response method contains the name of the method in the OGAuthorizationDelegate protocol
         */
        if (response == oneginiCordovaPlugin.OG_CONSTANTS.AUTHORIZATION_SUCCESS) {
          router.authorizationSuccess();
        }
        else if (response.method == oneginiCordovaPlugin.OG_CONSTANTS.AUTHORIZATION_REQUESTED) {
          router.requestAuthorization(response.url);
        }
      };

      var onError = function (error) {
        if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.AUTHORIZATION_ERROR_INVALID_PIN) {
          router.errorInvalidCurrentPin(error.remainingAttempts, scopes);
        }
        else if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.AUTHORIZATION_ERROR_TOO_MANY_PIN_ATTEMPTS) {
          router.errorTooManyPinAttempts();
        }
        else if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.AUTHORIZATION_ERROR_CLIENT_REGISTRATION_FAILED) {
          router.errorRegistrationFailed();
        }
        else if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.CONNECTIVITY_PROBLEM) {
          router.errorConnectivityProblem();
        }
        else if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.AUTHORIZATION_ERROR_NOT_AUTHENTICATED) {
          router.errorNotAuthenticated();
        }
        else if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.AUTHORIZATION_ERROR_NOT_AUTHORIZED) {
          router.errorNotAuthorized();
        }
        else if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.AUTHORIZATION_ERROR_INVALID_SCOPE) {
          router.errorInvalidScope();
        }
        else if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.AUTHORIZATION_ERROR_INVALID_STATE) {
          router.errorInvalidState();
        }
        else if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.AUTHORIZATION_ERROR_INVALID_REQUEST) {
          router.errorInvalidRequest();
        }
        else if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.AUTHORIZATION_ERROR_INVALID_GRANT_TYPE) {
          router.errorInvalidGrant();
        }
        else if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.UNSUPPORTED_APP_VERSION) {
          router.errorUnsupportedAppVersion();
        }
        else if (error.reason == oneginiCordovaPlugin.OG_CONSTANTS.AUTHORIZATION_ERROR_PIN_FORGOTTEN) {
          router.errorPinForgotten();
        }
      };
      var methodArgs;
      if (scopes && scopes.length > 0) {
        methodArgs = [scopes];
      }
      else {
        methodArgs = [];
      }
      exec(onSuccess, onError, oneginiCordovaPlugin.OG_CONSTANTS.CORDOVA_CLIENT, authorizationType, methodArgs);
    }
  };

  return {
    authorize: authorize(oneginiCordovaPlugin.OG_CONSTANTS.AUTHORIZATION_AUTHORIZE),
    reauthorize: authorize(oneginiCordovaPlugin.OG_CONSTANTS.AUTHORIZATION_REAUTHORIZE)
  }
}