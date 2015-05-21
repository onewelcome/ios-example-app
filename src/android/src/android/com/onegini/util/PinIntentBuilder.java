package com.onegini.util;

import android.content.Context;
import android.content.Intent;
import com.onegini.dialogs.PinScreenActivity;

public class PinIntentBuilder {

  private final Context context;
  private final Intent intent;

  /**
   * Intent builder for PinScreenActivity. PinScreenActivity can show PIN keyboard in 3 'modes':
   * - LOGIN
   * - CREATE PIN
   * - CONFIRM PIN
   * with diffrent layouts, messages etc. Default mode is 'LOGIN'
   * @param context
   */
  public PinIntentBuilder(final Context context) {
    this.context = context;
    intent = new Intent(context, PinScreenActivity.class);
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
    intent.putExtra(PinScreenActivity.EXTRA_MODE, PinScreenActivity.SCREEN_MODE_LOGIN);
  }

  public PinIntentBuilder setLoginMode() {
    intent.putExtra(PinScreenActivity.EXTRA_MODE, PinScreenActivity.SCREEN_MODE_LOGIN);
    return this;
  }

  public PinIntentBuilder setCreatePinMode() {
    intent.putExtra(PinScreenActivity.EXTRA_MODE, PinScreenActivity.SCREEN_MODE_CREATE_PIN);
    return this;
  }

  public PinIntentBuilder setConfirmPinMode() {
    intent.putExtra(PinScreenActivity.EXTRA_MODE, PinScreenActivity.SCREEN_MODE_CONFIRM_PIN);
    return this;
  }

  public PinIntentBuilder addErrorMessage(final String message) {
    intent.putExtra(PinScreenActivity.EXTRA_MESSAGE, message);
    return this;
  }

  public void startActivity() {
    context.startActivity(intent);
  }
}