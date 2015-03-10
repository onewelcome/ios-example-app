package com.onegini.actions;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;
import org.json.JSONException;

import com.onegini.OneginiCordovaPlugin;
import com.onegini.mobile.sdk.android.library.handlers.OneginiPinProvidedHandler;

public class PinProvidedAction implements OneginiPluginAction {
  @Override
  public void execute(final JSONArray args, final CallbackContext callbackContext, final OneginiCordovaPlugin client) {
    if (args.length() != 1) {
      callbackContext.error("Invalid parameter, expected 1, got " + args.length() + ".");
      return;
    }

    if (isAuthorizationFlow()) {
      handlePin(args, callbackContext, AuthorizeAction.getAwaitingPinProvidedHandler());
      return;
    }

    if (isChangePinFlow()) {
      handlePin(args, callbackContext, ChangePinAction.getAwaitingPinProvidedHandler());
      return;
    }

    AuthorizeAction.clearAuthorizationSessionState();
    ChangePinAction.clearChangePinSessionState();
    callbackContext.error("Session not found.");
  }

  private boolean isAuthorizationFlow() {
    return AuthorizeAction.getAwaitingPinProvidedHandler() != null;
  }

  private boolean isChangePinFlow() {
    return ChangePinAction.getAwaitingPinProvidedHandler() != null;
  }

  private void handlePin(final JSONArray args, final CallbackContext callbackContext,
                         final OneginiPinProvidedHandler pinProvidedHandler) {
    try {
      final String pin = (String) args.get(0);
      pinProvidedHandler.onPinProvided(pin.toCharArray());
    } catch (JSONException e) {
      callbackContext.error("Failed to read provided pin, " + e.getMessage());
    }
  }

}
