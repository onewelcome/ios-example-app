# 5. Configuration

## 5.1. plugin.xml

The `plugin.xml` file is used to provide properties to end-application manifest - `AndroidManifest.xml`. All configuration changes describe within this chapter should be done within `<platform name="android">` XML node.

## 5.2. config.xml

In Cordova the end-application can be configured by modyfing global `config.xml` file [read more](https://cordova.apache.org/docs/en/4.0.0/config_ref_index.md.html). In order to use the Onegini Cordova Plugin you need to add special properties into the config file.

### 5.2.1. Plugin properties
The Onegini Cordova Plugin depends on the Onegini Mobile SDK, which in turn requires a set of configuration parameters which must be provided. Because of that the plugin looks for a specific properties in the the end-app's `config.xml`.
The configuration file must contain fallowing properties:

- "kOGAppIdentifier": end application identifier, must correspond to a one configured within the Token Server
- "kOGAppScheme": custom end application scheme, used to perform a back-to-the-app redirect
- "kOGAppVersion": end application version, must correspond to a one configured within the Token Server
- "kOGAppBaseURL": Token Server instance address, for secure HTTPS connection please refer to [Certificate pinning](4Certificatepinning.md)
- "kOGResourceBaseURL": Resource Server instance address, for secure HTTPS connection please refer to [Certificate pinning](4Certificatepinning.md)
- "kOGRedirectURL": redirection URL prefix which should be accepted by the SDK within authorization flow

The configuration file can also define optional properties:
- "kOGMaxPinFailures": int, allowed number of PIN attempts (default value is 3)
- "kOGUseEmbeddedWebview": boolean, indicates whenever the Cordova App should use embedded InAppBrowser for opening external URLs (true by default)

### 5.2.1. Custom application scheme
In order to perform back to the app redirection from in-app browser after following the registration process on Android application needs to declare the scheme to which it will respond. 

```xml
    <platform name="android">
      <config-file target="AndroidManifest.xml" parent="application/activity">
        <intent-filter>
          <action android:name="android.intent.action.VIEW"/>
          <category android:name="android.intent.category.DEFAULT"/>
          <category android:name="android.intent.category.BROWSABLE"/>
          <data android:scheme="oneginisdk"/>
        </intent-filter>
      </config-file>
    </platform>
```

### 5.2.2. Sample `config.xml` file
```xml
<?xml version='1.0' encoding='utf-8'?>
<widget id="com.onegini.oneginiCordovaApp" version="0.0.1" xmlns="http://www.w3.org/ns/widgets" xmlns:android="http://schemas.android.com/apk/res/android">
  <name>Sample app</name>
  <description>
    A sample to use the Onegini SDK from a Cordova app
  </description>
  <author email="developers@onegini.com" href="http://www.onegini.com">
    Onegini B.V.
  </author>
  <!-- Onegini Cordova Plugin config properties -->
  <preference name="kOGAppIdentifier" value="Sample"/>
  <preference name="kOGAppVersion" value="1.0.0"/>
  <preference name="kOGAppScheme" value="oneginisdk"/>
  <preference name="kOGAppBaseURL" value="https://test-token-server.onegini.com"/>
  <preference name="kOGMaxPinFailures" value="5"/>
  <preference name="kOGResourceBaseURL" value="https://test-token-server.onegini.com"/>
  <preference name="kOGRedirectURL" value="oneginisdk://loginsuccess"/>

  <!-- App's custom properties -->
  <preference name="BackgroundColor" value="0xfff0f0f0"/>
  <preference name="StatusBarOverlaysWebView" value="false"/>
  <preference name="StatusBarStyle" value="default"/>
  <preference name="StatusBarBackgroundColor" value="#FFFFFF"/>

  <content src="index.html"/>
  <icon src="www/res/icon/logo.png"/>
  <access origin="*"/>

  <platform name="ios">
    <!-- images are determined by width and height. The following are supported -->
    <splash src="www/res/icon/white.png" width="1" height="1"/>
    <splash src="www/res/icon/white.png" width="320" height="480"/>
    <splash src="www/res/icon/white.png" width="640" height="960"/>
    <splash src="www/res/icon/white.png" width="768" height="1024"/>
    <splash src="www/res/icon/white.png" width="1536" height="2048"/>
    <splash src="www/res/icon/white.png" width="1024" height="768"/>
    <splash src="www/res/icon/white.png" width="2048" height="1536"/>
    <splash src="www/res/icon/white.png" width="640" height="1136"/>
    <splash src="www/res/icon/white.png" width="750" height="1334"/>
    <splash src="www/res/icon/white.png" width="1242" height="2208"/>
    <splash src="www/res/icon/white.png" width="2208" height="1242"/>

    <config-file platform="ios" target="*-Info.plist" parent="UISupportedInterfaceOrientations">
      <array>
        <string>UIInterfaceOrientationPortrait</string>
      </array>
    </config-file>

    <config-file platform="ios" target="*-Info.plist" parent="UISupportedInterfaceOrientations~ipad">
      <array>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
      </array>
    </config-file>
  </platform>

  <platform name="android">
    <!-- custom app scheme declaration -->
    <config-file target="AndroidManifest.xml" parent="application/activity">
      <intent-filter>
        <action android:name="android.intent.action.VIEW"/>
        <category android:name="android.intent.category.DEFAULT"/>
        <category android:name="android.intent.category.BROWSABLE"/>
        <data android:scheme="oneginisdk"/>
      </intent-filter>
    </config-file>
  </platform>
</widget>

```