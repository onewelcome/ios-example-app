var ogCordovaApp = {};

ogCordovaApp.app = {
  name: 'Onegini',
  // Application Constructor
  initialize: function () {
    this.bindEvents();
  },
  bindEvents: function () {
    document.addEventListener('deviceready', this.onDeviceReady, false);
    document.addEventListener('pause', this.pauseApp, false);
    document.addEventListener('resign', this.pauseApp, false); // iOS specific event when locking the app
    document.addEventListener('resume', this.showHome, false);
  },
  bindButtons: function () {
    var app = this;
    $("[data-btn-role='btnLogin']").on("click", function (e) {
      e.preventDefault();
      app.authorize();
    });

    $("[data-btn-role='btnLogout']").on("click", function (e) {
      e.preventDefault();
      app.logout();
      app.showHome();
    });

    $("[data-btn-role='btnDisconnect']").on("click", function (e) {
      e.preventDefault();
      var disconnectAndGoHome = function (buttonIndex) {
        if (buttonIndex == 1) {
          app.disconnect();
          app.showHome();
        }
      };
      app.confirm("Do you want to disconnect the app?", disconnectAndGoHome);
    });

    $("#fetchProfile").on("click", function (e) {
      e.preventDefault();
      ogCordovaApp.plugin.fetchResource(app.showResource, app.handleResourceError,
          '/client/resource/profile', ['read'], 'GET', 'JSON', {});
    });
  },
  bindForms: function () {
    var app = this;

    $("#askForPinForm").validate({
      rules: {
        pin: {
          required: true,
          digits: true,
          minlength: 5
        }
      },
      errorPlacement: function (error, element) {
        error.insertAfter(element.parent());
      },
      submitHandler: function (form) {
        console.log("Submitting PIN form");
        var pinValue = $("#pin").val();
        // clear form in case we return to this page
        form.reset();
        $("#pinMessage").html('').enhanceWithin();
        app.askForPinResponse(pinValue, false);
      }
    });
    $("#askForPinWithVerificationForm").validate({
      rules: {
        pinWithVerification: {
          required: true,
          digits: true,
          minlength: 5
        },
        pinVerification: {
          required: true,
          digits: true,
          minlength: 5,
          equalTo: "#pinWithVerification"
        }
      },
      errorPlacement: function (error, element) {
        error.insertAfter(element.parent());
      },
      submitHandler: function (form) {
        console.log("Submitting PIN with verification form");
        var pinValue = $("#pinWithVerification").val();
        var verifyPinValue = $("#pinVerification").val();
        // clear form in case we return to this page
        form.reset();
        $("#pinWithVerificationMessage").html('').enhanceWithin();
        app.askForPinWithVerificationResponse(pinValue, verifyPinValue, false);
      }
    });
  },
  // onDeviceReady: internal call from an event handler. The scope of 'this' is the event, not ogCordova.app.
  onDeviceReady: function () {
    var app = ogCordovaApp.app;
    app.initWithConfig();
    app.bindButtons();
    app.bindForms();
    app.errorMessage = Handlebars.compile($("#errorMessage").html());
    app.profile = Handlebars.compile($("#profile").html());
    $(":mobile-pagecontainer").on("pagecontainerbeforehide", function (event, ui) {
      app.clearDynamicContent();
    });
  },
  pauseApp: function () {
    this.logout();
    $.mobile.navigate("#paused");
  },
  showHome: function () {
    $.mobile.navigate("#home");
  },
  confirm: function (message, callback) {
    if (navigator.notification) {
      navigator.notification.confirm(message, callback);
    }
    else {
      if (window.confirm(message)) {
        callback(1);
      }
    }
  },
  initWithConfig: function () {
    cordova.exec(function (response) {
          console.log(response);
        }, function (error) {
        },
        'OneginiCordovaClient',
        'initWithConfig',
        [{
          'kOGAppIdentifier': 'DemoApp-2-4',
          'kOGAppPlatform': 'ios',
          'kOGAppScheme': 'oneginisdk',
          'kOGAppVersion': '2.4',
          'kAppBaseURL': 'https://beta-tokenserver.onegini.com',
          'kOGShouldConfirmNewPin': true,
          'kOGShouldDirectlyShowPushMessage': true,
          'kOGKeyStorePassword': 'NotSoVerySecureYet',
          'kOGMaxPinFailures': '3',
          'kOGResourceBaseURL': 'https://beta-tokenserver.onegini.com',
          'kOGRedirectURL': 'oneginisdk://loginsuccess',
          'kOGUseEmbeddedWebview': true
        }, ['MIIE5TCCA82gAwIBAgIQB28SRoFFnCjVSNaXxA4AGzANBgkqhkiG9w0BAQUFADBvMQswCQYDVQQGEwJTRTEUMBIGA1UEChMLQWRkVHJ1c3QgQUIxJjAkBgNVBAsTHUFkZFRydXN0IEV4dGVybmFsIFRUUCBOZXR3b3JrMSIwIAYDVQQDExlBZGRUcnVzdCBFeHRlcm5hbCBDQSBSb290MB4XDTEyMDIxNjAwMDAwMFoXDTIwMDUzMDEwNDgzOFowczELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxGTAXBgNVBAMTEFBvc2l0aXZlU1NMIENBIDIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDo6jnjIqaqucQA0OeqZztDB71Pkuu8vgGjQK3g70QotdA6voBUF4V6a4RsNjbloyTi/igBkLzX3Q+5K05IdwVpr95XMLHo+xoD9jxbUx6hAUlocnPWMytDqTcyUg+uJ1YxMGCtyb1zLDnukNh1sCUhYHsqfwL9goUfdE+SNHNcHQCgsMDqmOK+ARRYFygiinddUCXNmmym5QzlqyjDsiCJ8AckHpXCLsDl6ez2PRIHSD3SwyNWQezT3zVLyOf2hgVSEEOajBd8i6q8eODwRTusgFX+KJPhChFo9FJXb/5IC1tdGmpnc5mCtJ5DYD7HWyoSbhruyzmuwzWdqLxdsC/DAgMBAAGjggF3MIIBczAfBgNVHSMEGDAWgBStvZh6NLQm9/rEJlTvA73gJMtUGjAdBgNVHQ4EFgQUmeRAX2sUXj4F2d3TY1T8Yrj3AKwwDgYDVR0PAQH/BAQDAgEGMBIGA1UdEwEB/wQIMAYBAf8CAQAwEQYDVR0gBAowCDAGBgRVHSAAMEQGA1UdHwQ9MDswOaA3oDWGM2h0dHA6Ly9jcmwudXNlcnRydXN0LmNvbS9BZGRUcnVzdEV4dGVybmFsQ0FSb290LmNybDCBswYIKwYBBQUHAQEEgaYwgaMwPwYIKwYBBQUHMAKGM2h0dHA6Ly9jcnQudXNlcnRydXN0LmNvbS9BZGRUcnVzdEV4dGVybmFsQ0FSb290LnA3YzA5BggrBgEFBQcwAoYtaHR0cDovL2NydC51c2VydHJ1c3QuY29tL0FkZFRydXN0VVROU0dDQ0EuY3J0MCUGCCsGAQUFBzABhhlodHRwOi8vb2NzcC51c2VydHJ1c3QuY29tMA0GCSqGSIb3DQEBBQUAA4IBAQCcNuNOrvGKu2yXjI9LZ9Cf2ISqnyFfNaFbxCtjDei8d12nxDf9Sy2e6B1pocCEzNFti/OBy59LdLBJKjHoN0DrH9mXoxoR1Sanbg+61b4s/bSRZNy+OxlQDXqV8wQTqbtHD4tc0azCe3chUN1bq+70ptjUSlNrTa24yOfmUlhNQ0zCoiNPDsAgOa/fT0JbHtMJ9BgJWSrZ6EoYvzL7+i1ki4fKWyvouAt+vhcSxwOCKa9Yr4WEXT0K3yNRw82vEL+AaXeRCk/luuGtm87fM04wO+mPZn+C+mv626PAcwDj1hKvTfIPWhRRH224hoFiB85ccsJP81cqcdnUl4XmGFO3']
        ]);
  },
  authorize: function () {
    var retryCount = 3;

    var app = this;
    cordova.exec(function (response) {
      // close the window if it exists
      app.closeInAppBrowser();
      /*
       The response method contains the name of the method in the OGAuthorizationDelegate protocol
       */
      if (response.method == 'requestAuthorization') {
        console.log('authorize ' + response.method);
        /*
         If the useEmbeddedWebView config parameter is true (initWithConfig) then the response contains a url which must be openend in the webview.

         {"method":"requestAuthorization","url":"https://beta-tokenserver.onegini.com/oauth/authorize?response_type=code&client_id=9551393CAC43E79A575C0C247CC7048B2E42BF334484B601F1F78315D0137DE8&redirect_uri=oneginisdk://loginsuccess&scope=read&state=27647386-53C4-4271-8F2A-B17BB5B69176-16807"}
         */

        // Open URL here in the inAppBrowser
        app.openInAppBrowser(response.url);
      }
      else if (response.method == 'askForPin') {
        console.log('authorize ' + response.method);
        /*
         Show a PIN entry dialog and call the askForPinResponse
         */
        $.mobile.navigate("#askForPin");
        //app.askForPinResponse('14941', false);
      }
      else if (response.method == 'askForPinWithVerification') {
        console.log('authorize ' + response.method);
        /*
         Show a PIN entry dialog with a second PIN entry for verification and call the askForPinWithVerificationResponse
         */
        $.mobile.navigate("#askForPinWithVerification");
        // For testing purposes, force a retry by providing non matching pins
        /*
         if (retryCount-- > 0) {
         ogCordovaApp.app.askForPinWithVerificationResponse('12345', '12045', true);
         } else {
         ogCordovaApp.app.askForPinWithVerificationResponse('14941', '14941', false);
         }
         */
      }
      else if (response == 'authorizationSuccess') {
        console.log('authorized ' + response);
        $.mobile.navigate("#authorized");
        // Continue to main page after the authorization is performed with success
      }
    }, function (error) {
      console.error('authorize error ' + error.reason);
      $.mobile.navigate("#authorizationFailed");

      /*
       Possible error content

       The reason value corresponds with the OGAuthorizationDelegate protocol method.
       Consult protocol documentation for more information.

       The presence of any additional keys depend on the type of error.
       For example a PIN attempt failure includes a "remainingAttempts" key

       {"remainingAttempts":2,"reason":"authorizationErrorInvalidGrant"}
       */
    }, 'OneginiCordovaClient', 'authorize', ['read']);
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
  askForPinResponse: function (pin, retry) {
    // Forward the PIN entry back to the OneginiClient.
    // Callback is performed on the initiating authorize callback handler
    // An INVALID_ACTION is returned if no authorization transaction is registered.
    cordova.exec(null, function (error) {
      console.log('confirmPin error ' + error.reason + ' ' + error.error.NSLocalizedDescription);
      $("#pinMessage").html('Invalid pin').enhanceWithin();
    }, 'OneginiCordovaClient', 'confirmPin', [pin, retry]);
  },
  askForPinWithVerificationResponse: function (pin, verifyPin, retry) {
    // Forward the PIN entry back to the OneginiClient.
    // Callback is performed on the initiating authorize callback handler
    // An INVALID_ACTION is returned if no authorization transaction is registered.
    cordova.exec(null, function (error) {
      console.log('confirmPinWithVerification ' + error.reason + ' ' + error.error.NSLocalizedDescription);
    }, 'OneginiCordovaClient', 'confirmPinWithVerification', [pin, verifyPin, retry]);
  },
  fetchAnonymousResource: function (path, scopes, requestMethod, paramsEncoding, params) {
    cordova.exec(function (response) {
      console.log('fetchAnonymousResource ' + response);
    }, function (error) {
      console.error('fetchAnonymousResource error ' + error.reason);
    }, 'OneginiCordovaClient', 'fetchAnonymousResource', [path, scopes, requestMethod, paramsEncoding, params]);
  },
  changePin: function (scopes) {
    cordova.exec(function (response) {
      /*
       The OneginiClient will respond by means of the OGAuthorizationDelegate and ask for the
       App to show a PIN entry/change dialog
       */
      if (response.method == 'askForPinChangeWithVerification') {
        ogCordovaApp.app.changePinWithVerificationResponse('14941', '94149', '94149', false);
      }
    }, function (error) {
      console.error('changePin ' + error.reason);
    }, 'OneginiCordovaClient', 'changePin', [scopes]);
  },
  changePinWithVerificationResponse: function (pin, newPin, newPinVerify, retry) {
    // Forward the PIN entries back to the OneginiClient.
    // Callback is performed on the initiating changePin callback handler
    cordova.exec(null, function (error) {
      console.log('changePinWithVerificationResponse ' + error.reason + ' ' + error.error.NSLocalizedDescription);
    }, 'OneginiCordovaClient', 'confirmChangePinWithVerification', [pin, newPin, newPinVerify, retry]);
  },
  cancelPinChange: function () {
    cordova.exec(null, null, 'OneginiCordovaClient', 'cancelPinChange', null);
  },
  clearDynamicContent: function () {
    console.log("Clearing dynamic content");
    var app = ogCordovaApp.app;
    app.profile({});
    app.errorMessage({});
    $("[data-content=dynamic]").html('').enhanceWithin();
  },
  openInAppBrowser: function (url) {
    this.inAppBrowser = window.open(url, '_blank', 'location=no,toolbar=no');
  },
  closeInAppBrowser: function () {
    if (this.inAppBrowser && this.inAppBrowser.close) {
      this.inAppBrowser.close();
    }
  },
  showResource: function (response) {
    try {
      $("#authorizedResource").html(ogCordovaApp.app.profile(JSON.parse(response))).enhanceWithin();
    }
    catch (e) {
      console.error("Could not parse response as JSON " + e);
      $("#authorizedResource").html("Failed to parse profile").enhanceWithin();
    }
  },
  handleResourceError: function (error) {
    $("#authorizedResource").html("Failed to fetch profile").enhanceWithin();
  },
  inAppBrowser: {},
  errorMessage: {},
  profile: {}
};

ogCordovaApp.plugin = {
  fetchResource: function (successCallback, errorCallback, path, scopes, requestMethod, paramsEncoding, params) {
    cordova.exec(function (response) {
      console.log('fetchResource ' + response);
      successCallback(response);
    }, function (error) {
      console.error('fetchResource error ' + error.reason);
      errorCallback(error);
    }, 'OneginiCordovaClient', 'fetchResource', [path, scopes, requestMethod, paramsEncoding, params]);
  }
};

ogCordovaApp.app.initialize();