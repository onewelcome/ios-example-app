function AuthorizationRouter() {

  this.inAppBrowser = {};
  this.hasDisplayedAskForPin = false;

  this.openInAppBrowser = function (url) {
    this.inAppBrowser = window.open(url, '_blank', 'location=no,toolbar=no');
  };

  this.closeInAppBrowser = function () {
    if (this.inAppBrowser && this.inAppBrowser.close) {
      this.inAppBrowser.close();
    }
  };

  this.requestAuthorization = function (url) {
    this.closeInAppBrowser();
    this.openInAppBrowser(url);
  };

  this.askForPin = function () {
    this.closeInAppBrowser();

    if (this.hasDisplayedAskForPin === true) {
      // Within this authorization action, the askForPin was displayed before. We inform the user the PIN was invalid.
      $("#pinMessage").html('Invalid pin').enhanceWithin();
    }
    ogCordovaApp.navigation.navigateToPage("#askForPin");
    this.hasDisplayedAskForPin = true;
  };

  this.askForPinWithVerification = function () {
    this.closeInAppBrowser();
    ogCordovaApp.navigation.navigateToPage("#askForPinWithVerification");
  };

  this.authorizationSuccess = function () {
    this.closeInAppBrowser();
    ogCordovaApp.navigation.navigateToPage("#authorized");
  };

  this.authorizationFailure = function (error, scopes) {
    /*
     Possible error content

     The reason value corresponds with the OGAuthorizationDelegate protocol method.
     Consult protocol documentation for more information.

     The presence of any additional keys depend on the type of error.
     For example a PIN attempt failure includes a "remainingAttempts" key

     {"remainingAttempts":2,"reason":"authorizationErrorInvalidGrant"}
     */

    this.closeInAppBrowser();

    if (error && error.reason == "authorizationErrorInvalidGrant" && error.remainingAttempts > 0) {
      // Need to call the authorize again because the transaction is lost after an error callback in Cordova
      ogCordovaPlugin.authorize(this, scopes);
      return;
    }
    if (error && error.reason == "authorizationErrorTooManyPinFailures") {
      alert("Too many PIN attempts");
    }
    // For now, if something goes wrong and there are no "remainingAttempts", go home
    ogCordovaApp.navigation.navigateToHome();
  };
}
