package com.onegini.dialog;

import static com.onegini.dialog.helper.PinActivityStarter.startLoginScreen;
import static com.onegini.dialog.helper.PinActivityStarter.startLoginScreenBeforeChangePin;

import android.content.Context;
import com.onegini.action.ChangePinAction;
import com.onegini.action.InAppBrowserControlSession;
import com.onegini.mobile.sdk.android.library.handlers.OneginiPinProvidedHandler;
import com.onegini.mobile.sdk.android.library.utils.dialogs.OneginiCurrentPinDialog;

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

    if (ChangePinAction.isChangePinFlow()) {
      startLoginScreenBeforeChangePin(context);
    } else {
      startLoginScreen(context);
    }
  }
}
