package com.onegini.dialogs;

import static com.onegini.util.MessageResourceReader.getMessageForKey;
import static com.onegini.model.MessageKey.DISCONNECT_FORGOT_PIN;
import static com.onegini.model.MessageKey.DISCONNECT_FORGOT_PIN_TITLE;
import static com.onegini.model.MessageKey.CONFIRM_POPUP_CANCEL;
import static com.onegini.model.MessageKey.CONFIRM_POPUP_OK;
import static com.onegini.model.MessageKey.HELP_POPUP_OK;
import static com.onegini.model.MessageKey.HELP_LINK_TITLE;
import static com.onegini.model.MessageKey.PIN_FORGOTTEN_TITLE;
import static com.onegini.model.MessageKey.LOGIN_PIN_KEYBOARD_TITLE;
import static com.onegini.model.MessageKey.LOGIN_PIN_HELP_MESSAGE;
import static com.onegini.model.MessageKey.LOGIN_PIN_HELP_TITLE;
import static com.onegini.model.MessageKey.LOGIN_PIN_KEYBOARD_TITLE;
import static com.onegini.model.MessageKey.CREATE_PIN_SCREEN_TITLE;
import static com.onegini.model.MessageKey.CREATE_PIN_KEYBOARD_TITLE;
import static com.onegini.model.MessageKey.CREATE_PIN_INFO_LABEL;
import static com.onegini.model.MessageKey.CREATE_PIN_HELP_TITLE;
import static com.onegini.model.MessageKey.CREATE_PIN_HELP_MESSAGE;
import static com.onegini.model.MessageKey.CONFIRM_PIN_SCREEN_TITLE;
import static com.onegini.model.MessageKey.CONFIRM_PIN_KEYBOARD_TITLE;
import static com.onegini.model.MessageKey.CONFIRM_PIN_INFO_LABEL;
import static com.onegini.model.MessageKey.CONFIRM_PIN_HELP_TITLE;
import static com.onegini.model.MessageKey.CONFIRM_PIN_HELP_MESSAGE;

import org.apache.cordova.CordovaActivity;

