package com.onegini.resource;

import static com.onegini.responses.ResourceCallResponse.RESOURCE_CALL_AUTH_FAILED;
import static com.onegini.responses.ResourceCallResponse.RESOURCE_CALL_BAD_REQUEST;
import static com.onegini.responses.ResourceCallResponse.RESOURCE_CALL_ERROR;
import static com.onegini.responses.ResourceCallResponse.RESOURCE_CALL_INVALID_GRANT;
import static com.onegini.responses.ResourceCallResponse.RESOURCE_CALL_SCOPE_ERROR;
import static com.onegini.responses.ResourceCallResponse.RESOURCE_CALL_UNAUTHORIZED;

import java.util.List;

import org.apache.cordova.CallbackContext;

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
        callbackContext.success(response);
      }

      @Override
      public void resourceCallError() {
        callbackContext.sendPluginResult(
            callbackResultBuilder
                .withErrorReason(RESOURCE_CALL_ERROR.getName())
                .build());
      }

      @Override
      public void resourceCallBadRequest() {
        callbackContext.sendPluginResult(
            callbackResultBuilder
                .withErrorReason(RESOURCE_CALL_BAD_REQUEST.getName())
                .build());
      }

      @Override
      public void resourceCallErrorAuthenticationFailed() {
        callbackContext.sendPluginResult(
            callbackResultBuilder
                .withErrorReason(RESOURCE_CALL_AUTH_FAILED.getName())
                .build());
      }

      @Override
      public void getScopeError() {
        callbackContext.sendPluginResult(
            callbackResultBuilder
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
        callbackContext.sendPluginResult(
            callbackResultBuilder
                .withErrorReason(RESOURCE_CALL_UNAUTHORIZED.getName())
                .build());
      }

      @Override
      public void getInvalidGrantType() {
        callbackContext.sendPluginResult(
            callbackResultBuilder
                .withErrorReason(RESOURCE_CALL_INVALID_GRANT.getName())
                .build());
      }
    };
  }

}
