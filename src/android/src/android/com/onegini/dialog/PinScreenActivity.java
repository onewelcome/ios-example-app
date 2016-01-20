package com.onegini.dialog;

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
import android.os.Bundle;
import android.text.Html;
import android.text.Spanned;
import android.view.View;
import android.widget.Button;
import android.widget.TableLayout;
import android.widget.TextView;
import com.onegini.action.ForgotPinHandler;
import com.onegini.dialog.helper.PinActivityMessageMapper;
import com.onegini.util.DeviceUtil;

public class PinScreenActivity extends CordovaActivity implements PinKeyboardActivity {

  private static final int MAX_DIGITS = 5;

  private static final Spanned HTML_CHAR_DOT = Html.fromHtml("&#9679;");

  public static final String EXTRA_MODE = "mode";
  public static final String EXTRA_MESSAGE = "message";

  // available screen 'modes'
  public static final int SCREEN_MODE_LOGIN                     = 0;
  public static final int SCREEN_MODE_LOGIN_BEFORE_CHANGE_PIN   = 1;
  public static final int SCREEN_MODE_REGISTRATION_CREATE_PIN   = 2;
  public static final int SCREEN_MODE_REGISTRATION_CONFIRM_PIN  = 3;
  public static final int SCREEN_MODE_CHANGE_PIN_CREATE_PIN     = 4;
  public static final int SCREEN_MODE_CHANGE_PIN_CONFIRM_PIN    = 5;

  private final TextView[] pinInputs = new TextView[MAX_DIGITS];
  private Resources resources;
  private String packageName;
  private int mode = SCREEN_MODE_LOGIN;
  private String screenMessage;
  private PinKeyboard pinKeyboard;
  private int cursorIndex = 0;

