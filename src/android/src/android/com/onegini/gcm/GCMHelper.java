package com.onegini.gcm;


import java.io.IOException;
import java.util.concurrent.atomic.AtomicInteger;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.AsyncTask;
import android.util.Log;
import com.google.android.gms.gcm.GoogleCloudMessaging;
import com.onegini.mobile.sdk.android.library.OneginiClient;
import com.onegini.mobile.sdk.android.library.handlers.OneginiMobileAuthEnrollmentHandler;

public class GCMHelper {
  Context context;

  private OneginiClient oneginiClient;

  public static final String PROPERTY_REG_ID = "registration_id";
  private static final String PROPERTY_APP_VERSION = "appVersion";
  private final static int PLAY_SERVICES_RESOLUTION_REQUEST = 9000;

  String SENDER_ID = "586427927998";

  /**
   * Tag used on log messages.
   */
  static final String TAG = "GCMDemo";

  GoogleCloudMessaging gcm;
  AtomicInteger msgId = new AtomicInteger();
  SharedPreferences prefs;

  String regid;

  public GCMHelper(Context context) {
    this.context = context;
  }

  public void registerGCMService(final OneginiClient oneginiClient,
                                 final String[] scopes,
                                 final OneginiMobileAuthEnrollmentHandler mobileAuthEnrollmentHandler) {
    this.oneginiClient = oneginiClient;
    gcm = GoogleCloudMessaging.getInstance(context);
    if (oneginiClient.isPushNotificationEnabled(context)) {

      regid = getRegistrationId(context);

      if (regid.isEmpty()) {
        registerInBackground(scopes, mobileAuthEnrollmentHandler);
      }
      else {
        oneginiClient.enrollForMobileAuthentication(regid, scopes, mobileAuthEnrollmentHandler);
      }
    }
    else {
      Log.i(TAG, "No valid Google Play Services APK found.");
    }
  }

  /**
   * Gets the current registration ID for application on GCM service. <p> If result is empty, the app needs to
   * register.
   *
   * @return registration ID, or empty string if there is no existing registration ID.
   */
  private String getRegistrationId(final Context context) {
    final SharedPreferences prefs = getGCMPreferences(context);
    final String registrationId = prefs.getString(PROPERTY_REG_ID, "");
    if (registrationId.isEmpty()) {
      Log.i(TAG, "Registration not found.");
      return "";
    }
    // Check if app was updated; if so, it must clear the registration ID
    // since the existing regID is not guaranteed to work with the new
    // app version.
    final int registeredVersion = prefs.getInt(PROPERTY_APP_VERSION, Integer.MIN_VALUE);
    final int currentVersion = getAppVersion(context);
    if (registeredVersion != currentVersion) {
      Log.i(TAG, "App version changed.");
      return "";
    }
    return registrationId;
  }

  /**
   * @return Application's {@code SharedPreferences}.
   */
  private SharedPreferences getGCMPreferences(final Context context) {
    // This sample app persists the registration ID in shared preferences, but
    // how you store the regID in your app is up to you.
    return context.getSharedPreferences(context.getApplicationInfo().name,
        Context.MODE_PRIVATE);
  }

  /**
   * @return Application's version code from the {@code PackageManager}.
   */
  private static int getAppVersion(final Context context) {
    try {
      PackageInfo packageInfo = context.getPackageManager()
          .getPackageInfo(context.getPackageName(), 0);
      return packageInfo.versionCode;
    } catch (PackageManager.NameNotFoundException e) {
      // should never happen
      throw new RuntimeException("Could not get package name: " + e);
    }
  }

  /**
   * Registers the application with GCM servers asynchronously. <p> Stores the registration ID and app versionCode in
   * the application's shared preferences.
   */
  private void registerInBackground(final String[] scopes,
                                    final OneginiMobileAuthEnrollmentHandler mobileAuthEnrollmentHandler) {
    new AsyncTask<Void, Void, String>() {
      @Override
      protected String doInBackground(Void... params) {

        String msg = "";
        try {
          if (gcm == null) {
            gcm = GoogleCloudMessaging.getInstance(context);
          }
          regid = gcm.register(SENDER_ID);
          msg = "Device registered, registration ID=" + regid;

          // You should send the registration ID to your server over HTTP,
          // so it can use GCM/HTTP or CCS to send messages to your app.
          // The request to your server should be authenticated if your app
          // is using accounts.
          sendRegistrationIdToBackend(scopes, mobileAuthEnrollmentHandler);

          // Persist the regID - no need to register again.
          storeRegistrationId(context, regid);
        } catch (IOException ex) {
          msg = "Error :" + ex.getMessage();
          // If there is an error, don't just keep trying to register.
          // Require the user to click a button again, or perform
          // exponential back-off.
        }

        return msg;
      }

      @Override
      protected void onPostExecute(String msg) {
        Log.v("TEST", msg);
      }
    }.execute(null, null, null);
  }

  /**
   * Sends the registration ID to your server over HTTP, so it can use GCM/HTTP or CCS to send messages to your app. Not
   * needed for this demo since the device sends upstream messages to a server that echoes back the message using the
   * 'from' address in the message.
   */
  private void sendRegistrationIdToBackend(final String[] scopes,
                                           final OneginiMobileAuthEnrollmentHandler mobileAuthEnrollmentHandler) {
    oneginiClient.enrollForMobileAuthentication(regid, scopes, mobileAuthEnrollmentHandler);
  }

  /**
   * Stores the registration ID and app versionCode in the application's {@code SharedPreferences}.
   *
   * @param context application's context.
   * @param regId   registration ID
   */
  private void storeRegistrationId(Context context, String regId) {
    final SharedPreferences prefs = getGCMPreferences(context);
    int appVersion = getAppVersion(context);
    Log.i(TAG, "Saving regId on app version " + appVersion);
    SharedPreferences.Editor editor = prefs.edit();
    editor.putString(PROPERTY_REG_ID, regId);
    editor.putInt(PROPERTY_APP_VERSION, appVersion);
    editor.commit();
  }
}
