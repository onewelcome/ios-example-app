package com.onegini.dialog;

import static android.content.Intent.FLAG_ACTIVITY_NEW_TASK;

import android.content.Context;
import android.content.Intent;
import com.onegini.mobile.sdk.android.library.utils.dialogs.AlertInterface;

public class ConfirmationDialog implements AlertInterface {

  static AlertHandler handler;
  protected Context context;

  public ConfirmationDialog(final Context context) {
    this.context = context;
  }

  @Override
  public void showAlert(final String title, final String message, final String positiveButton,
                        final String negativeButton, final AlertHandler alertHandler) {
    this.handler = alertHandler;

    final Intent intent = new Intent(context, PushSimpleActivity.class);
    intent.putExtra("message", message);
    intent.putExtra("positiveButtonTitle", positiveButton);
    intent.putExtra("negativeButtonTitle", negativeButton);
    intent.addFlags(FLAG_ACTIVITY_NEW_TASK);

    context.startActivity(intent);
  }
}
