package com.onegini.action;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;
import org.json.JSONException;

import com.onegini.OneginiCordovaPlugin;
import com.onegini.mobile.sdk.android.library.OneginiClient;
import com.onegini.mobile.sdk.android.library.exception.OneginiClientNotValidatedException;
import com.onegini.mobile.sdk.android.library.utils.dialogs.OneginiPinValidationDialog;
import com.onegini.response.OneginiPinResponse;
import com.onegini.util.CallbackResultBuilder;

public class ValidatePinAction implements OneginiPluginAction {

  private CallbackResultBuilder callbackResultBuilder;

  public ValidatePinAction() {
    callbackResultBuilder = new CallbackResultBuilder();
  }

  @Override
  public void execute(final JSONArray args, final CallbackContext callbackContext, final OneginiCordovaPlugin client) {
    final OneginiClient oneginiClient = client.getOneginiClient();
    try {
      final String pin = (String) args.get(0);
      validatePin(pin.toCharArray(), callbackContext, oneginiClient);
    } catch (JSONException e) {
      callbackContext.error("Failed to read provided pin for validation, " + e.getMessage());
    }
  }

  private void validatePin(final char[] pin, final CallbackContext callbackContext, final OneginiClient oneginiClient) {
    boolean isPinValid;
    try {
      isPinValid = oneginiClient.isPinValid(pin, new OneginiPinValidationDialog() {
        @Override
        public void pinBlackListed() {
          callbackContext.sendPluginResult(
              callbackResultBuilder
                  .withErrorReason(OneginiPinResponse.PIN_BLACKLISTED.getName())
                  .build());
        }

        @Override
        public void pinShouldNotBeASequence() {
          callbackContext.sendPluginResult(
              callbackResultBuilder
                  .withErrorReason(OneginiPinResponse.PIN_SHOULD_NOT_BE_A_SEQUENCE.getName())
                  .build());
        }

        @Override
        public void pinShouldNotUseSimilarDigits(final int maxSimilar) {
          callbackContext.sendPluginResult(
              callbackResultBuilder
                  .withErrorReason(OneginiPinResponse.PIN_SHOULD_NOT_USE_SIMILAR_DIGITS.getName())
                  .withMaxSimilarDigits(maxSimilar)
                  .build());
        }

        @Override
        public void pinTooShort() {
          callbackContext.sendPluginResult(
              callbackResultBuilder
                  .withErrorReason(OneginiPinResponse.PIN_TOO_SHORT.getName())
                  .build());
        }
      });
    } catch (OneginiClientNotValidatedException e) {
      isPinValid = false;
    }

    if (isPinValid) {
      callbackContext.sendPluginResult(
          callbackResultBuilder
              .withSuccess()
              .build());
    } else {
      callbackContext.sendPluginResult(
          callbackResultBuilder
              .withErrorMessage("Pin invalid.")
              .build());
    }
  }
}