  private TextView screenTitleTextView;
  private TextView keyboardTitleTextView;
  private TextView pinLabelTextView;
  private TextView helpLinkTextView;
  private TextView pinForgottenTextView;
  private TextView errorTextView;


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
    resetView();
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
    initKeyboard();
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
    inputNormalBackgroundResourceId = resources.getIdentifier("form_inactive", "drawable", packageName);
    inputFocusedBackgroundResourceId = resources.getIdentifier("form_active", "drawable", packageName);
  }

  private void initLayout() {
    setContentView(resources.getIdentifier("pin_screen", "layout", packageName));

    initTextViews();
    initPinInputs();
  }

  private void initKeyboard() {
    if (mode == SCREEN_MODE_LOGIN || mode == SCREEN_MODE_LOGIN_BEFORE_CHANGE_PIN) {
      pinKeyboard = new PinKeyboard(this, MAX_DIGITS, CurrentPinNativeDialogHandler.oneginiPinProvidedHandler);
    } else {
      pinKeyboard = new PinKeyboard(this, MAX_DIGITS, CreatePinNativeDialogHandler.oneginiPinProvidedHandler);
    }
  }

  private void initTextViews() {
    initCommonTextViews();
    initKeyboardTextView();
    updateTexts();
  }

  private void initCommonTextViews() {
    errorTextView = (TextView) findViewById(resources.getIdentifier("pin_error_message", "id", packageName));
    errorTextView.setVisibility(View.INVISIBLE);

    helpLinkTextView = (TextView) findViewById(resources.getIdentifier("help_button", "id", packageName));
    helpLinkTextView.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(final View v) {
        showHelpDialog();
      }
    });

    pinForgottenTextView = (TextView) findViewById(resources.getIdentifier("pin_forgotten_label", "id", packageName));
    if (isLoginMode()) {
      pinForgottenTextView.setVisibility(View.VISIBLE);
      pinForgottenTextView.setOnClickListener(new View.OnClickListener() {
        @Override
        public void onClick(final View v) {
          showForgetPinDialog();
        }
      });
    } else {
      pinForgottenTextView.setVisibility(View.GONE);
    }

  }

  private void initKeyboardTextView() {
    // keyboard title is present in some cases
    final boolean hasKeyboardTitle = DeviceUtil.isTablet(this) || isLoginMode();
    if (hasKeyboardTitle) {
      keyboardTitleTextView = (TextView) findViewById(resources.getIdentifier("pin_keyboard_title", "id", packageName));
    }
  }

  /*private void initCreatePinTextViews() {
    screenTitleTextView = (TextView) findViewById(resources.getIdentifier("pin_screen_title", "id", packageName));
    pinLabelTextView = (TextView) findViewById(resources.getIdentifier("pin_info_label", "id", packageName));
  }*/

  private void updateTexts() {
    helpLinkTextView.setText(getMessageForKey(HELP_LINK_TITLE.name()));

    if (isNotBlank(screenMessage)) {
      errorTextView.setText(screenMessage);
      errorTextView.setVisibility(View.VISIBLE);
    }

    /*if (isLoginMode()) {
      updateTextsInLoginMode();
    } else {
      updateTextInNonLoginMode();
    }*/
  }

  /*private void updateTextsInLoginMode() {
    keyboardTitleTextView.setText(getMessageForKey(LOGIN_PIN_KEYBOARD_TITLE.name()));
    pinForgottenTextView.setText(getMessageForKey(PIN_FORGOTTEN_TITLE.name()));
  }

  private void updateTextInNonLoginMode() {
    screenTitleTextView.setText(PinActivityMessageMapper.getTitleForScreen(mode));
    pinLabelTextView.setText(PinActivityMessageMapper.getMessageForPinLabel(mode));
    if (DeviceUtil.isTablet(this)) {
      keyboardTitleTextView.setText(PinActivityMessageMapper.getTitleForKeyboard(mode));
    }
  }*/

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

  @Override
  public TableLayout getKeyboardLayout() {
    return (TableLayout) findViewById(resources.getIdentifier("pin_keyboard", "id", packageName));
  }

  @Override
  public void onDeleteKeyClicked() {
    pinInputs[cursorIndex].setBackgroundResource(inputNormalBackgroundResourceId);
    cursorIndex--;
    pinInputs[cursorIndex].setText("");
    pinInputs[cursorIndex].setBackgroundResource(inputFocusedBackgroundResourceId);
  }

  @Override
  public void onDigitKeyClicked(final boolean lastDigitReceived) {
    pinInputs[cursorIndex].setText(HTML_CHAR_DOT);
    pinInputs[cursorIndex].setBackgroundResource(inputNormalBackgroundResourceId);

    if (lastDigitReceived) {
      errorTextView.setVisibility(View.INVISIBLE);
    } else {
      cursorIndex++;
      pinInputs[cursorIndex].setText("");
      pinInputs[cursorIndex].setBackgroundResource(inputFocusedBackgroundResourceId);
    }
  }

  private void resetView() {
    cursorIndex = 0;
    pinKeyboard.reset();
    for (int i = 0; i < MAX_DIGITS; i++) {
      pinInputs[i].setText("");
      pinInputs[i].setBackgroundResource(inputNormalBackgroundResourceId);
    }
    pinInputs[cursorIndex].setBackgroundResource(inputFocusedBackgroundResourceId);
  }

  private boolean isLoginMode() {
    return mode == SCREEN_MODE_LOGIN;
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
    titleView.setText(PinActivityMessageMapper.getTitleForHelpsScreen(mode));

    final TextView messageView = (TextView) dialog.findViewById(
        resources.getIdentifier("dialog_message", "id", packageName)
    );
    messageView.setText(PinActivityMessageMapper.getMessageForHelpScreen(mode));

    final Button okButton = (Button) dialog.findViewById(
        resources.getIdentifier("dialog_ok_button", "id", packageName)
    );
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
    titleView.setText(getMessageForKey(DISCONNECT_FORGOT_PIN_TITLE.name()));

    final TextView messageView = (TextView) dialog.findViewById(
        resources.getIdentifier("dialog_message", "id", packageName)
    );
    messageView.setText(getMessageForKey(DISCONNECT_FORGOT_PIN.name()));

    final Button okButton = (Button) dialog.findViewById(
        resources.getIdentifier("dialog_ok_button", "id", packageName)
    );
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
    cancelButton.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(final View v) {
        dialog.dismiss();
      }
    });
  }
}