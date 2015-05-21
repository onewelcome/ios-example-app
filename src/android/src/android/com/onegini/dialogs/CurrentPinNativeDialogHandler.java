package com.onegini.dialogs;

import android.content.Context;
import com.onegini.actions.InAppBrowserControlSession;
import com.onegini.mobile.sdk.android.library.handlers.OneginiPinProvidedHandler;
import com.onegini.mobile.sdk.android.library.utils.dialogs.OneginiCurrentPinDialog;
import com.onegini.util.PinIntentBuilder;

public class CurrentPinNativeDialogHandler implements OneginiCurrentPinDialog {

  static OneginiPinProvidedHandler oneginiPinProvidedHandler;

  private final Context context;

  public CurrentPinNativeDialogHandler(final Context context) {
    this.context = context;
  }

  @Override
  public void getCurrentPin(final OneginiPinProvidedHandler oneginiPinProvidedHandler) {
    InAppBrowserControlSession.closeInAppBrowser();

    this.oneginiPinProvidedHandler = oneginiPinProvidedHandler;

    new PinIntentBuilder(context).setLoginMode().startActivity();
  }
}
