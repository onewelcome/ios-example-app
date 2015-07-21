package com.onegini.dialogs;

import static com.onegini.model.MessageKey.CONFIRM_POPUP_CANCEL;
import static com.onegini.model.MessageKey.CONFIRM_POPUP_OK;
import static com.onegini.model.MessageKey.DISCONNECT_FORGOT_PIN;
import static com.onegini.model.MessageKey.DISCONNECT_FORGOT_PIN_TITLE;
import static com.onegini.model.MessageKey.HELP_LINK_TITLE;
import static com.onegini.model.MessageKey.HELP_POPUP_OK;
import static com.onegini.model.MessageKey.LOGIN_PIN_KEYBOARD_TITLE;
import static com.onegini.model.MessageKey.PIN_FORGOTTEN_TITLE;
import static com.onegini.util.MessageResourceReader.getMessageForKey;

import org.apache.cordova.CordovaActivity;

import android.app.Dialog;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.content.res.Resources;
import android.graphics.Typeface;
import android.os.Bundle;
import android.text.Html;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import com.onegini.actions.ForgotPinHandler;
import com.onegini.helper.PinActivityMessageMapper;
import com.onegini.util.DeviceUtil;

public class PinScreenActivity extends CordovaActivity {

  private static final int MAX_DIGITS = 5;

  private static final String HTML_CHAR_DOT = "&#9679;";

  public static final String EXTRA_MODE = "mode";
  public static final String EXTRA_MESSAGE = "message";

  // available screen 'modes'
  public static final int SCREEN_MODE_LOGIN                     = 0;
  public static final int SCREEN_MODE_LOGIN_BEFORE_CHANGE_PIN   = 1;
  public static final int SCREEN_MODE_REGISTRATION_CREATE_PIN   = 2;
  public static final int SCREEN_MODE_REGISTRATION_CONFIRM_PIN  = 3;
  public static final int SCREEN_MODE_CHANGE_PIN_CREATE_PIN     = 4;
  public static final int SCREEN_MODE_CHANGE_PIN_CONFIRM_PIN    = 5;

  private final char[] pin = new char[MAX_DIGITS];

  private final TextView[] pinInputs = new TextView[MAX_DIGITS];
  private Resources resources;
  private String packageName;
  private Typeface customFontRegular;
  private int mode = SCREEN_MODE_LOGIN;
  private int cursorIndex = 0;
  private String screenMessage;

  private TextView screenTitleTextView;
  private TextView keyboardTitleTextView;
  private TextView pinLabelTextView;
  private TextView helpLinkTextView;
  private TextView pinForgottenTextView;
  private TextView errorTextView;

