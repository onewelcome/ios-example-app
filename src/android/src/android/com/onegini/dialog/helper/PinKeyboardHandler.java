package com.onegini.dialog.helper;

import android.text.Html;
import android.text.Spanned;
import android.view.View;
import android.widget.ImageButton;
import android.widget.TextView;

public class PinKeyboardHandler {

  private static final Spanned HTML_CHAR_DOT = Html.fromHtml("&#9679;");

  private final TextView[] pinInputs;
  private final int pinLength;
  private final PinProvidedListener pinProvidedHandler;
  private int cursorIndex;
  private char[] pin;

  private int inputFocusedBackgroundResourceId;
  private int inputNormalBackgroundResourceId;

  public interface PinProvidedListener {
    void onPinProvided(char[] pin);
  }

  public PinKeyboardHandler(final PinProvidedListener handler, final TextView[] pinInputs) {
    pinProvidedHandler = handler;
    this.pinInputs = pinInputs;
    this.pinLength = pinInputs.length;

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
      pinProvidedHandler.onPinProvided(pin.clone());
      clearPin();
    } else {
      pinInputs[cursorIndex].setText("");
      pinInputs[cursorIndex].setBackgroundResource(inputFocusedBackgroundResourceId);
    }
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
