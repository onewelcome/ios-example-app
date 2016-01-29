package com.onegini.dialog;

import org.apache.cordova.CordovaActivity;

import android.app.Activity;
import android.os.Bundle;
import android.os.PowerManager;
import android.view.MotionEvent;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.TextView;

import com.onegini.mobile.sdk.android.library.utils.dialogs.AlertInterface;


public class PushSimpleActivity extends CordovaActivity {

  private TextView alertText;

  @Override
  public void onCreate(final Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    getWindow().setFlags(WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL, WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL);
    getWindow().setFlags(WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH,
        WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH);
    getWindow().setFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON, WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
    getWindow().setFlags(WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON, WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON);
    final PowerManager.WakeLock screenOn = ((PowerManager) getSystemService(POWER_SERVICE))
        .newWakeLock(PowerManager.PARTIAL_WAKE_LOCK | PowerManager.ACQUIRE_CAUSES_WAKEUP, "ALERT!");
    screenOn.acquire();

    getWindow().addFlags(WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED);

    setContentView(getContentView());

    _setupPositiveButton(screenOn);
    _setupNegativeButton(screenOn);

    setupViews();
    populate();
  }

  protected int getContentView() {
    return getResources().getIdentifier("push_simple_dialog", "layout", getPackageName());
  }

  protected void setupViews() {
    alertText = (TextView) findViewById(getResources().getIdentifier("alert_text", "id", getPackageName()));
  }

  protected void populate() {
    alertText.setText(getIntent().getStringExtra("message"));
  }

  protected AlertInterface.AlertHandler getAlertHandler() {
    return ConfirmationDialog.handler;
  }

  private void _setupPositiveButton(final PowerManager.WakeLock screenOn) {
    final Button positiveButton = (Button) findViewById(getResources().getIdentifier("positive_button", "id", getPackageName()));

    String title = getIntent().getStringExtra("positiveButtonTitle");
    if (title != null) {
      positiveButton.setText(title);
    }

    positiveButton.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(final View view) {
        if (screenOn.isHeld()) {
          screenOn.release();
        }
        getAlertHandler().alertPositiveClick();
        finish();
      }
    });
  }

  private void _setupNegativeButton(final PowerManager.WakeLock screenOn) {
    final Button negativeButton = (Button) findViewById(getResources().getIdentifier("negative_button", "id", getPackageName()));

    String title = getIntent().getStringExtra("negativeButtonTitle");
    if (title != null) {
      negativeButton.setText(title);
    }

    negativeButton.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(final View view) {
        if (screenOn.isHeld()) {
          screenOn.release();
        }
        getAlertHandler().alertNegativeClick();
        finish();
      }
    });
  }

  @Override
  public boolean onTouchEvent(final MotionEvent event) {
    // If we've received a touch notification that the user has touched
    // outside the app, finish the activity.
    if (MotionEvent.ACTION_OUTSIDE == event.getAction()) {
      return true;
    }

    // Delegate everything else to Activity.
    return super.onTouchEvent(event);
  }

  @Override
  public void onBackPressed() {
    // prevent close alert by back button
  }
}
