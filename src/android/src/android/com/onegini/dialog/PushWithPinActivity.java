package com.onegini.dialog;

import org.apache.cordova.CordovaActivity;

import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.content.res.Resources;
import android.os.Bundle;
import android.os.PowerManager;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.TableLayout;
import android.widget.TextView;

import com.onegini.dialog.helper.PinKeyboardHandler;
import com.onegini.dialog.helper.PinKeyboardHandler.PinProvidedListener;
import com.onegini.util.DeviceUtil;

public class PushWithPinActivity extends CordovaActivity {

  private static final int MAX_DIGITS = 5;

  private Resources resources;
  private String packageName;
  private PowerManager.WakeLock screenOn;

  private PinKeyboard pinKeyboard;
  private final TextView[] pinInputs = new TextView[MAX_DIGITS];

  private TextView screenTitleTextView;
  private TextView helpLinkTextView;
  private TextView pinForgottenTextView;
  private TextView errorTextView;
  private Button denyButton;

  private PinKeyboardHandler pinKeyboardHandler;
  private PinProvidedListener pinProvidedListener;

  @Override
  public void onCreate(final Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setupScreenLock();
    resources = getResources();
    packageName = getPackageName();

    setContentView(resources.getIdentifier("pin_screen", "layout", packageName));

    initLayout();
    initKeyboard();
    parseIntent();
  }

  private void setupScreenLock() {
    getWindow().setFlags(WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL, WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL);
    getWindow().setFlags(WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH, WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH);
    getWindow().setFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON, WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
    getWindow().setFlags(WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON, WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON);
    screenOn = ((PowerManager) getSystemService(POWER_SERVICE)).newWakeLock(PowerManager.PARTIAL_WAKE_LOCK | PowerManager.ACQUIRE_CAUSES_WAKEUP, "ALERT!");
    screenOn.acquire();

    getWindow().addFlags(WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED);
    lockScreenOrientation();
  }

  private void initLayout() {
    initPinInputs();

    errorTextView = (TextView) findViewById(resources.getIdentifier("pin_error_message", "id", packageName));
    errorTextView.setVisibility(View.INVISIBLE);

    helpLinkTextView = (TextView) findViewById(resources.getIdentifier("help_button", "id", packageName));
    helpLinkTextView.setVisibility(View.GONE);

    pinForgottenTextView = (TextView) findViewById(resources.getIdentifier("pin_forgotten_label", "id", packageName));
    pinForgottenTextView.setVisibility(View.GONE);

    screenTitleTextView = (TextView) findViewById(resources.getIdentifier("pin_screen_title", "id", packageName));

    denyButton = (Button) findViewById(resources.getIdentifier("pin_deny_button", "id", packageName));
    denyButton.setVisibility(View.VISIBLE);
    denyButton.setOnClickListener(new OnClickListener() {
      @Override
      public void onClick(final View v) {
        AcceptWithPinDialog.handler.confirmationNegativeClick();
        close();
      }
    });
  }

  private void initKeyboard() {
    pinProvidedListener = new PinProvidedListener() {
      @Override
      public void onPinProvided(final char[] pin) {
        AcceptWithPinDialog.handler.confirmationPositiveClick(pin);
        close();
      }
    };

    pinKeyboardHandler = new PinKeyboardHandler(pinProvidedListener, pinInputs);
    pinKeyboardHandler.setInputFocusedBackgroundResourceId(resources.getIdentifier("form_active", "drawable", packageName));
    pinKeyboardHandler.setInputNormalBackgroundResourceId(resources.getIdentifier("form_inactive", "drawable", packageName));
    pinKeyboardHandler.reset();
    pinKeyboard = new PinKeyboard(pinKeyboardHandler);

    final TableLayout keyboardLayout = (TableLayout) findViewById(resources.getIdentifier("pin_keyboard", "id", packageName));
    pinKeyboard.initLayout(keyboardLayout, getResources(), getPackageName());
  }

  private void initPinInputs() {
    for (int input = 0; input < MAX_DIGITS; input++) {
      final int inputId = resources.getIdentifier("pin_input_" + input, "id", packageName);
      pinInputs[input] = (TextView) findViewById(inputId);
    }
  }

  private void parseIntent() {
    final Intent intent = getIntent();

    screenTitleTextView.setText(intent.getStringExtra("message"));

    int attemptCount = intent.getIntExtra("attemptCount", 0);
    int maxAllowedAttempts = intent.getIntExtra("maxAllowedAttempts", 3);

    if (attemptCount > 0) {
      errorTextView.setVisibility(View.VISIBLE);
      errorTextView.setText(String.format("Wrong PIN, attempt(s)%d/%d", attemptCount + 1, maxAllowedAttempts));
    }
    else {
      errorTextView.setVisibility(View.INVISIBLE);
    }
  }


  @Override
  public void onBackPressed() {
    // No back on the main activity
  }

  private void close() {
    if (screenOn.isHeld()) {
      screenOn.release();
      finish();
    }
  }

  private void lockScreenOrientation() {
    if (DeviceUtil.isTablet(this)) {
      setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
    }
    else {
      setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
    }
  }
}
