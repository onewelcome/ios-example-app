package com.onegini.resource;

import static com.onegini.response.ResourceCallResponse.RESOURCE_CALL_ERROR;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;

import com.onegini.dialog.PinScreenActivity;
import com.onegini.util.CallbackResultBuilder;
import retrofit.Callback;
import retrofit.RetrofitError;
import retrofit.client.Response;

public class ResourceRequestCallback {

  private CallbackContext callbackContext;

  public ResourceRequestCallback(final CallbackContext callbackContext) {
    this.callbackContext = callbackContext;
  }

  public Callback<String> buildResponseCallback() {
    final CallbackResultBuilder callbackResultBuilder = new CallbackResultBuilder();
    return new Callback<String>() {
      @Override
      public void success(final String responseBody, final Response response) {
        sendCallbackResult(callbackContext, callbackResultBuilder
            .withSuccessMessage(responseBody)
            .build());
      }

      @Override
      public void failure(final RetrofitError error) {
        sendCallbackResult(callbackContext, callbackResultBuilder
            .withErrorReason(RESOURCE_CALL_ERROR.getName())
            .build());
      }
    };
  }

  private static void sendCallbackResult(final CallbackContext callbackContext, final PluginResult result) {
    if (PinScreenActivity.getInstance() != null) {
      PinScreenActivity.getInstance().finish();
    }
    callbackContext.sendPluginResult(result);
  }

}