package com.onegini.dialog;

import static com.onegini.dialog.PushWithFingerprintActivity.COMMAND_CLOSE;
import static com.onegini.dialog.PushWithFingerprintActivity.COMMAND_RECEIVED;
import static com.onegini.dialog.PushWithFingerprintActivity.COMMAND_SHOW;
import static com.onegini.dialog.PushWithFingerprintActivity.EXTRA_COMMAND;
import static com.onegini.dialog.PushWithFingerprintActivity.EXTRA_TITLE;

import android.content.Context;
import android.content.Intent;
import com.onegini.mobile.sdk.android.library.utils.dialogs.ConfirmationWithFingerprint;

public class PushAuthenticateWithFingerprintDialog implements ConfirmationWithFingerprint {

  public static ConfirmationWithFingerprintHandler handler;

  private Context context;

  public PushAuthenticateWithFingerprintDialog(final Context context) {
    this.context = context;
  }

  @Override
  public void showConfirmation(final String title, final ConfirmationWithFingerprintHandler confirmationWithFingerprintHandler) {
    handler = confirmationWithFingerprintHandler;

    final Intent intent = new Intent(context, PushWithFingerprintActivity.class);
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
    intent.putExtra(EXTRA_TITLE, title);
    context.startActivity(intent);
  }

  @Override
  public void askForFingerprint() {
    notifyActivity(COMMAND_SHOW);
  }

  @Override
  public void onFingerprintReceived() {
    notifyActivity(COMMAND_RECEIVED);
  }

  @Override
  public void hideConfirmation() {
    notifyActivity(COMMAND_CLOSE);
  }

  @Override
  public void setContext(final Context context) {
    this.context = context;
  }

  private void notifyActivity(final String command) {
    final Intent intent = new Intent(context, PushWithFingerprintActivity.class);
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
    intent.putExtra(EXTRA_COMMAND, command);
    context.startActivity(intent);
  }
}
