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

  private Resources resources;
  private String packageName;
  private PinConfigModel pinConfigModel;
  private int cursorIndex = 0;
  private int digitKeyNormalResourceId;
  private int digitKeyFocusedResourceId;
  private int deleteKeyNormalResourceId;
  private int deleteKeyFocusedResourceId;

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
    resources = getResources();
    packageName = getPackageName();

    initConfig();
    initResources();
    initPinInputs();
    initPinButtons();

    resetPin();
  }

  private void initConfig() {
    final int configurationPointer = resources.getIdentifier("pin_config", "raw", packageName);
    final JSONResourceReader jsonResourceReader = new JSONResourceReader();
    final String configString = jsonResourceReader.parse(resources, configurationPointer);
    pinConfigModel = jsonResourceReader.map(PinConfigModel.class, configString);
  }

  private void initResources() {
    digitKeyNormalResourceId = resources.getIdentifier(
        getDrawableNameFromFileName(pinConfigModel.getPinKeyNormalStateImage()),
        "drawable",
        packageName
    );
    digitKeyFocusedResourceId = resources.getIdentifier(
        getDrawableNameFromFileName(pinConfigModel.getPinKeyHighlightedStateImage()),
        "drawable",
        packageName
    );
    deleteKeyNormalResourceId = resources.getIdentifier(
        getDrawableNameFromFileName(pinConfigModel.getPinDeleteKeyNormalStateImage()),
        "drawable",
        packageName
    );
    deleteKeyFocusedResourceId = resources.getIdentifier(
        getDrawableNameFromFileName(pinConfigModel.getPinDeleteKeyHighlightedStateImage()),
        "drawable",
        packageName
    );
  }

  private void initPinInputs() {
    for (int input = 0; input < MAX_DIGITS; input++) {
      final int inputId = resources.getIdentifier("pinInput" + input, "id", packageName);
      pinInputs[input] = (TextView) findViewById(inputId);
    }
  }

  private void initPinButtons() {
    for (int digit = 0; digit < 10; digit++) {
      final int buttonId = resources.getIdentifier("pinKey" + digit, "id", packageName);
      initPinDigitButton(buttonId, digit);
    }

    final int delButtonId = resources.getIdentifier("pinKeyDel", "id", packageName);
    initPinDeleteButton(delButtonId);
  }

  private void initPinDigitButton(final int buttonId, final int buttonValue) {
    final Button pinButton = (Button) findViewById(buttonId);
    pinButton.setBackground(createDrawableForButton(digitKeyNormalResourceId, digitKeyFocusedResourceId));
    pinButton.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(final View v) {
        onDigitKeyClicked(buttonValue);
      }
    });
  }

  private void initPinDeleteButton(final int buttonId) {
    final Button deleteButton = (Button) findViewById(buttonId);
    deleteButton.setBackground(createDrawableForButton(deleteKeyNormalResourceId, deleteKeyFocusedResourceId));
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

  private String getDrawableNameFromFileName(final String filename) {
    String result = "";
    if (filename.length() > 0) {
      final int dotPosition = filename.lastIndexOf('.');
      result = filename.substring(0, dotPosition);
    }
    return result;
  }

  private StateListDrawable createDrawableForButton(final int normalStateResourceId, final int focusedStateResourceId) {
    final StateListDrawable statesDrawables = new StateListDrawable();
    statesDrawables.addState(new int[] {android.R.attr.state_pressed}, resources.getDrawable(focusedStateResourceId));
    statesDrawables.addState(new int[] {android.R.attr.state_focused}, resources.getDrawable(focusedStateResourceId));
    statesDrawables.addState(new int[] { }, resources.getDrawable(normalStateResourceId));
    return statesDrawables;
  }
}
