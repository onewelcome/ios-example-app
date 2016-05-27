package com.onegini.action;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;

import com.onegini.OneginiCordovaPlugin;
import com.onegini.util.CallbackResultBuilder;

public class PinCallbackSession implements OneginiPluginAction {

  private static CallbackContext pinCallback;
  private final CallbackResultBuilder callbackResultBuilder;

  public static CallbackContext getPinCallback() {
    return pinCallback;
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

    AwaitInitialization.notifyIfPluginInitialized();
  }
}
