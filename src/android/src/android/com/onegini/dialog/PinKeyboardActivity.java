package com.onegini.dialog;

import android.content.res.Resources;
import android.widget.TableLayout;

public interface PinKeyboardActivity {

  Resources getResources();

  String getPackageName();

  TableLayout getKeyboardLayout();

  void onDeleteKeyClicked();

  void onDigitKeyClicked(boolean lastDigitReceived);
}
