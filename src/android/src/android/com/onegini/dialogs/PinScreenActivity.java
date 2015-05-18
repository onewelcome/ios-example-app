package com.onegini.dialogs;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaActivity;

import static com.onegini.responses.OneginiAuthorizationResponse.AUTHORIZATION_ERROR_PIN_FORGOTTEN;

import android.content.pm.ActivityInfo;
import android.content.Intent;
import android.content.res.Resources;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.StateListDrawable;
import android.os.Bundle;
import android.text.Html;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import com.onegini.actions.AuthorizeAction;
import com.onegini.model.PinConfigModel;
import com.onegini.util.CallbackResultBuilder;
import com.onegini.util.DeviceUtil;
import com.onegini.util.JSONResourceReader;

public class PinScreenActivity extends CordovaActivity {

  // this const might be configurable in next sprints
  private static final int MAX_DIGITS = 5;

  private static final String HTML_CHAR_DOT = "&#9679;";
  private static final String HTML_CHAR_DASH = "&mdash;";

  public static final String EXTRA_SCREEN_TITLE = "title";
  public static final String EXTRA_MESSAGE = "message";
  public static final String EXTRA_CREATE_PIN_FLOW = "createPinFlow";
  public static final String EXTRA_KEEP_CURRENT_FLOW = "keepCurrentFlow";

  private int deleteKeyNormalResourceId;
  private final char[] pin = new char[MAX_DIGITS];

  private final TextView[] pinInputs = new TextView[MAX_DIGITS];
  private Resources resources;
  private String packageName;
  private PinConfigModel pinConfigModel;
  private Typeface customFontRegular;
  private Typeface customFontLight;
  private int cursorIndex = 0;
  private boolean isCreatePinFlow;
  private String screenTitle;
  private String screenMessage;

  private TextView titleTextView;
  private TextView pinForgottenTextView;
  private TextView errorTextView;
  private TextView pinLabelTextView;

  private Button deleteButton;
  private int logoResourceId;
  private int digitKeyNormalResourceId;
  private int digitKeyFocusedResourceId;

  private int deleteKeyFocusedResourceId;

  private static PinScreenActivity instance;

