package com.onegini.dialogs;

import static com.onegini.responses.OneginiPinResponse.ASK_FOR_NEW_PIN;
import static com.onegini.responses.OneginiPinResponse.PIN_BLACKLISTED;
import static com.onegini.responses.OneginiPinResponse.PIN_CHANGE_ASK_FOR_NEW_PIN;
import static com.onegini.responses.OneginiPinResponse.PIN_SHOULD_NOT_BE_A_SEQUENCE;
import static com.onegini.responses.OneginiPinResponse.PIN_SHOULD_NOT_USE_SIMILAR_DIGITS;
import static com.onegini.responses.OneginiPinResponse.PIN_TOO_SHORT;

import org.apache.cordova.CallbackContext;

import com.onegini.actions.AuthorizeAction;
import com.onegini.actions.ChangePinAction;
import com.onegini.mobile.sdk.android.library.handlers.OneginiPinProvidedHandler;
import com.onegini.mobile.sdk.android.library.utils.dialogs.OneginiCreatePinDialog;
import com.onegini.util.CallbackResultBuilder;

public class CreatePinDialogHandler implements OneginiCreatePinDialog {

  private final CallbackResultBuilder callbackResultBuilder;

  public CreatePinDialogHandler() {
    callbackResultBuilder = new CallbackResultBuilder();
  }

  @Override
  public void createPin(final OneginiPinProvidedHandler oneginiPinProvidedHandler) {
    if (isAuthorizationFlow()) {
      handleInitialPinCreation(oneginiPinProvidedHandler);
      return;
    }

    if (isChangePinFlow()) {
      handleNewPin(oneginiPinProvidedHandler);
      return;
    }

    //TODO: invalidate pin request on SDK side
  }

  /*
  AuthorizationCallback is null-checked only once in #createPin as below methods will become unreachable if check fails.
   */
  @Override
  public void pinBlackListed() {
    getAppropriateCallbackContext().sendPluginResult(callbackResultBuilder
        .withSuccessMethod(PIN_BLACKLISTED.getName())
        .withCallbackKept()
        .build());
  }

  @Override
  public void pinShouldNotBeASequence() {
    getAppropriateCallbackContext().sendPluginResult(callbackResultBuilder
        .withSuccessMethod(PIN_SHOULD_NOT_BE_A_SEQUENCE.getName())
        .withCallbackKept()
        .build());
  }

  @Override
  public void pinShouldNotUseSimilarDigits(final int i) {
    getAppropriateCallbackContext().sendPluginResult(callbackResultBuilder
        .withSuccessMethod(PIN_SHOULD_NOT_USE_SIMILAR_DIGITS.getName())
        .withCallbackKept()
        .build());
  }

  @Override
  public void pinTooShort() {
    getAppropriateCallbackContext().sendPluginResult(callbackResultBuilder
        .withSuccessMethod(PIN_TOO_SHORT.getName())
        .withCallbackKept()
        .build());
  }

  private boolean isAuthorizationFlow() {
    return AuthorizeAction.getAuthorizationCallback() != null;
  }

  private void handleInitialPinCreation(final OneginiPinProvidedHandler oneginiPinProvidedHandler) {
    final CallbackContext authorizationCallback = AuthorizeAction.getAuthorizationCallback();
    AuthorizeAction.setAwaitingPinProvidedHandler(oneginiPinProvidedHandler);

    authorizationCallback.sendPluginResult(callbackResultBuilder
        .withSuccessMethod(ASK_FOR_NEW_PIN.getName())
        .withCallbackKept()
        .build());
  }

  private boolean isChangePinFlow() {
    return ChangePinAction.getChangePinCallback() != null;
  }

  private void handleNewPin(final OneginiPinProvidedHandler oneginiPinProvidedHandler) {
    final CallbackContext changePinCallback = ChangePinAction.getChangePinCallback();
    ChangePinAction.setAwaitingPinProvidedHandler(oneginiPinProvidedHandler);

    changePinCallback.sendPluginResult(callbackResultBuilder
        .withSuccessMethod(PIN_CHANGE_ASK_FOR_NEW_PIN.getName())
        .withCallbackKept()
        .build());
  }

  private CallbackContext getAppropriateCallbackContext() {
    if (isAuthorizationFlow()) {
      return AuthorizeAction.getAuthorizationCallback();
    }
    else {
      return ChangePinAction.getChangePinCallback();
    }
  }

}
