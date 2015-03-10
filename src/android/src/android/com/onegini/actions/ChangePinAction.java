package com.onegini.actions;

import static com.onegini.responses.OneginiPinResponse.PIN_CHANGED;
import static com.onegini.responses.OneginiPinResponse.PIN_CHANGE_ERROR;
import static com.onegini.responses.OneginiPinResponse.PIN_CURRENT_INVALID;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;

import com.onegini.OneginiCordovaPlugin;
import com.onegini.mobile.sdk.android.library.OneginiClient;
import com.onegini.mobile.sdk.android.library.handlers.OneginiChangePinHandler;
import com.onegini.util.CallbackResultBuilder;

public class ChangePinAction implements OneginiPluginAction {

  private CallbackResultBuilder callbackResultBuilder;

  public ChangePinAction() {
    callbackResultBuilder = new CallbackResultBuilder();
  }

  @Override
  public void execute(final JSONArray args, final CallbackContext callbackContext, final OneginiCordovaPlugin client) {
    final OneginiClient oneginiClient = client.getOneginiClient();

    oneginiClient.changePin(new OneginiChangePinHandler() {
      @Override
      public void pinChanged() {
        callbackContext.sendPluginResult(
            callbackResultBuilder
            .withSuccessMessage(PIN_CHANGED.getName())
            .build());
      }

      @Override
      public void invalidCurrentPin() {
        callbackContext.sendPluginResult(
            callbackResultBuilder
                .withSuccessMessage(PIN_CURRENT_INVALID.getName())
                .build());
      }

      @Override
      public void pinChangeError() {
        callbackContext.sendPluginResult(
            callbackResultBuilder
                .withSuccessMessage(PIN_CHANGE_ERROR.getName())
                .build());
      }

      @Override
      public void pinChangeException(final Exception exception) {
        callbackContext.sendPluginResult(
            callbackResultBuilder
                .withSuccessMessage(PIN_CHANGE_ERROR.getName())
                .build());
      }
    });
  }
}
