package com.onegini.dialog;

import android.content.res.Resources;
import android.view.View;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.TableLayout;
import com.onegini.mobile.sdk.android.library.handlers.OneginiPinProvidedHandler;

public class PinKeyboard {

  private final PinKeyboardListener handler;

  private final int maxDigits;
  private char[] pin;

  private int cursorIndex = 0;
  private ImageButton deleteButton;

  public PinKeyboard(final PinKeyboardListener handler, final int maxDigits) {
    this.handler = handler;
    this.maxDigits = maxDigits;
    pin = new char[maxDigits];
  }

  public void initLayout(final TableLayout keyboardLayout, final Resources resources, final String packageName) {
    int resourceId;
    for (int digit = 0; digit < 10; digit++) {
      resourceId = resources.getIdentifier("pin_key_" + digit, "id", packageName);
      initPinDigitButton(keyboardLayout, resourceId, digit);
    }
    initPinDeleteButton(keyboardLayout, resources.getIdentifier("pin_key_del", "id", packageName));
  }

  public void submitPin(final OneginiPinProvidedHandler pinProvidedHandler) {
    pinProvidedHandler.onPinProvided(pin.clone());
    clearPin();
  }

  public void reset() {
    clearPin();
    deleteButton.setVisibility(View.INVISIBLE);
    cursorIndex = 0;
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
    if (cursorIndex < maxDigits) {
      deleteButton.setVisibility(View.VISIBLE);
      pin[cursorIndex++] = Character.forDigit(digit, 10);
      final boolean lastDigitProvided = cursorIndex >= maxDigits;
      if (lastDigitProvided) {
        deleteButton.setVisibility(View.INVISIBLE);
      }
      handler.onPinDigitAdded(lastDigitProvided);
    }
  }

  private void onDeleteKeyClicked() {
    if (cursorIndex > 0) {
      pin[--cursorIndex] = '\0';
      if (cursorIndex == 0) {
        deleteButton.setVisibility(View.INVISIBLE);
      }
      handler.onPinDigitRemoved();
    }
  }

  private void clearPin() {
    for (int index = 0; index < maxDigits; index++) {
      pin[index] = '\0';
    }
    pin = new char[maxDigits];
  }
}
