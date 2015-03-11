package com.onegini.actions;

import static com.onegini.responses.OneginiPinResponse.PIN_CHANGED;
import static com.onegini.responses.OneginiPinResponse.PIN_CHANGE_ERROR;
import static com.onegini.responses.OneginiPinResponse.PIN_CURRENT_INVALID;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;

import com.onegini.OneginiCordovaPlugin;
import com.onegini.mobile.sdk.android.library.OneginiClient;
import com.onegini.mobile.sdk.android.library.handlers.OneginiChangePinHandler;
import com.onegini.mobile.sdk.android.library.handlers.OneginiPinProvidedHandler;
import com.onegini.util.CallbackResultBuilder;

public class ChangePinAction implements OneginiPluginAction {

  private static CallbackContext changePinCallback;
  private static OneginiPinProvidedHandler awaitingPinProvidedHandler;

  public static CallbackContext getChangePinCallback() {
    return changePinCallback;
  }

  public static void clearChangePinSessionState() {
    changePinCallback = null;
  }

  public static void setAwaitingPinProvidedHandler(final OneginiPinProvidedHandler oneginiPinProvidedHandler) {
    awaitingPinProvidedHandler = oneginiPinProvidedHandler;
  }

  public static OneginiPinProvidedHandler getAwaitingPinProvidedHandler() {
    return awaitingPinProvidedHandler;
  }

  private CallbackResultBuilder callbackResultBuilder;

  public ChangePinAction() {
    callbackResultBuilder = new CallbackResultBuilder();
  }

  @Override
  public void execute(final JSONArray args, final CallbackContext callbackContext, final OneginiCordovaPlugin client) {
    final OneginiClient oneginiClient = client.getOneginiClient();

    changePinCallback = callbackContext;

    oneginiClient.changePin(new OneginiChangePinHandler() {
      @Override
      public void pinChanged() {
        sendCallbackResult(
            callbackResultBuilder
            .withSuccessMessage(PIN_CHANGED.getName())
            .build());
      }

      @Override
      public void invalidCurrentPin() {
        sendCallbackResult(
            callbackResultBuilder
                .withErrorReason(PIN_CURRENT_INVALID.getName())
                .build());
      }

      @Override
      public void pinChangeError() {
        sendCallbackResult(
            callbackResultBuilder
                .withErrorReason(PIN_CHANGE_ERROR.getName())
                .build());
      }

      @Override
      public void pinChangeException(final Exception exception) {
        sendCallbackResult(
            callbackResultBuilder
                .withErrorReason(PIN_CHANGE_ERROR.getName())
                .build());
      }
    });
  }

  private void sendCallbackResult(final PluginResult result) {
    changePinCallback.sendPluginResult(result);
    clearChangePinSessionState();
  }
}
