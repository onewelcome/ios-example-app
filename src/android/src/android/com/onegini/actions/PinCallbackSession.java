package com.onegini.actions;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;

import com.onegini.OneginiCordovaPlugin;
import com.onegini.mobile.sdk.android.library.handlers.OneginiPinProvidedHandler;
import com.onegini.util.CallbackResultBuilder;

public class PinCallbackSession implements OneginiPluginAction {

  private static CallbackContext pinCallback;
  private static OneginiPinProvidedHandler awaitingPinProvidedHandler;
  private final CallbackResultBuilder callbackResultBuilder;

  public static CallbackContext getPinCallback() {
    return pinCallback;
  }

  public static OneginiPinProvidedHandler getAwaitingPinProvidedHandler() {
    return awaitingPinProvidedHandler;
  }

  public static void setAwaitingPinProvidedHandler(final OneginiPinProvidedHandler awaitingPinProvidedHandler) {
    PinCallbackSession.awaitingPinProvidedHandler = awaitingPinProvidedHandler;
  }

  public PinCallbackSession() {
    callbackResultBuilder = new CallbackResultBuilder();
  }

  @Override
  public void execute(final JSONArray args, final CallbackContext callbackContext, final OneginiCordovaPlugin client) {
    this.pinCallback = callbackContext;

    callbackContext.sendPluginResult(callbackResultBuilder
        .withSuccess()
        .withCallbackKept()
        .build());

    AwaitInitialization.notifyPluginInitialized();
  }
}
