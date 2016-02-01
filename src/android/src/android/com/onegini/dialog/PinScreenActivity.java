package com.onegini.dialog;

import static com.onegini.model.MessageKey.CONFIRM_POPUP_CANCEL;
import static com.onegini.model.MessageKey.CONFIRM_POPUP_OK;
import static com.onegini.model.MessageKey.DISCONNECT_FORGOT_PIN;
import static com.onegini.model.MessageKey.DISCONNECT_FORGOT_PIN_TITLE;
import static com.onegini.model.MessageKey.HELP_LINK_TITLE;
import static com.onegini.model.MessageKey.HELP_POPUP_OK;
import static com.onegini.util.MessageResourceReader.getMessageForKey;

import org.apache.cordova.CordovaActivity;

import android.app.Dialog;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.content.res.Resources;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TableLayout;
import android.widget.TextView;
import com.onegini.action.ForgotPinHandler;
import com.onegini.dialog.helper.PinActivityMessageMapper;
import com.onegini.dialog.helper.PinKeyboardHandler;
import com.onegini.dialog.helper.PinKeyboardHandler.PinProvidedListener;
import com.onegini.mobile.sdk.android.library.handlers.OneginiPinProvidedHandler;
import com.onegini.util.DeviceUtil;

public class PinScreenActivity extends CordovaActivity {

  private static final int MAX_DIGITS = 5;

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

  private TextView screenTitleTextView;
  private TextView helpLinkTextView;
  private TextView pinForgottenTextView;
  private TextView errorTextView;

  private PinKeyboardHandler pinKeyboardHandler;
  private OnClickListener helpButtonListener;
  private OnClickListener pinForgottenListener;
  private PinProvidedListener pinProvidedListener;

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
    initListeners();
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

  private void initLayout() {
    setContentView(resources.getIdentifier("pin_screen", "layout", packageName));
    initTextViews();
    initPinInputs();
  }

  private void initKeyboard() {
    pinKeyboardHandler = new PinKeyboardHandler(pinProvidedListener, pinInputs);
    pinKeyboardHandler.setInputFocusedBackgroundResourceId(resources.getIdentifier("form_active", "drawable", packageName));
    pinKeyboardHandler.setInputNormalBackgroundResourceId(resources.getIdentifier("form_inactive", "drawable", packageName));
    pinKeyboard = new PinKeyboard(pinKeyboardHandler);

    final TableLayout keyboardLayout = (TableLayout) findViewById(resources.getIdentifier("pin_keyboard", "id", packageName));
    pinKeyboard.initLayout(keyboardLayout, getResources(), getPackageName());
  }

  private void initTextViews() {
    initCommonTextViews();
    updateTexts();
  }

  private void initCommonTextViews() {
    errorTextView = (TextView) findViewById(resources.getIdentifier("pin_error_message", "id", packageName));
    errorTextView.setVisibility(View.INVISIBLE);

    helpLinkTextView = (TextView) findViewById(resources.getIdentifier("help_button", "id", packageName));
    helpLinkTextView.setOnClickListener(helpButtonListener);

    pinForgottenTextView = (TextView) findViewById(resources.getIdentifier("pin_forgotten_label", "id", packageName));
    pinForgottenTextView.setVisibility(isLoginMode() ? View.VISIBLE : View.GONE);
    pinForgottenTextView.setOnClickListener(pinForgottenListener);

    screenTitleTextView = (TextView) findViewById(resources.getIdentifier("pin_screen_title", "id", packageName));
  }

  private void initListeners() {
    pinProvidedListener = new PinProvidedListener() {
      @Override
      public void onPinProvided(final char[] pin) {
        errorTextView.setVisibility(View.INVISIBLE);
        // slightly delay the SDK call, so it won't make a lag during UI changes
        final Handler handler = new Handler();
        handler.postDelayed(new Runnable() {
          @Override
          public void run() {
            getPinProvidedHandler().onPinProvided(pin);
          }
        }, 100);
      }
    };

    helpButtonListener = new OnClickListener() {
      @Override
      public void onClick(final View v) {
        showHelpDialog();
      }
    };

    pinForgottenListener = new OnClickListener() {
      @Override
      public void onClick(final View v) {
        showForgetPinDialog();
      }
    };
  }

