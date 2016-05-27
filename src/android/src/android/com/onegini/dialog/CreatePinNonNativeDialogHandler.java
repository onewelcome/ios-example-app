package com.onegini.dialog;

import static com.onegini.response.OneginiPinResponse.ASK_FOR_NEW_PIN;
import static com.onegini.response.OneginiPinResponse.PIN_BLACKLISTED;
import static com.onegini.response.OneginiPinResponse.PIN_CHANGE_ASK_FOR_NEW_PIN;
import static com.onegini.response.OneginiPinResponse.PIN_SHOULD_NOT_BE_A_SEQUENCE;
import static com.onegini.response.OneginiPinResponse.PIN_SHOULD_NOT_USE_SIMILAR_DIGITS;
import static com.onegini.response.OneginiPinResponse.PIN_TOO_SHORT;

import com.onegini.action.AwaitingPinHandlerProvider;
import com.onegini.action.ChangePinAction;
import com.onegini.action.PinCallbackSession;
import com.onegini.mobile.sdk.android.library.handlers.OneginiPinProvidedHandler;
import com.onegini.mobile.sdk.android.library.utils.dialogs.OneginiCreatePinDialog;
import com.onegini.util.CallbackResultBuilder;

public class CreatePinNonNativeDialogHandler implements OneginiCreatePinDialog {

  private final CallbackResultBuilder callbackResultBuilder;

  public CreatePinNonNativeDialogHandler() {
    callbackResultBuilder = new CallbackResultBuilder();
  }

  @Override
  public void createPin(final OneginiPinProvidedHandler oneginiPinProvidedHandler) {
    AwaitingPinHandlerProvider.getInstance().setAwaitingPinProvidedHandler(oneginiPinProvidedHandler);

    if (isChangePinFlow()) {
      handleNewPinInChangeFlow();
      return;
    }

    handlePinCreation();
  }

  /*
  AuthorizationCallback is null-checked only once in #createPin as below methods will become unreachable if check fails.
   */
  @Override
  public void pinBlackListed() {
    PinCallbackSession.getPinCallback().sendPluginResult(callbackResultBuilder
        .withSuccessMethod(PIN_BLACKLISTED.getName())
        .withCallbackKept()
        .build());
  }

  @Override
  public void pinShouldNotBeASequence() {
    PinCallbackSession.getPinCallback().sendPluginResult(callbackResultBuilder
        .withSuccessMethod(PIN_SHOULD_NOT_BE_A_SEQUENCE.getName())
        .withCallbackKept()
        .build());
  }

  @Override
  public void pinShouldNotUseSimilarDigits(final int i) {
    PinCallbackSession.getPinCallback().sendPluginResult(callbackResultBuilder
        .withSuccessMethod(PIN_SHOULD_NOT_USE_SIMILAR_DIGITS.getName())
        .withCallbackKept()
        .build());
  }

  @Override
  public void pinTooShort() {
    PinCallbackSession.getPinCallback().sendPluginResult(callbackResultBuilder
        .withSuccessMethod(PIN_TOO_SHORT.getName())
        .withCallbackKept()
        .build());
  }

  private boolean isChangePinFlow() {
    return ChangePinAction.getChangePinCallback() != null;
  }

  private void handlePinCreation() {
    PinCallbackSession.getPinCallback().sendPluginResult(callbackResultBuilder
        .withSuccessMethod(ASK_FOR_NEW_PIN.getName())
        .withCallbackKept()
        .build());
  }

  private void handleNewPinInChangeFlow() {
    PinCallbackSession.getPinCallback().sendPluginResult(callbackResultBuilder
        .withSuccessMethod(PIN_CHANGE_ASK_FOR_NEW_PIN.getName())
        .withCallbackKept()
        .build());
  }

}