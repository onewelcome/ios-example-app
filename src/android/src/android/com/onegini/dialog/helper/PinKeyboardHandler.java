package com.onegini.dialog.helper;

import android.os.Handler;
import android.text.Html;
import android.text.Spanned;
import android.view.View;
import android.widget.ImageButton;
import android.widget.TextView;
import com.onegini.mobile.sdk.android.library.handlers.OneginiPinProvidedHandler;

public class PinKeyboardHandler {

  private static final Spanned HTML_CHAR_DOT = Html.fromHtml("&#9679;");

  private final TextView[] pinInputs;
  private final int pinLength;
  private final OneginiPinProvidedHandler pinProvidedHandler;
  private int cursorIndex;
  private char[] pin;

  private int inputFocusedBackgroundResourceId;
  private int inputNormalBackgroundResourceId;

  public PinKeyboardHandler(final OneginiPinProvidedHandler pinProvidedHandler, final TextView[] pinInputs, final int pinLength) {
    this.pinProvidedHandler = pinProvidedHandler;
    this.pinInputs = pinInputs;
    this.pinLength = pinLength;

    pin = new char[pinLength];
  }

  public void setInputFocusedBackgroundResourceId(final int inputFocusedBackgroundResourceId) {
    this.inputFocusedBackgroundResourceId = inputFocusedBackgroundResourceId;
  }

  public void setInputNormalBackgroundResourceId(final int inputNormalBackgroundResourceId) {
    this.inputNormalBackgroundResourceId = inputNormalBackgroundResourceId;
  }

  public void onPinDigitRemoved(final ImageButton deleteButton) {
    if (cursorIndex > 0) {
      pinInputs[cursorIndex].setBackgroundResource(inputNormalBackgroundResourceId);
      pin[--cursorIndex] = '\0';

      if (cursorIndex == 0) {
        deleteButton.setVisibility(View.INVISIBLE);
      }
    }

    pinInputs[cursorIndex].setBackgroundResource(inputNormalBackgroundResourceId);
    pinInputs[cursorIndex].setText("");
    pinInputs[cursorIndex].setBackgroundResource(inputFocusedBackgroundResourceId);
  }

  public void onPinDigitPressed(final int digit) {
    if (cursorIndex < pinLength) {
      pin[cursorIndex] = Character.forDigit(digit, 10);

      pinInputs[cursorIndex].setText(HTML_CHAR_DOT);
      pinInputs[cursorIndex].setBackgroundResource(inputNormalBackgroundResourceId);
    }

    cursorIndex++;
    final boolean isPinProvided = cursorIndex >= pinLength;
    if (isPinProvided) {
      submitPin();
    } else {
      pinInputs[cursorIndex].setText("");
      pinInputs[cursorIndex].setBackgroundResource(inputFocusedBackgroundResourceId);
    }
  }

  private void submitPin() {
    // slightly delay the SDK call, so it won't make a lag during UI changes
    final Handler handler = new Handler();
    handler.postDelayed(new Runnable() {
      @Override
      public void run() {
        pinProvidedHandler.onPinProvided(pin.clone());
        clearPin();
      }
    }, 100);
  }

  public void reset() {
    for (int i = 0; i < pinLength; i++) {
      pinInputs[i].setText("");
      pinInputs[i].setBackgroundResource(inputNormalBackgroundResourceId);
    }
    pinInputs[cursorIndex].setBackgroundResource(inputFocusedBackgroundResourceId);

    clearPin();
    cursorIndex = 0;
  }

  private void clearPin() {
    for (int index = 0; index < pinLength; index++) {
      pin[index] = '\0';
    }
    pin = new char[pinLength];
  }
}
