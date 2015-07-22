package com.onegini.dialogs;

import static com.onegini.dialogs.helper.PinActivityStarter.startLoginScreen;
import static com.onegini.dialogs.helper.PinActivityStarter.startLoginScreenBeforeChangePin;

import android.content.Context;
import com.onegini.actions.ChangePinAction;
import com.onegini.actions.InAppBrowserControlSession;
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
