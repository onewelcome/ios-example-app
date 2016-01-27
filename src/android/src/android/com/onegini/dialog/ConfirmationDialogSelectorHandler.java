package com.onegini.dialog;

import android.content.Context;
import com.onegini.mobile.sdk.android.library.utils.dialogs.AlertInterface;
import com.onegini.mobile.sdk.android.library.utils.dialogs.ConfirmationDialogSelector;

public class ConfirmationDialogSelectorHandler implements ConfirmationDialogSelector {

  private Context context;

  public ConfirmationDialogSelectorHandler(final Context context) {
    this.context = context;
  }

  @Override
  public AlertInterface selectConfirmationDialog(final String s) {
    return new ConfirmationDialog(context);
  }

  @Override
  public void setContext(final Context context) {
    this.context = context;
  }
}
