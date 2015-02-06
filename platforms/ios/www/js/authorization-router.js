function AuthorizationRouter() {

  this.inAppBrowser = {};

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
    $.mobile.navigate("#askForPin");
  };

  this.askForPinWithVerification = function () {
    this.closeInAppBrowser();
    $.mobile.navigate("#askForPinWithVerification");
  };

  this.authorizationSuccess = function () {
    this.closeInAppBrowser();
    $.mobile.navigate("#authorized");
  };

  this.authorizationFailure = function (error) {
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
      $("#pinMessage").html('Invalid pin').enhanceWithin();
      return;
    }
    if (error && error.reason == "authorizationErrorTooManyPinFailures") {
      alert("Too many PIN attempts");
    }
    // For now, if something goes wrong and there are no "remainingattempts", go home
    $.mobile.navigate("#home");
  };
}
