package com.onegini.dialog;

import android.app.Activity;
import android.app.KeyguardManager;
import android.content.Context;
import android.os.Build;
import android.os.Bundle;
import android.os.PowerManager;
import android.view.MotionEvent;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import com.onegini.mobile.sdk.android.library.utils.dialogs.AlertInterface;

public abstract class BaseAlertActivity extends Activity {

  @Override
  protected void onCreate(final Bundle savedInstanceState) {

    KeyguardManager keyguardManager = (KeyguardManager) getApplicationContext().getSystemService(Context.KEYGUARD_SERVICE);
    if (android.os.Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
      if (keyguardManager.isKeyguardLocked() && keyguardManager.isKeyguardSecure()) {
        //setTheme(R.style.customDialogLocked);
      }
    }

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

  /**
   * This method is invoked from {@link #onCreate(android.os.Bundle)}
   *
   * @return the layout for this activity.
   */
  abstract protected int getContentView();

  /**
   * Find the views and setup and other view related properties. This method is invoked from {@link
   * #onCreate(android.os.Bundle)}
   */
  abstract protected void setupViews();

  /**
   * Populate the views. This method is invoked after {@link #setupViews()}
   */
  abstract protected void populate();

  abstract protected AlertInterface.AlertHandler getAlertHandler();

  private void _setupPositiveButton(final PowerManager.WakeLock screenOn) {
    final Button positiveButton = (Button) findViewById(getResources().getIdentifier("positiveButton", "id", getPackageName()));

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
    final Button negativeButton = (Button) findViewById(getResources().getIdentifier("negativeButton", "id", getPackageName()));

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