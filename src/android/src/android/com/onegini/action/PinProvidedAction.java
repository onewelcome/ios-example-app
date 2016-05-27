package com.onegini.action;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;
import org.json.JSONException;

import com.onegini.OneginiCordovaPlugin;
import com.onegini.mobile.sdk.android.library.handlers.OneginiPinProvidedHandler;

public class PinProvidedAction implements OneginiPluginAction {
  @Override
  public void execute(final JSONArray args, final CallbackContext callbackContext, final OneginiCordovaPlugin client) {
    handlePin(args, callbackContext, AwaitingPinHandlerProvider.getInstance().getAwaitingPinProvidedHandler());
  }

  private void handlePin(final JSONArray args, final CallbackContext callbackContext,
                         final OneginiPinProvidedHandler pinProvidedHandler) {
    try {
      final String pin = (String) args.get(0);
      pinProvidedHandler.onPinProvided(pin.toCharArray());
      callbackContext.success();
    } catch (JSONException e) {
      callbackContext.error("Failed to read provided pin, " + e.getMessage());
    }
  }

}
