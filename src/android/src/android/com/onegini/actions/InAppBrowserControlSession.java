package com.onegini.actions;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;

import com.onegini.OneginiCordovaPlugin;
import com.onegini.util.CallbackResultBuilder;

public class InAppBrowserControlSession implements OneginiPluginAction {

  private static CallbackContext inAppBrowserControlCallback;

  public static CallbackContext getInAppBrowserControlCallback() {
    return inAppBrowserControlCallback;
  }

  private final CallbackResultBuilder callbackResultBuilder;

  public InAppBrowserControlSession() {
    callbackResultBuilder = new CallbackResultBuilder();
  }

  @Override
  public void execute(final JSONArray args, final CallbackContext callbackContext, final OneginiCordovaPlugin client) {
    this.inAppBrowserControlCallback = callbackContext;

    callbackContext.sendPluginResult(callbackResultBuilder
        .withSuccess()
        .withCallbackKept()
        .build());

    AwaitInitialization.notifyIfPluginInitialized();
  }
}
