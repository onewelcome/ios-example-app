package com.onegini.dialog;

import org.apache.cordova.CordovaActivity;

import android.content.pm.ActivityInfo;
import android.content.res.Resources;
import android.os.Bundle;
import android.os.PowerManager;
import android.view.MotionEvent;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.TextView;

import com.onegini.mobile.sdk.android.library.utils.dialogs.AlertInterface;
import com.onegini.util.DeviceUtil;


public class PushSimpleActivity extends CordovaActivity {

  private Resources resources;
  private String packageName;
  private PowerManager.WakeLock screenOn;

  private TextView alertText;
  private Button possitiveButton;
  private Button negativeButton;

  @Override
  public void onCreate(final Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setupScreenLock();

    resources = getResources();
    packageName = getPackageName();

    setContentView(resources.getIdentifier("push_simple_dialog", "layout", packageName));
    initLayout();

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
    alertText = (TextView) findViewById(resources.getIdentifier("alert_text", "id", packageName));
    possitiveButton = (Button) findViewById(resources.getIdentifier("positive_button", "id", packageName));
    negativeButton = (Button) findViewById(resources.getIdentifier("negative_button", "id", packageName));

    alertText.setText(getIntent().getStringExtra("message"));
    setupPositiveButton();
    setupNegativeButton();
  }

  private void setupPositiveButton() {
    final String title = getIntent().getStringExtra("positiveButtonTitle");
    if (title != null) {
      possitiveButton.setText(title);
    }

    possitiveButton.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(final View view) {
        ConfirmationDialog.handler.alertPositiveClick();
        close();
      }
    });
  }

  private void setupNegativeButton() {
    final String title = getIntent().getStringExtra("negativeButtonTitle");
    if (title != null) {
      negativeButton.setText(title);
    }

    negativeButton.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(final View view) {
        ConfirmationDialog.handler.alertNegativeClick();
        close();
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
