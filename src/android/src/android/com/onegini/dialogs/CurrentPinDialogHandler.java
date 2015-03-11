package com.onegini.dialogs;

import static com.onegini.responses.OneginiPinResponse.ASK_FOR_CURRENT_PIN;
import static com.onegini.responses.OneginiPinResponse.PIN_CHANGE_ASK_FOR_CURRENT_PIN;

import org.apache.cordova.CallbackContext;

import com.onegini.actions.AuthorizeAction;
import com.onegini.actions.ChangePinAction;
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
    if (isAuthorizationFlow()) {
      handleLogin(oneginiPinProvidedHandler);
      return;
    }

    if (isChangePinFlow()) {
      handleCurrentPinForChange(oneginiPinProvidedHandler);
      return;
    }

    //TODO: invalidate pin request on SDK side
  }

  private boolean isAuthorizationFlow() {
    return AuthorizeAction.getAuthorizationCallback() != null;
  }

  private void handleLogin(final OneginiPinProvidedHandler oneginiPinProvidedHandler) {
    AuthorizeAction.setAwaitingPinProvidedHandler(oneginiPinProvidedHandler);
    final CallbackContext authorizationCallback = AuthorizeAction.getAuthorizationCallback();

    authorizationCallback.sendPluginResult(callbackResultBuilder
        .withSuccessMethod(ASK_FOR_CURRENT_PIN.getName())
        .withCallbackKept()
        .build());
  }

  private boolean isChangePinFlow() {
    return ChangePinAction.getChangePinCallback() != null;
  }

  private void handleCurrentPinForChange(final OneginiPinProvidedHandler oneginiPinProvidedHandler) {
    ChangePinAction.setAwaitingPinProvidedHandler(oneginiPinProvidedHandler);
    final CallbackContext changePinCallback = ChangePinAction.getChangePinCallback();

    changePinCallback.sendPluginResult(callbackResultBuilder
        .withSuccessMethod(PIN_CHANGE_ASK_FOR_CURRENT_PIN.getName())
        .withCallbackKept()
        .build());
  }
}
