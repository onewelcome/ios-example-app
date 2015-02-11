var ogCordovaApp = {};

ogCordovaApp.config = {
  name: 'Onegini',
  scopes: ['read'],
  sdkConfig: {
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
  },
  certificates: ['MIIE5TCCA82gAwIBAgIQB28SRoFFnCjVSNaXxA4AGzANBgkqhkiG9w0BAQUFADBvMQswCQYDVQQGEwJTRTEUMBIGA1UEChMLQWRkVHJ1c3QgQUIxJjAkBgNVBAsTHUFkZFRydXN0IEV4dGVybmFsIFRUUCBOZXR3b3JrMSIwIAYDVQQDExlBZGRUcnVzdCBFeHRlcm5hbCBDQSBSb290MB4XDTEyMDIxNjAwMDAwMFoXDTIwMDUzMDEwNDgzOFowczELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxGTAXBgNVBAMTEFBvc2l0aXZlU1NMIENBIDIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDo6jnjIqaqucQA0OeqZztDB71Pkuu8vgGjQK3g70QotdA6voBUF4V6a4RsNjbloyTi/igBkLzX3Q+5K05IdwVpr95XMLHo+xoD9jxbUx6hAUlocnPWMytDqTcyUg+uJ1YxMGCtyb1zLDnukNh1sCUhYHsqfwL9goUfdE+SNHNcHQCgsMDqmOK+ARRYFygiinddUCXNmmym5QzlqyjDsiCJ8AckHpXCLsDl6ez2PRIHSD3SwyNWQezT3zVLyOf2hgVSEEOajBd8i6q8eODwRTusgFX+KJPhChFo9FJXb/5IC1tdGmpnc5mCtJ5DYD7HWyoSbhruyzmuwzWdqLxdsC/DAgMBAAGjggF3MIIBczAfBgNVHSMEGDAWgBStvZh6NLQm9/rEJlTvA73gJMtUGjAdBgNVHQ4EFgQUmeRAX2sUXj4F2d3TY1T8Yrj3AKwwDgYDVR0PAQH/BAQDAgEGMBIGA1UdEwEB/wQIMAYBAf8CAQAwEQYDVR0gBAowCDAGBgRVHSAAMEQGA1UdHwQ9MDswOaA3oDWGM2h0dHA6Ly9jcmwudXNlcnRydXN0LmNvbS9BZGRUcnVzdEV4dGVybmFsQ0FSb290LmNybDCBswYIKwYBBQUHAQEEgaYwgaMwPwYIKwYBBQUHMAKGM2h0dHA6Ly9jcnQudXNlcnRydXN0LmNvbS9BZGRUcnVzdEV4dGVybmFsQ0FSb290LnA3YzA5BggrBgEFBQcwAoYtaHR0cDovL2NydC51c2VydHJ1c3QuY29tL0FkZFRydXN0VVROU0dDQ0EuY3J0MCUGCCsGAQUFBzABhhlodHRwOi8vb2NzcC51c2VydHJ1c3QuY29tMA0GCSqGSIb3DQEBBQUAA4IBAQCcNuNOrvGKu2yXjI9LZ9Cf2ISqnyFfNaFbxCtjDei8d12nxDf9Sy2e6B1pocCEzNFti/OBy59LdLBJKjHoN0DrH9mXoxoR1Sanbg+61b4s/bSRZNy+OxlQDXqV8wQTqbtHD4tc0azCe3chUN1bq+70ptjUSlNrTa24yOfmUlhNQ0zCoiNPDsAgOa/fT0JbHtMJ9BgJWSrZ6EoYvzL7+i1ki4fKWyvouAt+vhcSxwOCKa9Yr4WEXT0K3yNRw82vEL+AaXeRCk/luuGtm87fM04wO+mPZn+C+mv626PAcwDj1hKvTfIPWhRRH224hoFiB85ccsJP81cqcdnUl4XmGFO3']
};

ogCordovaApp.app = {
  // Application Constructor
  initialize: function () {
    this.bindEvents();
  },
  bindEvents: function () {
    document.addEventListener('deviceready', this.onDeviceReady, false);
    document.addEventListener('pause', this.pauseApp, false);
    document.addEventListener('resign', this.pauseApp, false); // iOS specific event when locking the app
    document.addEventListener('resume', ogCordovaApp.navigation.navigateToHome, false);
  },
  bindButtons: function () {
    var app = this;
    $("[data-btn-role='btnLogin']").on("click", function (e) {
      e.preventDefault();
      ogCordovaPlugin.authorize(new AuthorizationRouter(), ogCordovaApp.config.scopes);
    });

    $("[data-btn-role='btnLogout']").on("click", function (e) {
      e.preventDefault();
      ogCordovaPlugin.logout();
      ogCordovaApp.navigation.navigateToHome();
    });

    $("[data-btn-role='btnDisconnect']").on("click", function (e) {
      e.preventDefault();
      var disconnectAndGoHome = function (buttonIndex) {
        if (buttonIndex == 1) {
          ogCordovaPlugin.disconnect();
          ogCordovaApp.navigation.navigateToHome();
        }
      };
      app.confirm("Do you want to disconnect the app?", disconnectAndGoHome);
    });

    $("#fetchProfile").on("click", function (e) {
      e.preventDefault();
      ogCordovaPlugin.fetchResource(app.showResource, app.handleResourceError,
          '/client/resource/profile', ogCordovaApp.config.scopes, 'GET', 'JSON', {});
    });
  },
  bindForms: function () {
    new PinPage();
    new SetPinPage();
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

    if (navigator.notification) {
      window.alert = function (message) {
        navigator.notification.alert(message, null, ogCordovaApp.config.name);
      };
    }
  },
  pauseApp: function () {
    ogCordovaPlugin.logout();
    ogCordovaApp.navigation.navigateToPage("#paused");
  },
  confirm: function (message, callback) {
    if (navigator.notification) {
      navigator.notification.confirm(message, callback, ogCordovaApp.config.name);
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
        'OneginiCordovaClient', 'initWithConfig', [ogCordovaApp.config.sdkConfig, ogCordovaApp.config.certificates]);
  },
  fetchAnonymousResource: function (path, scopes, requestMethod, paramsEncoding, params) {
    cordova.exec(function (response) {
      console.log('fetchAnonymousResource ' + response);
    }, function (error) {
      console.error('fetchAnonymousResource error ' + error.reason);
    }, 'OneginiCordovaClient', 'fetchAnonymousResource', [path, scopes, requestMethod, paramsEncoding, params]);
  },
  clearDynamicContent: function () {
    console.log("Clearing dynamic content");
    var app = ogCordovaApp.app;
    app.profile({});
    app.errorMessage({});
    $("[data-content=dynamic]").html('').enhanceWithin();
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
  errorMessage: {},
  profile: {}
};

ogCordovaApp.navigation = {

  navigateToHome: function () {
    $.mobile.navigate("#home", {transition: "slideup"});
  },
  navigateToPage: function (page) {
    $.mobile.navigate(page, {transition: "slide"});
  }
};

ogCordovaApp.app.initialize();