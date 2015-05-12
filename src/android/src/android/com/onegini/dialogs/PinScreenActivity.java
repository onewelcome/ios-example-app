package com.onegini.dialogs;

import org.apache.cordova.CordovaActivity;

import android.content.pm.ActivityInfo;
import android.content.Intent;
import android.content.res.Resources;
import android.graphics.Typeface;
import android.os.Bundle;
import android.text.Html;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import com.onegini.util.DeviceUtil;

public class PinScreenActivity extends CordovaActivity {

  private static final int MAX_DIGITS = 5;

  private static final String HTML_CHAR_DOT = "&#9679;";

  private static boolean isCreatePinFlow;

  public static void setCreatePinFlow(final boolean isCreatePinFlow) {
    PinScreenActivity.isCreatePinFlow = isCreatePinFlow;
  }

  private final char[] pin = new char[MAX_DIGITS];

  private final TextView[] pinInputs = new TextView[MAX_DIGITS];
  private Resources resources;
  private String packageName;
  private Typeface customFontRegular;
  private Typeface customFontLight;
  private int cursorIndex = 0;

  private TextView titleTextView;
  private TextView pinForgottenTextView;
  //private TextView errorTextView;
  private TextView pinLabelTextView;

  private Button deleteButton;
  private int inputFocusedBackgroundResourceId;
  private int inputNormaBackgroundlResourceId;

  private static PinScreenActivity instance;

  public static PinScreenActivity getInstance() {
    return instance;
  }

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    lockScreenOrientation();
    resources = getResources();
    packageName = getPackageName();
    initialize();
    resetPin();
    instance = this;
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

  @Override
  protected void onNewIntent(final Intent intent) {
    setIntent(intent);
    updateTexts(intent);
    resetPin();
  }

  private void lockScreenOrientation() {
    if (DeviceUtil.isTablet(this)) {
      setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
    }
    else {
      setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
    }
  }

  private void initialize() {
    initAssets();
    initLayout();
  }

  private void initAssets() {
    String resourceName = (isCreatePinFlow) ? "form_inactive" : "form_inactive_gray";
    inputNormaBackgroundlResourceId = resources.getIdentifier(resourceName, "drawable", packageName);

    // in create pin flow focused imput doesn't have "active" background
    // it wasn't delivered by mobgen, so has to be fixed later
    resourceName = (isCreatePinFlow) ? "form_active" : "form_inactive_gray";
    inputFocusedBackgroundResourceId = resources.getIdentifier(resourceName, "drawable", packageName);

    customFontRegular = Typeface.createFromAsset(getAssets(), "fonts/font_regular.ttf");
    customFontLight = Typeface.createFromAsset(getAssets(), "fonts/font_light.ttf");
  }

  private void initLayout() {
    final String layoutFilename = (isCreatePinFlow) ? "create_pin_screen" : "login_pin_screen";
    setContentView(resources.getIdentifier(layoutFilename, "layout", packageName));

    initTextViews();
    initPinInputs();
    initPinButtons();
  }

  private void initTextViews() {
    titleTextView = (TextView) findViewById(resources.getIdentifier("pin_title", "id", packageName));
    pinForgottenTextView = (TextView) findViewById(resources.getIdentifier("pin_forgotten_label", "id", packageName));
    //errorTextView = (TextView) findViewById(resources.getIdentifier("pin_error", "id", packageName));
    //pinLabelTextView = (TextView) findViewById(resources.getIdentifier("pin_small_label", "id", packageName));

    titleTextView.setTypeface(customFontRegular);

    if (isCreatePinFlow) {
      TextView stepTextView;
      for (int step = 1; step <= 3; step++) {
        stepTextView = (TextView) findViewById(resources.getIdentifier("step_marker_" + step, "id", packageName));
        stepTextView.setTypeface(customFontRegular);
      }
    }
    else {
      pinForgottenTextView.setTypeface(customFontRegular);
    }

    //errorTextView.setTypeface(customFontRegular);
    //pinLabelTextView.setTypeface(customFontRegular);

    updateTexts(getIntent());
  }

