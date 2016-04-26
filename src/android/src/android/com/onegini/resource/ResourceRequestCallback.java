package com.onegini.resource;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;

import com.onegini.dialog.PinScreenActivity;
import com.onegini.util.ResourcePluginResultBuilder;
import retrofit.Callback;
import retrofit.RetrofitError;
import retrofit.client.Response;

public class ResourceRequestCallback {

  private CallbackContext callbackContext;

  public ResourceRequestCallback(final CallbackContext callbackContext) {
    this.callbackContext = callbackContext;
  }

  public Callback<byte[]> buildResponseCallback() {
    return new Callback<byte[]>() {
      @Override
      public void success(final byte[] responseBody, final Response response) {
        sendCallbackResult(callbackContext, new ResourcePluginResultBuilder(responseBody, response).withSuccess().build());
      }

      @Override
      public void failure(final RetrofitError error) {
        final byte[] responseBody = getErrorResponseBody(error);
        sendCallbackResult(callbackContext, new ResourcePluginResultBuilder(responseBody, error.getResponse()).withError().build());
      }

      private byte[] getErrorResponseBody(final RetrofitError error) {
        if (error.getResponse() != null && error.getResponse().getBody() != null) {
          return RetrofitByteConverter.fromTypedInput(error.getResponse().getBody());
        } else {
          return new byte[0];
        }
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