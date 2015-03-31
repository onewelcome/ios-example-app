package com.onegini;

import android.app.Activity;
import android.content.res.Resources;
import android.graphics.drawable.StateListDrawable;
import android.os.Bundle;
import android.text.Html;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import com.onegini.model.PinConfigModel;
import com.onegini.util.JSONResourceReader;

public class PinScreenActivity extends Activity {

  // this const might be configurable in next sprints
  private static final int MAX_DIGITS = 5;

  private static final String HTML_CHAR_DOT = "&#9679;";
  private static final String HTML_CHAR_DASH = "&mdash;";

  private final char[] pin = new char[MAX_DIGITS];
  private final TextView[] pinInputs = new TextView[MAX_DIGITS];

  private final StateListDrawable digitButtonsStatesDrawables = new StateListDrawable();
  private final StateListDrawable deleteButtonStatesDrawables = new StateListDrawable();

  private PinConfigModel pinConfigModel;
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

    initPinConfig(resources, packageName);
    initButtonStatesDrawables(resources, packageName);
    initPinInputs(resources, packageName);
    initPinButtons(resources, packageName);

    resetPin();
  }

  private void initPinConfig(final Resources resources, final String packageName) {
    final int configurationPointer = resources.getIdentifier("pin_config", "raw", packageName);
    final JSONResourceReader jsonResourceReader = new JSONResourceReader();
    final String configString = jsonResourceReader.parse(resources, configurationPointer);
    pinConfigModel = jsonResourceReader.map(PinConfigModel.class, configString);
  }

  private void initButtonStatesDrawables(final Resources resources, final String packageName) {
    final int digitKeyNormalResourceId = resources.getIdentifier("pin_key_normal", "drawable", packageName);
    final int digitKeyFocusedResourceId = resources.getIdentifier("pin_key_highlighted", "drawable", packageName);

    digitButtonsStatesDrawables.addState(
        new int[] {android.R.attr.state_pressed}, getResources().getDrawable(digitKeyFocusedResourceId)
    );

    digitButtonsStatesDrawables.addState(
        new int[] {android.R.attr.state_focused}, getResources().getDrawable(digitKeyFocusedResourceId)
    );
    digitButtonsStatesDrawables.addState(
        new int[] { }, getResources().getDrawable(digitKeyNormalResourceId)
    );

    final int delKeyNormalResourceId = resources.getIdentifier("pin_delete_key_normal", "drawable", packageName);
    final int delKeyFocusedResourceId = resources.getIdentifier("pin_delete_key_highlighted", "drawable", packageName);

    deleteButtonStatesDrawables.addState(
        new int[] {android.R.attr.state_pressed}, getResources().getDrawable(delKeyFocusedResourceId)
    );
    deleteButtonStatesDrawables.addState(
        new int[] {android.R.attr.state_focused}, getResources().getDrawable(delKeyFocusedResourceId)
    );
    deleteButtonStatesDrawables.addState(
        new int[] { }, getResources().getDrawable(delKeyNormalResourceId)
    );
  }

  private void initPinInputs(final Resources resources, final String packageName) {
    for (int input = 0; input < MAX_DIGITS; input++) {
      final int inputId = resources.getIdentifier("pinInput" + input, "id", packageName);
      pinInputs[input] = (TextView) findViewById(inputId);
    }
  }

  private void initPinButtons(final Resources resources, final String packageName) {
    for (int digit = 0; digit < 10; digit++) {
      final int buttonId = resources.getIdentifier("pinKey" + digit, "id", packageName);
      initPinDigitButton(buttonId, digit);
    }

    final int delButtonId = resources.getIdentifier("pinKeyDel", "id", packageName);
    initPinDeleteButton(delButtonId);
  }

  private void initPinDigitButton(final int buttonId, final int buttonValue) {
    final Button pinButton = (Button) findViewById(buttonId);
    pinButton.setBackground(digitButtonsStatesDrawables.mutate());
    pinButton.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(final View v) {
        onDigitKeyClicked(buttonValue);
      }
    });
  }

  private void initPinDeleteButton(final int buttonId) {
    final Button deleteButton = (Button) findViewById(buttonId);
    deleteButton.setBackground(deleteButtonStatesDrawables);
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