  private Button deleteButton;
  private int inputFocusedBackgroundResourceId;
  private int inputNormalBackgroundResourceId;

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
    initialize();
  }

  private void parseIntent() {
    final Intent intent = getIntent();
    screenMessage = intent.getStringExtra(EXTRA_MESSAGE);
    mode = intent.getIntExtra(EXTRA_MODE, SCREEN_MODE_LOGIN);
  }

  private void initialize() {
    parseIntent();
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

  private void initAssets() {
    final boolean isLoginMode = isLoginMode();
    String resourceName = (isLoginMode) ? "form_inactive_gray" : "form_inactive";
    inputNormalBackgroundResourceId = resources.getIdentifier(resourceName, "drawable", packageName);

    // in create pin flow focused input doesn't have "active" background
    resourceName = (isLoginMode) ? "form_inactive_gray" : "form_active";
    inputFocusedBackgroundResourceId = resources.getIdentifier(resourceName, "drawable", packageName);

    customFontRegular = Typeface.createFromAsset(getAssets(), "fonts/font_regular.ttf");
  }

  private void initLayout() {
    final String layoutFilename = (isLoginMode()) ? "login_pin_screen" : "create_pin_screen";
    setContentView(resources.getIdentifier(layoutFilename, "layout", packageName));

    initTextViews();
    initPinInputs();
    initPinButtons();
  }

  private void initTextViews() {
    initCommonTextViews();
    initKeyboardTextView();

    if (isLoginMode()) {
      initPinForgottenTextView();
    } else {
      initCreatePinTextViews();
    }

    updateTexts();
  }

  private void initCommonTextViews() {
    errorTextView = (TextView) findViewById(resources.getIdentifier("pin_error_message", "id", packageName));
    errorTextView.setTypeface(customFontRegular);

    helpLinkTextView = (TextView) findViewById(resources.getIdentifier("help_button", "id", packageName));
    helpLinkTextView.setTypeface(customFontRegular);
    helpLinkTextView.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(final View v) {
        showHelpDialog();
      }
    });
  }

  private void initKeyboardTextView() {
    // keyboard title is present in some cases
    final boolean hasKeyboardTitle = DeviceUtil.isTablet(this) || isLoginMode();
    if (hasKeyboardTitle) {
      keyboardTitleTextView = (TextView) findViewById(resources.getIdentifier("pin_keyboard_title", "id", packageName));
      keyboardTitleTextView.setTypeface(customFontRegular);
    }
  }

  private void initPinForgottenTextView() {
    pinForgottenTextView = (TextView) findViewById(resources.getIdentifier("pin_forgotten_label", "id", packageName));
    pinForgottenTextView.setTypeface(customFontRegular);
    pinForgottenTextView.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(final View v) {
        showForgetPinDialog();
      }
    });
  }

  private void initCreatePinTextViews() {
    screenTitleTextView = (TextView) findViewById(resources.getIdentifier("pin_screen_title", "id", packageName));
    screenTitleTextView.setTypeface(customFontRegular);

    pinLabelTextView = (TextView) findViewById(resources.getIdentifier("pin_info_label", "id", packageName));
    pinLabelTextView.setTypeface(customFontRegular);

    if (isRegistrationForm()) {
      initStepMarkersTextViews();
    } else {
      hideStepMarkersTextViews();
    }
  }

  private void initStepMarkersTextViews() {
    TextView stepTextView;
    for (int step = 1; step <= 3; step++) {
      stepTextView = (TextView) findViewById(resources.getIdentifier("step_marker_" + step, "id", packageName));
      stepTextView.setTypeface(customFontRegular);
    }
  }

  private void hideStepMarkersTextViews() {
    findViewById(resources.getIdentifier("steps_marker", "id", packageName)).setVisibility(View.GONE);
  }

  private void updateTexts() {
    helpLinkTextView.setText(getMessageForKey(HELP_LINK_TITLE.name()));

    if (isNotBlank(screenMessage)) {
      errorTextView.setText(screenMessage);
      errorTextView.setVisibility(View.VISIBLE);
    }

    if (isLoginMode()) {
      updateTextsInLoginMode();
    } else {
      updateTextInNonLoginMode();
    }
  }

  private void updateTextsInLoginMode() {
    keyboardTitleTextView.setText(getMessageForKey(LOGIN_PIN_KEYBOARD_TITLE.name()));
    pinForgottenTextView.setText(getMessageForKey(PIN_FORGOTTEN_TITLE.name()));
  }

  private void updateTextInNonLoginMode() {
    screenTitleTextView.setText(PinActivityMessageMapper.getTitleForScreen(mode));
    pinLabelTextView.setText(PinActivityMessageMapper.getMessageForPinLabel(mode));
    if (DeviceUtil.isTablet(this)) {
      keyboardTitleTextView.setText(PinActivityMessageMapper.getTitleForKeyboard(mode));
    }
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
      errorTextView.setVisibility(View.GONE);
      if (cursorIndex == MAX_DIGITS) {
        onMaxDigitsReached();
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

  private void onMaxDigitsReached() {
    if (mode==SCREEN_MODE_LOGIN || mode==SCREEN_MODE_LOGIN_BEFORE_CHANGE_PIN) {
      CurrentPinNativeDialogHandler.oneginiPinProvidedHandler.onPinProvided(pin);
    } else {
      CreatePinNativeDialogHandler.oneginiPinProvidedHandler.onPinProvided(pin);
    }
  }

  private void updateInputView() {
    String htmlCharacter;
    for (int i = 0; i < MAX_DIGITS; i++) {
      htmlCharacter = (pin[i] == '\0') ? "" : HTML_CHAR_DOT;
      pinInputs[i].setText(Html.fromHtml(htmlCharacter));
      pinInputs[i].setBackgroundResource(inputNormalBackgroundResourceId);
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

  private boolean isLoginMode() {
    return mode==SCREEN_MODE_LOGIN;
  }

  private boolean isRegistrationForm() {
    return mode==SCREEN_MODE_REGISTRATION_CONFIRM_PIN || mode==SCREEN_MODE_REGISTRATION_CREATE_PIN;
  }

  // todo refactor during MS-554
  private void showHelpDialog() {
    final int layoutId = resources.getIdentifier("alert_dialog", "layout", packageName);
    final int styleId = resources.getIdentifier("CustomDialogTheme", "style", packageName);

    final Dialog dialog = new Dialog(this, styleId);
    dialog.setContentView(layoutId);
    dialog.show();

    final TextView titleView = (TextView) dialog.findViewById(
        resources.getIdentifier("dialog_title", "id", packageName)
    );
    titleView.setTypeface(customFontRegular);
    titleView.setText(PinActivityMessageMapper.getTitleForHelpsScreen(mode));

    final TextView messageView = (TextView) dialog.findViewById(
        resources.getIdentifier("dialog_message", "id", packageName)
    );
    messageView.setTypeface(customFontRegular);
    messageView.setText(PinActivityMessageMapper.getMessageForHelpScreen(mode));

    final Button okButton = (Button) dialog.findViewById(
        resources.getIdentifier("dialog_ok_button", "id", packageName)
    );
    okButton.setTypeface(customFontRegular);
    okButton.setText(getMessageForKey(HELP_POPUP_OK.name()));
    okButton.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(final View v) {
        dialog.dismiss();
      }
    });
  }

  // todo refactor during MS-554
  private void showForgetPinDialog() {
    final int layoutId = resources.getIdentifier("confirm_dialog", "layout", packageName);
    final int styleId = resources.getIdentifier("CustomDialogTheme", "style", packageName);

    final Dialog dialog = new Dialog(this, styleId);
    dialog.setContentView(layoutId);
    dialog.show();

    final TextView titleView = (TextView) dialog.findViewById(
        resources.getIdentifier("dialog_title", "id", packageName)
    );
    titleView.setTypeface(customFontRegular);
    titleView.setText(getMessageForKey(DISCONNECT_FORGOT_PIN_TITLE.name()));

    final TextView messageView = (TextView) dialog.findViewById(
        resources.getIdentifier("dialog_message", "id", packageName)
    );
    messageView.setTypeface(customFontRegular);
    messageView.setText(getMessageForKey(DISCONNECT_FORGOT_PIN.name()));

    final Button okButton = (Button) dialog.findViewById(
        resources.getIdentifier("dialog_ok_button", "id", packageName)
    );
    okButton.setTypeface(customFontRegular);
    okButton.setText(getMessageForKey(CONFIRM_POPUP_OK.name()));
    okButton.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(final View v) {
        dialog.dismiss();
        ForgotPinHandler.resetPin();
      }
    });

    final Button cancelButton = (Button) dialog.findViewById(
        resources.getIdentifier("dialog_cancel_button", "id", packageName)
    );
    cancelButton.setText(getMessageForKey(CONFIRM_POPUP_CANCEL.name()));
    cancelButton.setTypeface(customFontRegular);
    cancelButton.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(final View v) {
        dialog.dismiss();
      }
    });
  }
}