  private void updateTexts(final Intent intent) {
    final String title = intent.getStringExtra("title");
    if (isNotBlank(title)) {
      titleTextView.setText(title);
    }

    /*final String message = intent.getStringExtra("message");
    if (isNotBlank(message)) {
      errorTextView.setText(message);
      errorTextView.setVisibility(View.VISIBLE);
    }
    else {
      errorTextView.setText("");
      errorTextView.setVisibility(View.GONE);
    }*/
  }

  private boolean isNotBlank(final String string) {
    return !isBlank(string);
  }

  private boolean isBlank(final String string) {
    if (string == null || string.length() == 0) {
      return true;
    }
    return false;
  }

  private void initPinInputs() {
    for (int input = 0; input < MAX_DIGITS; input++) {
      final int inputId = resources.getIdentifier("pin_input_" + input, "id", packageName);
      pinInputs[input] = (TextView) findViewById(inputId);
    }
  }

  private void initPinButtons() {
    int buttonId;
    for (int digit = 0; digit < 10; digit++) {
      buttonId = resources.getIdentifier("pin_key_" + digit, "id", packageName);
      initPinDigitButton(buttonId, digit);
    }

    final int delButtonId = resources.getIdentifier("pin_key_del", "id", packageName);
    initPinDeleteButton(delButtonId);
  }

  private void initPinDigitButton(final int buttonId, final int buttonValue) {
    final Button pinButton = (Button) findViewById(buttonId);
    pinButton.setTypeface(customFontRegular);
    pinButton.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(final View v) {
        onDigitKeyClicked(buttonValue);
      }
    });
  }

  private void initPinDeleteButton(final int buttonId) {
    deleteButton = (Button) findViewById(buttonId);
    deleteButton.setTypeface(customFontRegular);
    deleteButton.setText(Html.fromHtml("&larr;"));
    deleteButton.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(final View v) {
        onDeleteKeyClicked();
      }
    });
  }

  private void onDigitKeyClicked(final int digit) {
    if (cursorIndex < MAX_DIGITS) {
      pin[cursorIndex++] = Character.forDigit(digit, 10);
      updateInputView();
      deleteButton.setVisibility(View.VISIBLE);
      //errorTextView.setVisibility(View.GONE);
      if (cursorIndex == MAX_DIGITS) {
        if (PinScreenActivity.isCreatePinFlow) {
          CreatePinNativeDialogHandler.oneginiPinProvidedHandler.onPinProvided(pin);
        }
        else {
          CurrentPinNativeDialogHandler.oneginiPinProvidedHandler.onPinProvided(pin);
        }
      }
    }
  }

  private void onDeleteKeyClicked() {
    if (cursorIndex > 0) {
      pin[--cursorIndex] = '\0';
      updateInputView();
      if (cursorIndex == 0) {
        deleteButton.setVisibility(View.INVISIBLE);
      }
    }
  }

  private void updateInputView() {
    String htmlCharacter;
    for (int i = 0; i < MAX_DIGITS; i++) {
      htmlCharacter = (pin[i] == '\0') ? "" : HTML_CHAR_DOT;
      pinInputs[i].setText(Html.fromHtml(htmlCharacter));
      pinInputs[i].setBackgroundResource(inputNormaBackgroundlResourceId);
    }
    if (cursorIndex < MAX_DIGITS) {
      pinInputs[cursorIndex].setBackgroundResource(inputFocusedBackgroundResourceId);
    }
  }

  private void resetPin() {
    for (int index = 0; index < MAX_DIGITS; index++) {
      pin[index] = '\0';
    }
    deleteButton.setVisibility(View.INVISIBLE);
    cursorIndex = 0;
  }
}