  private void updateTexts() {
    screenTitleTextView.setText(PinActivityMessageMapper.getTitleForScreen(mode));
    helpLinkTextView.setText(getMessageForKey(HELP_LINK_TITLE.name()));

    if (isNotBlank(screenMessage)) {
      errorTextView.setText(screenMessage);
      errorTextView.setVisibility(View.VISIBLE);
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

  private OneginiPinProvidedHandler getPinProvidedHandler() {
    if (mode == SCREEN_MODE_LOGIN || mode == SCREEN_MODE_LOGIN_BEFORE_CHANGE_PIN) {
      return CurrentPinNativeDialogHandler.oneginiPinProvidedHandler;
    } else {
      return CreatePinNativeDialogHandler.oneginiPinProvidedHandler;
    }
  }

  private void initPinInputs() {
    for (int input = 0; input < MAX_DIGITS; input++) {
      final int inputId = resources.getIdentifier("pin_input_" + input, "id", packageName);
      pinInputs[input] = (TextView) findViewById(inputId);
    }
  }

  private void resetView() {
    pinKeyboardHandler.reset();
  }

  private boolean isLoginMode() {
    return mode == SCREEN_MODE_LOGIN;
  }

  private void showHelpDialog() {
    final Dialog dialog = createStyledDialog("alert_dialog");
    dialog.show();

    setDialogTitle(dialog, PinActivityMessageMapper.getTitleForHelpsScreen(mode));
    setDialogMessage(dialog, PinActivityMessageMapper.getMessageForHelpScreen(mode));
    prepareOkButton(dialog, getMessageForKey(HELP_POPUP_OK.name()), new OnClickListener() {
      @Override
      public void onClick(final View v) {
        dialog.dismiss();
      }
    });
  }

  private void showForgetPinDialog() {
    final Dialog dialog = createStyledDialog("confirm_dialog");
    dialog.show();

    setDialogTitle(dialog, getMessageForKey(DISCONNECT_FORGOT_PIN_TITLE.name()));
    setDialogMessage(dialog, getMessageForKey(DISCONNECT_FORGOT_PIN.name()));
    prepareOkButton(dialog, getMessageForKey(CONFIRM_POPUP_OK.name()), new OnClickListener() {
      @Override
      public void onClick(final View v) {
        dialog.dismiss();
        ForgotPinHandler.resetPin();
      }
    });
    prepareCancelButton(dialog);
  }

  private Dialog createStyledDialog(final String dialogLayoutName) {
    final int layoutId = resources.getIdentifier(dialogLayoutName, "layout", packageName);
    final int styleId = resources.getIdentifier("CustomDialogTheme", "style", packageName);

    final Dialog dialog = new Dialog(this, styleId);
    dialog.setContentView(layoutId);
    return dialog;
  }

  private void setDialogTitle(final Dialog dialog, final String title) {
    final TextView titleView = (TextView) dialog.findViewById(resources.getIdentifier("dialog_title", "id", packageName));
    titleView.setText(title);
  }

  private void setDialogMessage(final Dialog dialog, final String message) {
    final TextView messageView = (TextView) dialog.findViewById(resources.getIdentifier("dialog_message", "id", packageName));
    messageView.setText(message);
  }

  private void prepareOkButton(final Dialog dialog, final String title, final OnClickListener listener) {
    final Button okButton = (Button) dialog.findViewById(resources.getIdentifier("dialog_ok_button", "id", packageName));
    okButton.setText(title);
    okButton.setOnClickListener(listener);
  }

  private void prepareCancelButton(final Dialog dialog) {
    final Button cancelButton = (Button) dialog.findViewById(resources.getIdentifier("dialog_cancel_button", "id", packageName));
    cancelButton.setText(getMessageForKey(CONFIRM_POPUP_CANCEL.name()));
    cancelButton.setOnClickListener(new OnClickListener() {
      @Override
      public void onClick(final View v) {
        dialog.dismiss();
      }
    });
  }
}