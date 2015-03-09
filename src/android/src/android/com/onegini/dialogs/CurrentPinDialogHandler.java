package com.onegini.dialogs;

import static com.onegini.responses.OneginiPinResponse.ASK_FOR_CURRENT_PIN;

import org.apache.cordova.CallbackContext;

import com.onegini.actions.AuthorizeAction;
import com.onegini.mobile.sdk.android.library.handlers.OneginiPinProvidedHandler;
import com.onegini.mobile.sdk.android.library.utils.dialogs.OneginiCurrentPinDialog;
import com.onegini.util.CallbackResultBuilder;

public class CurrentPinDialogHandler implements OneginiCurrentPinDialog {

  private final CallbackResultBuilder callbackResultBuilder;

  public CurrentPinDialogHandler() {
    callbackResultBuilder = new CallbackResultBuilder();
  }

  @Override
  public void getCurrentPin(final OneginiPinProvidedHandler oneginiPinProvidedHandler) {
    final CallbackContext authorizationCallback = AuthorizeAction.getAuthorizationCallback();
    if (authorizationCallback == null) {
      //TODO: invalidate pin request on SDK side
      return;
    }

    AuthorizeAction.setAwaitingPinProvidedHandler(oneginiPinProvidedHandler);

    authorizationCallback.sendPluginResult(callbackResultBuilder
        .withSuccessMethod(ASK_FOR_CURRENT_PIN.getName())
        .withCallbackKept()
        .build());
  }
}
