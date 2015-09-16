package com.onegini.resource;

import static com.onegini.response.ResourceCallResponse.RESOURCE_CALL_AUTH_FAILED;
import static com.onegini.response.ResourceCallResponse.RESOURCE_CALL_BAD_REQUEST;
import static com.onegini.response.ResourceCallResponse.RESOURCE_CALL_ERROR;
import static com.onegini.response.ResourceCallResponse.RESOURCE_CALL_INVALID_GRANT;
import static com.onegini.response.ResourceCallResponse.RESOURCE_CALL_SCOPE_ERROR;
import static com.onegini.response.ResourceCallResponse.RESOURCE_CALL_UNAUTHORIZED;

import java.util.List;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;

import com.onegini.dialog.PinScreenActivity;
import com.onegini.mobile.sdk.android.library.handlers.OneginiResourceHandler;
import com.onegini.util.CallbackResultBuilder;
import retrofit.client.Header;

public class ResourceHandler {

  private static CallbackResultBuilder callbackResultBuilder = new CallbackResultBuilder();

  public static OneginiResourceHandler<String> buildResourceHandlerForCallback(final CallbackContext callbackContext) {
    return new OneginiResourceHandler<String>() {

      private boolean retry;

      @Override
      public void resourceSuccess(final String response, final List<Header> headers) {
        sendCallbackResult(callbackContext, callbackResultBuilder
            .withSuccessMessage(response)
            .build());
      }

      @Override
      public void resourceCallError() {
        sendCallbackResult(callbackContext, callbackResultBuilder
            .withErrorReason(RESOURCE_CALL_ERROR.getName())
            .build());
      }

      @Override
      public void resourceCallBadRequest() {
        sendCallbackResult(callbackContext, callbackResultBuilder
            .withErrorReason(RESOURCE_CALL_BAD_REQUEST.getName())
            .build());
      }

      @Override
      public void resourceCallErrorAuthenticationFailed() {
        sendCallbackResult(callbackContext, callbackResultBuilder
            .withErrorReason(RESOURCE_CALL_AUTH_FAILED.getName())
            .build());
      }

      @Override
      public void getScopeError() {
        sendCallbackResult(callbackContext, callbackResultBuilder
            .withErrorReason(RESOURCE_CALL_SCOPE_ERROR.getName())
            .build());
      }

      @Override
      public void setRetry(final boolean retry) {
        this.retry = retry;
      }

      @Override
      public boolean isRetry() {
        return retry;
      }

      @Override
      public void getUnauthorizedClient() {
        sendCallbackResult(callbackContext, callbackResultBuilder
            .withErrorReason(RESOURCE_CALL_UNAUTHORIZED.getName())
            .build());
      }

      @Override
      public void getInvalidGrantType() {
        sendCallbackResult(callbackContext, callbackResultBuilder
            .withErrorReason(RESOURCE_CALL_INVALID_GRANT.getName())
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
