cordova.define("com.onegini", function (require, exports, module) {
  module.exports = {

    /**
     * Initialize the OneginiClient. This should called first before any interaction with the Onegini SDK
     *
     * @param {JSON} config          JSON object with all configuration parameters
     * @param {Array} certificates          Array with base64 encoded X509 certificates used for SSL pinning.
     * @param {Function} completeCallback
     */
    initWithConfig: function (config, certificates, completeCallback) {
      exec(completeCallback, null, 'OneginiCordovaClient', 'initWithConfig', [config, certificates]);
    }
  };

});

// ogCordovaPlugin will be replaced with the proper plugin definition when we split up the app and the plugin
var ogCordovaPlugin = {
  fetchResource: function (successCallback, errorCallback, path, scopes, requestMethod, paramsEncoding, params) {
    cordova.exec(function (response) {
      if (successCallback) {
        successCallback(response);
      }
    }, function (error) {
      if (errorCallback) {
        errorCallback(error);
      }
    }, 'OneginiCordovaClient', 'fetchResource', [path, scopes, requestMethod, paramsEncoding, params]);
  },
  logout: function () {
    cordova.exec(null, null, 'OneginiCordovaClient', 'logout', null);
  },
  disconnect: function () {
    cordova.exec(null, null, 'OneginiCordovaClient', 'disconnect', null);
  },
  clearCredentials: function () {
    // FOR TESTING PURPOSE ONLY
    cordova.exec(null, null, 'OneginiCordovaClient', 'clearCredentials', null);
  },
  clearTokens: function () {
    // FOR TESTING PURPOSE ONLY
    cordova.exec(null, null, 'OneginiCordovaClient', 'clearTokens', null);
  },
  checkPin: function (errorCallback, pin) {
    // Callback is performed on the initiating authorize callback handler
    // An INVALID_ACTION is returned if no authorization transaction is registered.
    cordova.exec(null, function (error) {
      console.log("Fail! " + JSON.stringify(error));
      if (errorCallback) {
        errorCallback(error);
      }
    }, 'OneginiCordovaClient', 'confirmPin', [pin, true]);
  },
  setPin: function (errorCallback, pin, verifyPin) {
    // Callback is performed on the initiating authorize callback handler
    // An INVALID_ACTION is returned if no authorization transaction is registered.
    cordova.exec(null, function (error) {
      if (errorCallback) {
        errorCallback(error);
      }
    }, 'OneginiCordovaClient', 'confirmPinWithVerification', [pin, verifyPin, false]);
  },
  authorize: function (router, scopes) {
    cordova.exec(function (response) {
      /*
       The response method contains the name of the method in the OGAuthorizationDelegate protocol
       */
      if (response.method == 'requestAuthorization') {
        router.requestAuthorization(response.url);
      }
      else if (response.method == 'askForPin') {
        router.askForPin();
      }
      else if (response.method == 'askForPinWithVerification') {
        router.askForPinWithVerification();
      }
      else if (response == 'authorizationSuccess') {
        router.authorizationSuccess();
      }
    }, function (error) {
      router.authorizationFailure(error, scopes);
    }, 'OneginiCordovaClient', 'authorize', scopes);
  }
};