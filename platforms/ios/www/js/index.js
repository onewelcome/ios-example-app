/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
var app = {
    // Application Constructor
    initialize: function() {
        this.bindEvents();
    },
    // Bind Event Listeners
    //
    // Bind any events that are required on startup. Common events are:
    // 'load', 'deviceready', 'offline', and 'online'.
    bindEvents: function() {
        document.addEventListener('deviceready', this.onDeviceReady, false);
    },
    // deviceready Event Handler
    //
    // The scope of 'this' is the event. In order to call the 'receivedEvent'
    // function, we must explicitly call 'app.receivedEvent(...);'
    onDeviceReady: function() {
        app.receivedEvent('deviceready');
    },
    // Update DOM on a Received Event
    receivedEvent: function(id) {
        var parentElement = document.getElementById(id);
        var listeningElement = parentElement.querySelector('.listening');
        var receivedElement = parentElement.querySelector('.received');

        listeningElement.setAttribute('style', 'display:none;');
        receivedElement.setAttribute('style', 'display:block;');

        console.log('Received Event: ' + id);
		
		app.initWithConfig();
    },
	initWithConfig: function() {
		cordova.exec(function(response) {
						console.log(response);
					 }, function(error) {},
					 'OneginiCordovaClient',
					 'initWithConfig',
					 [{
					  'kOGAppIdentifier':'DemoApp-2-4',
					  'kOGAppPlatform':'ios',
					  'kOGAppScheme':'oneginisdk',
					  'kOGAppVersion':'2.4',
					  'kAppBaseURL':'https://beta-tokenserver.onegini.com',
					  'kOGShouldConfirmNewPin':true,
					  'kOGShouldDirectlyShowPushMessage':true,
					  'kOGKeyStorePassword':'NotSoVerySecureYet',
					  'kOGMaxPinFailures':'3',
					  'kOGResourceBaseURL':'https://beta-tokenserver.onegini.com',
					  'kOGRedirectURL':'oneginisdk://loginsuccess',
					  'kOGUseEmbeddedWebview':false
					  },['MIIE5TCCA82gAwIBAgIQB28SRoFFnCjVSNaXxA4AGzANBgkqhkiG9w0BAQUFADBvMQswCQYDVQQGEwJTRTEUMBIGA1UEChMLQWRkVHJ1c3QgQUIxJjAkBgNVBAsTHUFkZFRydXN0IEV4dGVybmFsIFRUUCBOZXR3b3JrMSIwIAYDVQQDExlBZGRUcnVzdCBFeHRlcm5hbCBDQSBSb290MB4XDTEyMDIxNjAwMDAwMFoXDTIwMDUzMDEwNDgzOFowczELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxGTAXBgNVBAMTEFBvc2l0aXZlU1NMIENBIDIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDo6jnjIqaqucQA0OeqZztDB71Pkuu8vgGjQK3g70QotdA6voBUF4V6a4RsNjbloyTi/igBkLzX3Q+5K05IdwVpr95XMLHo+xoD9jxbUx6hAUlocnPWMytDqTcyUg+uJ1YxMGCtyb1zLDnukNh1sCUhYHsqfwL9goUfdE+SNHNcHQCgsMDqmOK+ARRYFygiinddUCXNmmym5QzlqyjDsiCJ8AckHpXCLsDl6ez2PRIHSD3SwyNWQezT3zVLyOf2hgVSEEOajBd8i6q8eODwRTusgFX+KJPhChFo9FJXb/5IC1tdGmpnc5mCtJ5DYD7HWyoSbhruyzmuwzWdqLxdsC/DAgMBAAGjggF3MIIBczAfBgNVHSMEGDAWgBStvZh6NLQm9/rEJlTvA73gJMtUGjAdBgNVHQ4EFgQUmeRAX2sUXj4F2d3TY1T8Yrj3AKwwDgYDVR0PAQH/BAQDAgEGMBIGA1UdEwEB/wQIMAYBAf8CAQAwEQYDVR0gBAowCDAGBgRVHSAAMEQGA1UdHwQ9MDswOaA3oDWGM2h0dHA6Ly9jcmwudXNlcnRydXN0LmNvbS9BZGRUcnVzdEV4dGVybmFsQ0FSb290LmNybDCBswYIKwYBBQUHAQEEgaYwgaMwPwYIKwYBBQUHMAKGM2h0dHA6Ly9jcnQudXNlcnRydXN0LmNvbS9BZGRUcnVzdEV4dGVybmFsQ0FSb290LnA3YzA5BggrBgEFBQcwAoYtaHR0cDovL2NydC51c2VydHJ1c3QuY29tL0FkZFRydXN0VVROU0dDQ0EuY3J0MCUGCCsGAQUFBzABhhlodHRwOi8vb2NzcC51c2VydHJ1c3QuY29tMA0GCSqGSIb3DQEBBQUAA4IBAQCcNuNOrvGKu2yXjI9LZ9Cf2ISqnyFfNaFbxCtjDei8d12nxDf9Sy2e6B1pocCEzNFti/OBy59LdLBJKjHoN0DrH9mXoxoR1Sanbg+61b4s/bSRZNy+OxlQDXqV8wQTqbtHD4tc0azCe3chUN1bq+70ptjUSlNrTa24yOfmUlhNQ0zCoiNPDsAgOa/fT0JbHtMJ9BgJWSrZ6EoYvzL7+i1ki4fKWyvouAt+vhcSxwOCKa9Yr4WEXT0K3yNRw82vEL+AaXeRCk/luuGtm87fM04wO+mPZn+C+mv626PAcwDj1hKvTfIPWhRRH224hoFiB85ccsJP81cqcdnUl4XmGFO3']
					  ]);
	},
	authorize: function() {
		var retryCount = 3;
		cordova.exec(function(response) {
		    /*
			 The response method contains the name of the method in the OGAuthorizationDelegate protocol
			 */
			if (response.method == 'requestAuthorization') {
	 			console.log('authorize ' + response.method);
				 /*
				  If the useEmbeddedWebView config parameter is true (initWithConfig) then the response contains a url which must be openend in the webview.
					  
				  {"method":"requestAuthorization","url":"https://beta-tokenserver.onegini.com/oauth/authorize?response_type=code&client_id=9551393CAC43E79A575C0C247CC7048B2E42BF334484B601F1F78315D0137DE8&redirect_uri=oneginisdk://loginsuccess&scope=read&state=27647386-53C4-4271-8F2A-B17BB5B69176-16807"}
				  */
					 
				// Open URL here in an embedded webview
			} else if (response.method == 'askForPin') {
 	 			console.log('authorize ' + response.method);
				 /*
				  Show a PIN entry dialog and call the askForPinResponse
				 */
				 app.askForPinResponse('14941', false);
			 } else if (response.method == 'askForPinWithVerification') {
 	 			console.log('authorize ' + response.method);
				 /*
				  Show a PIN entry dialog with a second PIN entry for verification and call the askForPinWithVerificationResponse
				  */
					 
				 // For testing purposes, force a retry by providing non matching pins
				 if (retryCount-- > 0) {
					 app.askForPinWithVerificationResponse('12345', '12045', true);
				 } else {
					 app.askForPinWithVerificationResponse('14941', '14941', false);
				 }
			 } else if (response == 'authorizationSuccess') {
 	 			console.log('authorize ' + response);
					 
				// Continue to main page after the authorization is performed with success
			 }
		}, function(error) {
			console.error('authorize error ' + error.reason);
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
	logout: function() {
		cordova.exec(null, null, 'OneginiCordovaClient', 'logout', null);
	},
	disconnect: function() {
		cordova.exec(null, null, 'OneginiCordovaClient', 'disconnect', null);
	},
	clearCredentials: function() {
		// FOR TESTING PURPOSE ONLY
		cordova.exec(null, null, 'OneginiCordovaClient', 'clearCredentials', null);
	},
	clearTokens: function() {
		// FOR TESTING PURPOSE ONLY
		cordova.exec(null, null, 'OneginiCordovaClient', 'clearTokens', null);
	},
	askForPinResponse: function(pin, retry) {
		// Forward the PIN entry back to the OneginiClient.
		// Callback is performed on the initiating authorize callback handler
		// An INVALID_ACTION is returned if no authorization transaction is registered.
		cordova.exec(null, function(error) {
			console.log('confirmPin error ' + error.reason + ' ' + error.error.NSLocalizedDescription);
		}, 'OneginiCordovaClient', 'confirmPin', [pin, retry]);
	},
	askForPinWithVerificationResponse: function(pin, verifyPin, retry) {
		// Forward the PIN entry back to the OneginiClient.
		// Callback is performed on the initiating authorize callback handler
		// An INVALID_ACTION is returned if no authorization transaction is registered.
		cordova.exec(null, function(error) {
			console.log('confirmPinWithVerification ' + error.reason + ' ' + error.error.NSLocalizedDescription);
		}, 'OneginiCordovaClient', 'confirmPinWithVerification', [pin, verifyPin, retry]);
	},
	fetchResource: function(path, scopes, requestMethod, paramsEncoding, params) {
		cordova.exec(function(response) {
			 console.log('fetchResource ' + response);
		}, function(error) {
			console.error('fetchResource error ' + error.reason);
		}, 'OneginiCordovaClient', 'fetchResource', [path, scopes, requestMethod, paramsEncoding, params]);
	},
	fetchAnonymousResource: function(path, scopes, requestMethod, paramsEncoding, params) {
		cordova.exec(function(response) {
			 console.log('fetchAnonymousResource ' + response);
		 }, function(error) {
			 console.error('fetchAnonymousResource error ' + error.reason);
		 }, 'OneginiCordovaClient', 'fetchAnonymousResource', [path, scopes, requestMethod, paramsEncoding, params]);
	},
	changePin: function(scopes) {
		cordova.exec(function(response) {
			/*
			 The OneginiClient will respond by means of the OGAuthorizationDelegate and ask for the 
			 App to show a PIN entry/change dialog
			 */
			if (response.method == 'askForPinChangeWithVerification') {
				app.changePinWithVerificationResponse('14941', '94149', '94149', false);
			}
		}, function(error) {
			 console.error('changePin ' + error.reason);
		}, 'OneginiCordovaClient', 'changePin', [scopes]);
	},
	changePinWithVerificationResponse: function(pin, newPin, newPinVerify, retry) {
		// Forward the PIN entries back to the OneginiClient.
		// Callback is performed on the initiating changePin callback handler
		cordova.exec(null, function(error) {
			console.log('changePinWithVerificationResponse ' + error.reason + ' ' + error.error.NSLocalizedDescription);
		 }, 'OneginiCordovaClient', 'confirmChangePinWithVerification', [pin, newPin, newPinVerify, retry]);
	},
	cancelPinChange: function() {
		cordova.exec(null, null, 'OneginiCordovaClient', 'cancelPinChange', null);
	}
};

app.initialize();