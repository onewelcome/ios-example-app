package com.onegini.dialog;


import android.content.Context;
import android.content.Intent;

import com.onegini.mobile.sdk.android.library.utils.dialogs.ConfirmationWithPin;

import static android.content.Intent.FLAG_ACTIVITY_NEW_TASK;

public class AcceptWithPinDialog implements ConfirmationWithPin {

  static ConfirmationWithPinHandler handler;
  Context context;

  public AcceptWithPinDialog(final Context context) {
    this.context = context;
  }

  @Override
  public void showConfirmation(final String title, final String message, final int attemptCount, final int maxAllowedAttempts,
                               final ConfirmationWithPinHandler confirmationWithPinHandler) {

    this.handler = confirmationWithPinHandler;

    final Intent intent = new Intent(context, PushWithPinActivity.class);
    // title is acutally not used by SDK
    //intent.putExtra("title", title);
    intent.putExtra("message", message);
    intent.putExtra("attemptCount", attemptCount);
    intent.putExtra("maxAllowedAttempts", maxAllowedAttempts);
    intent.addFlags(FLAG_ACTIVITY_NEW_TASK);

    context.startActivity(intent);
  }

  @Override
  public void setContext(final Context context) {
    this.context = context;
  }
}

