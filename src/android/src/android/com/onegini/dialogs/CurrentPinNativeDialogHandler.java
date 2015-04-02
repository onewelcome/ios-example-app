package com.onegini.dialogs;

import com.onegini.actions.InAppBrowserControlSession;
import com.onegini.mobile.sdk.android.library.handlers.OneginiPinProvidedHandler;
import com.onegini.mobile.sdk.android.library.utils.dialogs.OneginiCurrentPinDialog;

public class CurrentPinNativeDialogHandler implements OneginiCurrentPinDialog {

  @Override
  public void getCurrentPin(final OneginiPinProvidedHandler oneginiPinProvidedHandler) {
    InAppBrowserControlSession.closeInAppBrowser();
  }
}
