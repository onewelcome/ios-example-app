package com.onegini.action;

import static com.onegini.response.InAppBrowserControlResponse.CLOSE_IN_APP_BROWSER;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;

import com.onegini.OneginiCordovaPlugin;
import com.onegini.util.CallbackResultBuilder;

public class InAppBrowserControlSession implements OneginiPluginAction {

  private static CallbackResultBuilder callbackResultBuilder = new CallbackResultBuilder();
  private static CallbackContext inAppBrowserControlCallback;

  public static CallbackContext getInAppBrowserControlCallback() {
    return inAppBrowserControlCallback;
  }

  public static void closeInAppBrowser() {
    if (inAppBrowserControlCallback == null) {
      return;
    }

    inAppBrowserControlCallback.sendPluginResult(callbackResultBuilder
        .withSuccessMethod(CLOSE_IN_APP_BROWSER.getName())
        .withCallbackKept()
        .build());
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
