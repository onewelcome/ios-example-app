package com.onegini.dialogs;

import com.onegini.actions.AuthorizeAction;
import com.onegini.mobile.sdk.android.library.handlers.OneginiPinProvidedHandler;
import com.onegini.mobile.sdk.android.library.utils.dialogs.OneginiCurrentPinDialog;

public class CurrentPinDialogHandler implements OneginiCurrentPinDialog {
  @Override
  public void getCurrentPin(final OneginiPinProvidedHandler oneginiPinProvidedHandler) {
    if (AuthorizeAction.getAuthorizationCallbackId() == null) {

    }
  }
}
