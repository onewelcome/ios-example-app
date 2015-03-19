package com.onegini.actions;

import static com.onegini.responses.OneginiAuthorizationResponse.AUTHORIZATION_REQUEST;

import org.apache.cordova.CallbackContext;

import android.net.Uri;
import com.onegini.mobile.sdk.android.library.handlers.OneginiURLHandler;
import com.onegini.util.CallbackResultBuilder;

/**
 * Created by Robert on 18.03.15.
 */
public class URLHandler implements OneginiURLHandler {

  private final CallbackResultBuilder callbackResultBuilder;

  public URLHandler() {
    callbackResultBuilder = new CallbackResultBuilder();
  }

  @Override
  public void onOpenURL(final Uri uri) {
    final CallbackContext context = AuthorizeAction.getCallbackContext();
    if (context == null) {
      return;
    }

    context.sendPluginResult(callbackResultBuilder
        .withSuccessMethod(AUTHORIZATION_REQUEST.getName())
        .withURL(uri.toString())
        .build());
  }
}
