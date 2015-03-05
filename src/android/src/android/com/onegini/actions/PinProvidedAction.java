package com.onegini.actions;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;
import org.json.JSONException;

import com.onegini.OneginiCordovaPlugin;

public class PinProvidedAction implements OneginiPluginAction {
  @Override
  public void execute(final JSONArray args, final CallbackContext callbackContext, final OneginiCordovaPlugin client) {
    if (args.length() != 1) {
      callbackContext.error("Invalid parameter, expected 1, got " + args.length() + ".");
      return;
    }

    if (AuthorizeAction.getAwaitingPinProvidedHandler() == null) {
      AuthorizeAction.clearAuthorizationSessionState();
      return;
    }

    try {
      final String pin = (String) args.get(0);
      AuthorizeAction.getAwaitingPinProvidedHandler().onPinProvided(pin.toCharArray());
    } catch (JSONException e) {
      callbackContext.error("Failed to read provided pin, " + e.getMessage());
    }
  }
}
