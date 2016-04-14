package com.onegini.action;

import static com.onegini.response.OneginiAuthorizationResponse.AUTHORIZATION_REQUEST;

import org.apache.cordova.CallbackContext;

import android.net.Uri;
import com.onegini.action.authorization.AuthorizationActionExecutor;
import com.onegini.mobile.sdk.android.library.handlers.OneginiURLHandler;
import com.onegini.util.CallbackResultBuilder;

public class URLHandler implements OneginiURLHandler {

  private final CallbackResultBuilder callbackResultBuilder;

  public URLHandler() {
    callbackResultBuilder = new CallbackResultBuilder();
  }

  @Override
  public void onOpenURL(final Uri uri) {
    final CallbackContext context = AuthorizationActionExecutor.getCallbackContext();
    if (context == null) {
      return;
    }

    context.sendPluginResult(callbackResultBuilder
        .withSuccessMethod(AUTHORIZATION_REQUEST.getName())
        .withURL(uri.toString())
        .withCallbackKept()
        .build());
  }
}
