package com.onegini.dialog;

public interface PinKeyboardListener {

  void onPinDigitRemoved();

  void onPinDigitAdded(boolean lastDigitAdded);
}
