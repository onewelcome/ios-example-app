package com.onegini.actions;

import static com.onegini.responses.OneginiAuthorizationResponse.AUTHORIZATION_ERROR_PIN_FORGOTTEN;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;

import com.onegini.dialogs.PinScreenActivity;
import com.onegini.util.CallbackResultBuilder;

public class ForgotPinHandler {

  private static CallbackContext callbackContext;
  private static CallbackResultBuilder callbackResultBuilder = new CallbackResultBuilder();

  public static void setCallbackContext(final CallbackContext callbackContext) {
    ForgotPinHandler.callbackContext = callbackContext;
  }

  /**
   * Method called by native PIN screen if user clicks "Reset PIN" button.
   */
  public static void resetPin() {
    if (callbackContext == null || callbackContext.isFinished()) {
      return;
    }

    sendCallbackResult(callbackResultBuilder
            .withErrorReason(AUTHORIZATION_ERROR_PIN_FORGOTTEN.getName())
            .build()
    );
  }

  private static void sendCallbackResult(final PluginResult result) {
    if (PinScreenActivity.getInstance() != null) {
      PinScreenActivity.getInstance().finish();
    }
    callbackContext.sendPluginResult(result);
  }
}
