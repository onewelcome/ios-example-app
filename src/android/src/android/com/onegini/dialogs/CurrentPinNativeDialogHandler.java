package com.onegini.dialogs;

import static com.onegini.model.MessageKey.KEYBOARD_TITLE_ENTER_CURRENT_PIN;
import static com.onegini.util.MessageResourceReader.getMessageForKey;

import android.content.Context;
import android.content.Intent;
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

    final Intent intent = new Intent(context, PinScreenActivity.class);
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
    intent.putExtra(PinScreenActivity.EXTRA_SCREEN_TITLE, getMessageForKey(KEYBOARD_TITLE_ENTER_CURRENT_PIN.name()));
    context.startActivity(intent);
  }
}