import android.app.Dialog;
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

  public static final String EXTRA_MODE = "mode";
  public static final String EXTRA_MESSAGE = "message";

  // diffrent screen 'modes'
  public static final int SCREEN_MODE_LOGIN        = 0;
  public static final int SCREEN_MODE_CREATE_PIN   = 1;
  public static final int SCREEN_MODE_CONFIRM_PIN  = 2;

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
    final boolean isCreatePinFlow = isCreatePinFlow();
    String resourceName = (isCreatePinFlow) ? "form_inactive" : "form_inactive_gray";
    inputNormaBackgroundlResourceId = resources.getIdentifier(resourceName, "drawable", packageName);

    // in create pin flow focused imput doesn't have "active" background
    // it wasn't delivered by mobgen, so has to be fixed later
    resourceName = (isCreatePinFlow) ? "form_active" : "form_inactive_gray";
    inputFocusedBackgroundResourceId = resources.getIdentifier(resourceName, "drawable", packageName);

    customFontRegular = Typeface.createFromAsset(getAssets(), "fonts/font_regular.ttf");
  }

  private void initLayout() {
    final String layoutFilename = (isCreatePinFlow()) ? "create_pin_screen" : "login_pin_screen";
    setContentView(resources.getIdentifier(layoutFilename, "layout", packageName));

    initTextViews();
    initPinInputs();
    initPinButtons();
  }

  private void initTextViews() {
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

    keyboardTitleTextView = (TextView) findViewById(resources.getIdentifier("pin_keyboard_title", "id", packageName));
    // keyboard title is present in all cases except this one :(
    final boolean thereIsNoKeyboardTitle = (DeviceUtil.isTablet(this)==false && isCreatePinFlow());
    if (thereIsNoKeyboardTitle == false) {
      keyboardTitleTextView.setTypeface(customFontRegular);
    }

    if (isCreatePinFlow()) {
      screenTitleTextView = (TextView) findViewById(resources.getIdentifier("pin_screen_title", "id", packageName));
      screenTitleTextView.setTypeface(customFontRegular);

      pinLabelTextView = (TextView) findViewById(resources.getIdentifier("pin_info_label", "id", packageName));
      pinLabelTextView.setTypeface(customFontRegular);

      TextView stepTextView;
      for (int step = 1; step <= 3; step++) {
        stepTextView = (TextView) findViewById(resources.getIdentifier("step_marker_" + step, "id", packageName));
        stepTextView.setTypeface(customFontRegular);
      }
    }
    else {
      pinForgottenTextView = (TextView) findViewById(resources.getIdentifier("pin_forgotten_label", "id", packageName));
      pinForgottenTextView.setTypeface(customFontRegular);
      pinForgottenTextView.setOnClickListener(new View.OnClickListener() {
        @Override
        public void onClick(final View v) {
          showForgetPinDialog();
        }
      });
    }

    updateTexts();
  }

  private void updateTexts() {
    helpLinkTextView.setText(getMessageForKey(HELP_LINK_TITLE.name()));

    if (isNotBlank(screenMessage)) {
      errorTextView.setText(screenMessage);
      errorTextView.setVisibility(View.VISIBLE);
    }

    if (mode==SCREEN_MODE_CREATE_PIN) {
      screenTitleTextView.setText(getMessageForKey(CREATE_PIN_SCREEN_TITLE.name()));
      pinLabelTextView.setText(getMessageForKey(CREATE_PIN_INFO_LABEL.name()));
      if (DeviceUtil.isTablet(this)) {
        keyboardTitleTextView.setText(getMessageForKey(CREATE_PIN_KEYBOARD_TITLE.name()));
      }
    }
    else if (mode==SCREEN_MODE_CONFIRM_PIN) {
      screenTitleTextView.setText(getMessageForKey(CONFIRM_PIN_SCREEN_TITLE.name()));
      pinLabelTextView.setText(getMessageForKey(CONFIRM_PIN_INFO_LABEL.name()));
      if (DeviceUtil.isTablet(this)) {
        keyboardTitleTextView.setText(getMessageForKey(CONFIRM_PIN_KEYBOARD_TITLE.name()));
      }
    }
    else {
      keyboardTitleTextView.setText(getMessageForKey(LOGIN_PIN_KEYBOARD_TITLE.name()));
      pinForgottenTextView.setText(getMessageForKey(PIN_FORGOTTEN_TITLE.name()));
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
        if (isCreatePinFlow()) {
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

  private boolean isCreatePinFlow() {
    return (mode==SCREEN_MODE_CREATE_PIN || mode==SCREEN_MODE_CONFIRM_PIN);
  }

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
    titleView.setText(getTitleForHelpsScreen());

    final TextView messageView = (TextView) dialog.findViewById(
        resources.getIdentifier("dialog_message", "id", packageName)
    );
    messageView.setTypeface(customFontRegular);
    messageView.setText(getMessageForHelpScreen());

    final Button okButton = (Button) dialog.findViewById(
        resources.getIdentifier("dialog_ok_button", "id", packageName)
    );
    okButton.setTypeface(customFontRegular);
    okButton.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(final View v) {
        dialog.dismiss();
      }
    });
  }

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
        // TODO
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

  private String getTitleForHelpsScreen() {
    if (mode==SCREEN_MODE_LOGIN) {
      return getMessageForKey(LOGIN_PIN_HELP_TITLE.name());
    }
    else if (mode==SCREEN_MODE_CREATE_PIN) {
      return getMessageForKey(CREATE_PIN_HELP_TITLE.name());
    }
    else {
      return getMessageForKey(CONFIRM_PIN_HELP_TITLE.name());
    }
  }

  private String getMessageForHelpScreen() {
    if (mode==SCREEN_MODE_LOGIN) {
      return getMessageForKey(LOGIN_PIN_HELP_MESSAGE.name());
    }
    else if (mode==SCREEN_MODE_CREATE_PIN) {
      return getMessageForKey(CREATE_PIN_HELP_MESSAGE.name());
    }
    else {
      return getMessageForKey(CONFIRM_PIN_HELP_MESSAGE.name());
    }
  }
}