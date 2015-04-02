package com.onegini.dialogs;

import com.onegini.actions.InAppBrowserControlSession;
import com.onegini.mobile.sdk.android.library.handlers.OneginiPinProvidedHandler;
import com.onegini.mobile.sdk.android.library.utils.dialogs.OneginiCreatePinDialog;

public class CreatePinNativeDialogHandler implements OneginiCreatePinDialog {

  @Override
  public void createPin(final OneginiPinProvidedHandler oneginiPinProvidedHandler) {
    InAppBrowserControlSession.closeInAppBrowser();
  }

  @Override
  public void pinBlackListed() {

  }

  @Override
  public void pinShouldNotBeASequence() {

  }

  @Override
  public void pinShouldNotUseSimilarDigits(final int i) {

  }

  @Override
  public void pinTooShort() {

  }
}
