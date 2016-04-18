package com.onegini.dialog;

import static com.onegini.model.MessageKey.FINGERPRINT_TRY_AGAIN;
import static com.onegini.model.MessageKey.FINGERPRINT_VERIFICATION;
import static com.onegini.util.MessageResourceReader.getMessageForKey;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.PowerManager;
import android.view.View;
import android.view.WindowManager;
import android.view.animation.Animation;
import android.view.animation.LinearInterpolator;
import android.view.animation.ScaleAnimation;
import android.widget.ImageView;
import android.widget.TextView;

public class PushWithFingerprintActivity extends Activity {

  public static final String EXTRA_TITLE = "title";
  public static final String EXTRA_COMMAND = "command";

  public static final String COMMAND_SHOW = "ask";
  public static final String COMMAND_RECEIVED = "received";
  public static final String COMMAND_CLOSE = "close";

  protected PowerManager.WakeLock screenOn;

  private TextView fingerprintTitle;
  private ImageView fingerprintIco;
  private TextView fingerprintMessage;
  private TextView pinFallbackButton;
  private TextView acceptButton;
  private TextView denyButton;

  private boolean firstAttemp;

  @Override
  protected void onCreate(final Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    lockScreen();

    initLayout();

    firstAttemp = true;
  }

  private void initLayout() {
    setContentView(getResources().getIdentifier("activity_push_fingerprint", "layout", getPackageName()));
    fingerprintTitle = (TextView) findViewById(getResources().getIdentifier("fingerprint_title", "id", getPackageName()));
    fingerprintIco = (ImageView) findViewById(getResources().getIdentifier("fingerprint_ico", "id", getPackageName()));
    fingerprintMessage = (TextView) findViewById(getResources().getIdentifier("fingerprint_message", "id", getPackageName()));
    pinFallbackButton = (TextView) findViewById(getResources().getIdentifier("pin_fallback_button", "id", getPackageName()));
    acceptButton = (TextView) findViewById(getResources().getIdentifier("fingerprint_positive_button", "id", getPackageName()));
    denyButton = (TextView) findViewById(getResources().getIdentifier("fingerprint_negative_button", "id", getPackageName()));

    fingerprintIco.setVisibility(View.GONE);
    fingerprintMessage.setVisibility(View.GONE);
    pinFallbackButton.setVisibility(View.GONE);

    acceptButton.setVisibility(View.VISIBLE);
    denyButton.setVisibility(View.VISIBLE);

    initScreenTitle();
    initOnClickListeners();
  }

  private void initOnClickListeners() {
    acceptButton.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(final View v) {
        PushAuthenticateWithFingerprintDialog.handler.confirmationPositiveClick();
      }
    });
    denyButton.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(final View v) {
        PushAuthenticateWithFingerprintDialog.handler.confirmationNegativeClick();
      }
    });
    pinFallbackButton.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(final View v) {
        PushAuthenticateWithFingerprintDialog.handler.confirmationFallbackClick();
      }
    });
  }

  private void initScreenTitle() {
    final String title = getIntent().getStringExtra(EXTRA_TITLE);
    if (title!=null && !title.isEmpty()) {
      fingerprintTitle.setText(title);
    }
  }

  @Override
  protected void onNewIntent(final Intent intent) {
    final String command = intent.getStringExtra(EXTRA_COMMAND);
    if (COMMAND_SHOW.equals(command)) {
      showFingerprintIco();
    } else if  (COMMAND_RECEIVED.equals(command)) {
      firstAttemp = false;
      hideFingerprintIco();
    } else if (COMMAND_CLOSE.equals(command)) {
      close();
    }
  }

  private void showFingerprintIco() {
    acceptButton.setVisibility(View.GONE);
    denyButton.setVisibility(View.GONE);

    fingerprintMessage.setVisibility(View.VISIBLE);
    if (firstAttemp == false) {
      fingerprintMessage.setText(getMessageForKey(FINGERPRINT_TRY_AGAIN.name()));
      fingerprintMessage.startAnimation(getBlinkAnimation());
    }

    fingerprintIco.setVisibility(View.VISIBLE);
    pinFallbackButton.setVisibility(View.VISIBLE);
  }

  private void hideFingerprintIco() {
    acceptButton.setVisibility(View.GONE);
    denyButton.setVisibility(View.GONE);

    fingerprintMessage.setVisibility(View.VISIBLE);
    fingerprintMessage.setText(getMessageForKey(FINGERPRINT_VERIFICATION.name()));

    fingerprintIco.setVisibility(View.INVISIBLE);
    pinFallbackButton.setVisibility(View.INVISIBLE);
  }

  private void close() {
    unlockScreen();
    finish();
  }

  public Animation getBlinkAnimation(){
    final Animation animation = new ScaleAnimation(1.0f, 1.1f, 1.0f, 1.1f);
    animation.setDuration(100);
    animation.setInterpolator(new LinearInterpolator());
    animation.setRepeatCount(1);
    animation.setRepeatMode(Animation.REVERSE);

    return animation;
  }

  @Override
  public void onBackPressed() {
    // we don't want to be able to go back from the pin screen
    return;
  }

  protected void lockScreen() {
    getWindow().setFlags(WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL, WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL);
    getWindow().setFlags(WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH, WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH);
    getWindow().setFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON, WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
    getWindow().setFlags(WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON, WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON);
    screenOn = ((PowerManager) getSystemService(POWER_SERVICE)).newWakeLock(PowerManager.PARTIAL_WAKE_LOCK | PowerManager.ACQUIRE_CAUSES_WAKEUP, "ALERT!");
    screenOn.acquire();

    getWindow().addFlags(WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED);
  }

  protected void unlockScreen() {
    if (screenOn != null && screenOn.isHeld()) {
      screenOn.release();
    }
  }
}
