package com.onegini;

import android.app.Activity;
import android.content.res.Resources;
import android.os.Bundle;
import android.text.Html;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

public class PinScreenActivity extends Activity {

  // this const might be configurable in next sprints
  private static final int MAX_DIGITS = 5;

  private static final String HTML_CHAR_DOT = "&#9679;";
  private static final String HTML_CHAR_DASH = "&mdash;";

  private final char[] pin = new char[MAX_DIGITS];
  private final TextView[] pinInputs = new TextView[MAX_DIGITS];

  private int cursorIndex = 0;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(getResources().getIdentifier("activity_pin_screen", "layout", getPackageName()));
    init();
  }

  @Override
  protected void onResume() {
    super.onResume();
    updateInputView();
  }

  @Override
  protected void onPause() {
    resetPin();
    super.onPause();
  }

  private void init() {
    final Resources resources = getResources();
    final String packageName = getPackageName();

    for (int input = 0; input < MAX_DIGITS; input++) {
      final int inputId = resources.getIdentifier("pinInput" + input, "id", packageName);
      pinInputs[input] = (TextView) findViewById(inputId);
    }

    for (int digit = 0; digit < 10; digit++) {
      final int buttonId = resources.getIdentifier("pinKey" + digit, "id", packageName);
      initPinDigitButton(buttonId, digit);
    }

    final int delButtonId = resources.getIdentifier("pinKeyDel", "id", packageName);
    initPinDeleteButton(delButtonId);

    resetPin();
  }

  private void initPinDigitButton(final int buttonId, final int buttonValue) {
    final Button pinButton = (Button) findViewById(buttonId);
    pinButton.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(final View v) {
        onDigitKeyClicked(buttonValue);
      }
    });
  }

  private void initPinDeleteButton(final int buttonId) {
    final Button deleteButton = (Button) findViewById(buttonId);
    deleteButton.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(final View v) {
        onDeleteKeyClicked();
      }
    });
  }

  private void onDigitKeyClicked(final int digit) {
    if (cursorIndex < MAX_DIGITS) {
      pin[cursorIndex] = Character.forDigit(digit, 10);
      cursorIndex++;
      updateInputView();
    }
  }

  private void onDeleteKeyClicked() {
    if (cursorIndex > 0) {
      pin[--cursorIndex] = '\0';
      updateInputView();
    }
  }

  private void updateInputView() {
    String htmlCharacter;
    for (int i=0; i < MAX_DIGITS; i++) {
      htmlCharacter = (pin[i] == '\0') ? HTML_CHAR_DASH : HTML_CHAR_DOT;
      pinInputs[i].setText(Html.fromHtml(htmlCharacter));
    }
  }

  private String getPin() {
    final StringBuilder pinBuilder = new StringBuilder();
    for (int index = 0; index < MAX_DIGITS; index++) {
      pinBuilder.append(pin[index]);
    }
    return pinBuilder.toString();
  }

  private void resetPin() {
    for (int index = 0; index < MAX_DIGITS; index++) {
      pin[index] = '\0';
    }
  }
}
