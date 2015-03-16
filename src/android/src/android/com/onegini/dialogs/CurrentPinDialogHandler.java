package com.onegini.dialogs;

import static com.onegini.responses.OneginiPinResponse.ASK_FOR_CURRENT_PIN;
import static com.onegini.responses.OneginiPinResponse.PIN_CHANGE_ASK_FOR_CURRENT_PIN;

import com.onegini.actions.ChangePinAction;
import com.onegini.actions.PinCallbackSession;
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
    PinCallbackSession.setAwaitingPinProvidedHandler(oneginiPinProvidedHandler);

    if (isChangePinFlow()) {
      handleCurrentPinForChange();
      return;
    }

    handleLogin();
  }

  private boolean isChangePinFlow() {
    return ChangePinAction.getChangePinCallback() != null;
  }

  private void handleLogin() {
    PinCallbackSession.getPinCallback().sendPluginResult(callbackResultBuilder
        .withSuccessMethod(ASK_FOR_CURRENT_PIN.getName())
        .withCallbackKept()
        .build());
  }

  private void handleCurrentPinForChange() {
    PinCallbackSession.getPinCallback().sendPluginResult(callbackResultBuilder
        .withSuccessMethod(PIN_CHANGE_ASK_FOR_CURRENT_PIN.getName())
        .withCallbackKept()
        .build());
  }
}
