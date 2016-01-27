package com.onegini.dialog;

import android.content.res.Resources;
import android.view.View;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.TableLayout;
import com.onegini.dialog.helper.PinKeyboardHandler;
import com.onegini.mobile.sdk.android.library.handlers.OneginiPinProvidedHandler;

public class PinKeyboard {

  private final PinKeyboardHandler handler;

  private ImageButton deleteButton;

  public PinKeyboard(final PinKeyboardHandler handler) {
    this.handler = handler;
  }

  public void initLayout(final TableLayout keyboardLayout, final Resources resources, final String packageName) {
    int resourceId;
    for (int digit = 0; digit < 10; digit++) {
      resourceId = resources.getIdentifier("pin_key_" + digit, "id", packageName);
      initPinDigitButton(keyboardLayout, resourceId, digit);
    }
    initPinDeleteButton(keyboardLayout, resources.getIdentifier("pin_key_del", "id", packageName));
  }

  private void initPinDigitButton(final TableLayout keyboardLayout, final int buttonId, final int buttonValue) {
    final Button pinButton = (Button) keyboardLayout.findViewById(buttonId);
    pinButton.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(final View v) {
        onDigitKeyClicked(buttonValue);
      }
    });
  }

  private void initPinDeleteButton(final TableLayout keyboardLayout, final int buttonId) {
    deleteButton = (ImageButton) keyboardLayout.findViewById(buttonId);
    deleteButton.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(final View v) {
        onDeleteKeyClicked();
      }
    });
  }

  private void onDigitKeyClicked(final int digit) {
    deleteButton.setVisibility(View.VISIBLE);
    handler.onPinDigitPressed(digit);
  }

  private void onDeleteKeyClicked() {
    handler.onPinDigitRemoved(deleteButton);
  }
}