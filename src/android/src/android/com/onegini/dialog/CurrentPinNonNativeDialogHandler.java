package com.onegini.dialog;

import static com.onegini.response.OneginiPinResponse.ASK_FOR_CURRENT_PIN;
import static com.onegini.response.OneginiPinResponse.PIN_CHANGE_ASK_FOR_CURRENT_PIN;

import com.onegini.action.AwaitingPinHandlerProvider;
import com.onegini.action.ChangePinAction;
import com.onegini.action.PinCallbackSession;
import com.onegini.mobile.sdk.android.library.handlers.OneginiPinProvidedHandler;
import com.onegini.mobile.sdk.android.library.utils.dialogs.OneginiCurrentPinDialog;
import com.onegini.util.CallbackResultBuilder;

public class CurrentPinNonNativeDialogHandler implements OneginiCurrentPinDialog {

  private final CallbackResultBuilder callbackResultBuilder;

  public CurrentPinNonNativeDialogHandler() {
    callbackResultBuilder = new CallbackResultBuilder();
  }

  @Override
  public void getCurrentPin(final OneginiPinProvidedHandler oneginiPinProvidedHandler) {
    AwaitingPinHandlerProvider.getInstance().setAwaitingPinProvidedHandler(oneginiPinProvidedHandler);

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