  public static PinScreenActivity getInstance() {
    return instance;
  }

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    resources = getResources();
    packageName = getPackageName();
    setContentView(resources.getIdentifier("activity_pin_screen", "layout", packageName));
    initialize();
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
    parseIntent();
    updateTexts();
    resetPin();
  }

  private void parseIntent() {
    final Intent intent = getIntent();
    screenTitle = intent.getStringExtra(EXTRA_SCREEN_TITLE);
    screenMessage = intent.getStringExtra(EXTRA_MESSAGE);
    // if KEEP_CURRENT_FLOW flag was set then we don't change isCreatePinFlow value
    if (intent.getBooleanExtra(EXTRA_KEEP_CURRENT_FLOW, false) == false) {
      isCreatePinFlow = intent.getBooleanExtra(EXTRA_CREATE_PIN_FLOW, false);
    }
  }

  private void initialize() {
    lockScreenOrientation();
    parseIntent();
    initConfig();
    initAssets();
    initLayout();
    resetPin();
  }

  @Override
  public void onBackPressed() {
    // we don't want to be able to go back from the pin screen
    return;
  }

  private void lockScreenOrientation() {
    if (DeviceUtil.isTablet(this)) {
      setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
    }
    else {
      setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
    }
  }

  private void initConfig() {
    final int configurationPointer = resources.getIdentifier("pin_config", "raw", packageName);
    final JSONResourceReader jsonResourceReader = new JSONResourceReader();
    final String configString = jsonResourceReader.parse(resources, configurationPointer);
    pinConfigModel = jsonResourceReader.map(PinConfigModel.class, configString);
  }

  private void initAssets() {
    logoResourceId = resources.getIdentifier(
        getDrawableNameFromFileName(pinConfigModel.getLogoImage()),
        "drawable",
        packageName
    );

    digitKeyNormalResourceId = resources.getIdentifier(
        getDrawableNameFromFileName(pinConfigModel.getKeyNormalStateImage()),
        "drawable",
        packageName
    );
    digitKeyFocusedResourceId = resources.getIdentifier(
        getDrawableNameFromFileName(pinConfigModel.getKeyHighlightedStateImage()),
        "drawable",
        packageName
    );
    deleteKeyNormalResourceId = resources.getIdentifier(
        getDrawableNameFromFileName(pinConfigModel.getDeleteKeyNormalStateImage()),
        "drawable",
        packageName
    );
    deleteKeyFocusedResourceId = resources.getIdentifier(
        getDrawableNameFromFileName(pinConfigModel.getDeleteKeyHighlightedStateImage()),
        "drawable",
        packageName
    );

    customFontRegular = Typeface.createFromAsset(getAssets(), "fonts/font_regular.ttf");
    customFontLight = Typeface.createFromAsset(getAssets(), "fonts/font_light.ttf");
  }

  private void initLayout() {
    setContentView(resources.getIdentifier("activity_pin_screen", "layout", packageName));
    initLogo();
    initTextViews();
    initBackgrounds();
    initPinInputs();
    initPinButtons();
  }

  private void initLogo() {
    final int logoId = resources.getIdentifier("pin_logo", "id", packageName);
    final ImageView logo = (ImageView) findViewById(logoId);
    logo.setImageResource(logoResourceId);
  }

  private void initTextViews() {
    titleTextView = (TextView) findViewById(resources.getIdentifier("pin_title", "id", packageName));
    pinForgottenTextView = (TextView) findViewById(resources.getIdentifier("pin_forgotten_label", "id", packageName));
    errorTextView = (TextView) findViewById(resources.getIdentifier("pin_error", "id", packageName));
    pinLabelTextView = (TextView) findViewById(resources.getIdentifier("pin_small_label", "id", packageName));

    titleTextView.setTypeface(customFontRegular);
    pinForgottenTextView.setTypeface(customFontRegular);
    errorTextView.setTypeface(customFontRegular);
    pinLabelTextView.setTypeface(customFontRegular);

    updateTexts();
  }

  private void updateTexts() {
    if (isNotBlank(screenTitle)) {
      titleTextView.setText(screenTitle);
    }

    if (isNotBlank(screenMessage)) {
      errorTextView.setText(screenMessage);
      errorTextView.setVisibility(View.VISIBLE);
    }
    else {
      errorTextView.setText("");
      errorTextView.setVisibility(View.GONE);
    }

    pinForgottenTextView.setVisibility( isCreatePinFlow ? View.GONE : View.VISIBLE);
    pinForgottenTextView.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(final View v) {
        final CallbackContext callbackContext = AuthorizeAction.getCallbackContext();
        if (callbackContext != null) {
          callbackContext.sendPluginResult(
              new CallbackResultBuilder()
                  .withErrorReason(AUTHORIZATION_ERROR_PIN_FORGOTTEN.getName())
                  .build()
          );
          PinScreenActivity.this.finish();
        }
      }
    });
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

  private void initBackgrounds() {
    final int backgroundColor = Color.parseColor(pinConfigModel.getBackgroundColor());
    final int foregroundColor = Color.parseColor(pinConfigModel.getForegroundColor());

    final int backgroundId = resources.getIdentifier("pin_background", "id", packageName);
    findViewById(backgroundId).setBackgroundColor(backgroundColor);

    final int dividerId = resources.getIdentifier("pin_divider", "id", packageName);
    findViewById(dividerId).setBackgroundColor(backgroundColor);

    final int foregroundId = resources.getIdentifier("pin_foreground", "id", packageName);
    findViewById(foregroundId).setBackgroundColor(foregroundColor);

    final int headerId = resources.getIdentifier("pin_header", "id", packageName);
    findViewById(headerId).setBackgroundColor(foregroundColor);
  }

  private void initPinInputs() {
    for (int input = 0; input < MAX_DIGITS; input++) {
      final int inputId = resources.getIdentifier("pin_input_" + input, "id", packageName);
      pinInputs[input] = (TextView) findViewById(inputId);
    }
  }

  private void initPinButtons() {
    for (int digit = 0; digit < 10; digit++) {
      final int buttonId = resources.getIdentifier("pin_key_" + digit, "id", packageName);
      initPinDigitButton(buttonId, digit);
    }

    final int delButtonId = resources.getIdentifier("pin_key_del", "id", packageName);
    initPinDeleteButton(delButtonId);
  }

  private void initPinDigitButton(final int buttonId, final int buttonValue) {
    final Button pinButton = (Button) findViewById(buttonId);
    pinButton.setBackground(createDrawableForButton(digitKeyNormalResourceId, digitKeyFocusedResourceId));
    pinButton.setTypeface(customFontLight);
    pinButton.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(final View v) {
        onDigitKeyClicked(buttonValue);
      }
    });
  }

  private void initPinDeleteButton(final int buttonId) {
    deleteButton = (Button) findViewById(buttonId);
    deleteButton.setBackground(createDrawableForButton(deleteKeyNormalResourceId, deleteKeyFocusedResourceId));
    deleteButton.setTypeface(customFontLight);
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
      errorTextView.setVisibility(View.GONE);
      if (cursorIndex == MAX_DIGITS) {
        if (isCreatePinFlow) {
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
        deleteButton.setVisibility(View.GONE);
      }
    }
  }

  private void updateInputView() {
    String htmlCharacter;
    for (int i = 0; i < MAX_DIGITS; i++) {
      htmlCharacter = (pin[i] == '\0') ? HTML_CHAR_DASH : HTML_CHAR_DOT;
      pinInputs[i].setText(Html.fromHtml(htmlCharacter));
    }
  }

  private void resetPin() {
    for (int index = 0; index < MAX_DIGITS; index++) {
      pin[index] = '\0';
    }
    deleteButton.setVisibility(View.GONE);
    cursorIndex = 0;
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
    statesDrawables.addState(new int[]{ android.R.attr.state_pressed }, resources.getDrawable(focusedStateResourceId));
    statesDrawables.addState(new int[]{ android.R.attr.state_focused }, resources.getDrawable(focusedStateResourceId));
    statesDrawables.addState(new int[]{ }, resources.getDrawable(normalStateResourceId));
    return statesDrawables;
  }
}
