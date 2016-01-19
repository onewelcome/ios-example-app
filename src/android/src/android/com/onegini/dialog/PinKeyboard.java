package com.onegini.dialog;

import android.content.res.Resources;
import android.os.Handler;
import android.view.View;
import android.widget.Button;
import android.widget.TableLayout;
import com.onegini.mobile.sdk.android.library.handlers.OneginiPinProvidedHandler;

public class PinKeyboard {

  private final PinKeyboardActivity keyboardActivity;
  private final TableLayout keyboardLayout;
  private final Resources resources;
  private final String packageName;
  private final int maxDigits;
  private final char[] pin;
  private final OneginiPinProvidedHandler pinProvidedHandler;

  private int cursorIndex = 0;
  private Button deleteButton;

  public PinKeyboard(final PinKeyboardActivity keyboardActivity, final int maxDigits, final OneginiPinProvidedHandler pinProvidedHandler) {
    this.keyboardActivity = keyboardActivity;
    keyboardLayout = keyboardActivity.getKeyboardLayout();
    resources = keyboardActivity.getResources();
    packageName = keyboardActivity.getPackageName();
    this.maxDigits = maxDigits;
    this.pinProvidedHandler = pinProvidedHandler;

    pin = new char[maxDigits];
    initLayout();
  }

  public void reset() {
    clearPin();
    deleteButton.setVisibility(View.INVISIBLE);
    cursorIndex = 0;
  }

  private void initLayout() {
    int buttonId;
    for (int digit = 0; digit < 10; digit++) {
      buttonId = resources.getIdentifier("pin_key_" + digit, "id", packageName);
      initPinDigitButton(buttonId, digit);
    }

    final int delButtonId = resources.getIdentifier("pin_key_del", "id", packageName);
    initPinDeleteButton(delButtonId);
  }

  private void initPinDigitButton(final int buttonId, final int buttonValue) {
    final Button pinButton = (Button) keyboardLayout.findViewById(buttonId);
    pinButton.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(final View v) {
        onDigitKeyClicked(buttonValue);
      }
    });
  }

  private void initPinDeleteButton(final int buttonId) {
    deleteButton = (Button) keyboardLayout.findViewById(buttonId);
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
      final boolean maxDigitReached = cursorIndex >= maxDigits;
      keyboardActivity.onDigitKeyClicked(maxDigitReached);
      if (maxDigitReached) {
        onMaxDigitsReached();
      }
    }
  }

  private void onDeleteKeyClicked() {
    if (cursorIndex > 0) {
      pin[--cursorIndex] = '\0';
      if (cursorIndex == 0) {
        deleteButton.setVisibility(View.INVISIBLE);
      }
      keyboardActivity.onDeleteKeyClicked();
    }
  }

  private void onMaxDigitsReached() {
    deleteButton.setVisibility(View.INVISIBLE);
    // slightly delay the SDK call, so it won't make a lag during UI changes
    final Handler handler = new Handler();
    handler.postDelayed(new Runnable() {
      @Override
      public void run() {
        pinProvidedHandler.onPinProvided(pin);
        clearPin();
      }
    }, 100);
  }

  private void clearPin() {
    for (int index = 0; index < maxDigits; index++) {
      pin[index] = '\0';
    }
  }
}
