package com.onegini.dialog;

import android.content.Context;
import android.content.Intent;
import com.onegini.mobile.sdk.android.library.utils.dialogs.OneginiFingerprintDialog;

public class FingerprintDialog implements OneginiFingerprintDialog {

  private Context context;

  public FingerprintDialog(final Context context) {
    this.context = context;
  }

  @Override
  public void showFingerprintPopup() {
    notifyActivity(FingerprintActivity.COMMAND_SHOW);
  }

  @Override
  public void onFingerprintReceived() {
    notifyActivity(FingerprintActivity.COMMAND_RECEIVED);
  }

  @Override
  public void closeFingerprintPopup() {
    notifyActivity(FingerprintActivity.COMMAND_CLOSE);
  }

  private void notifyActivity(final String command) {
    final Intent intent = new Intent(context, FingerprintActivity.class);
    intent.putExtra(FingerprintActivity.EXTRA_COMMAND, command);
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
    context.startActivity(intent);
  }
}
