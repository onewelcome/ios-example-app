package com.onegini.dialog;


import android.app.Activity;
import android.content.Context;
import android.content.res.Resources;
import android.os.Bundle;
import android.os.PowerManager;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.WindowManager;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.onegini.mobile.sdk.android.library.OneginiClient;

import java.util.ArrayList;
import java.util.List;

/**
 * Base pin entry dialog activity. Subclass must provide a layout with at least the pin entry boxes.
 */
public abstract class BasePinDialogActivity extends Activity
    implements TextView.OnEditorActionListener, View.OnFocusChangeListener {

  protected Resources resources;
  protected String packageName;

  OneginiClient client;

  List<EditText> pinButtons;

  EditText pinBox0;
  EditText pinBox1;
  EditText pinBox2;
  EditText pinBox3;
  EditText pinBox4;

  TextView pinDialogTitleTextView;
  TextView wrongPinTextView;

  ProgressBar progressBar;

  PowerManager.WakeLock screenOn;

  // Prevent the focus change from the last pin box to the first pin box when the keyboard transitions to hidden state.
  private boolean ignoreFocusChange = false;

  @Override
  protected void onCreate(final Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    resources = getResources();
    packageName = getPackageName();

    getWindow().setFlags(WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL, WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL);
    getWindow().setFlags(WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH, WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH);
    getWindow().setFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON, WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
    getWindow().setFlags(WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON, WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON);

    screenOn = ((PowerManager) getSystemService(POWER_SERVICE))
        .newWakeLock(PowerManager.PARTIAL_WAKE_LOCK | PowerManager.ACQUIRE_CAUSES_WAKEUP, "ALERT!");
    screenOn.acquire();

    getWindow().addFlags(WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED);

    setContentView(getContentView());

    setupViews();
  }

  /**
   * The layout for the content view is provided by a concrete subclass
   *
   * @return layout identifier
   */
  abstract int getContentView();

  @Override
  protected void onStart() {
    super.onStart();

    populate();
  }

  @Override
  protected void onStop() {
    super.onStop();

    hideProgressBar();
  }

  /**
   * Extract the views from the layout and apply custom settings. Subclasses must call super. Invoked from {@link
   * #onCreate(android.os.Bundle)}
   */
  protected void setupViews() {
    client = OneginiClient.getInstance();


    wrongPinTextView = (TextView) findViewById(resources.getIdentifier("wrongPinTextView", "id", packageName));
    pinDialogTitleTextView = (TextView) findViewById(resources.getIdentifier("pinDialogTitleTextView", "id", packageName));

    progressBar = (ProgressBar) findViewById(resources.getIdentifier("progressBar", "id", packageName));

    pinBox0 = (EditText) findViewById(resources.getIdentifier("pinBox0", "id", packageName));
    pinBox1 = (EditText) findViewById(resources.getIdentifier("pinBox1", "id", packageName));
    pinBox2 = (EditText) findViewById(resources.getIdentifier("pinBox2", "id", packageName));
    pinBox3 = (EditText) findViewById(resources.getIdentifier("pinBox3", "id", packageName));
    pinBox4 = (EditText) findViewById(resources.getIdentifier("pinBox4", "id", packageName));

    pinButtons = new ArrayList<EditText>();
    pinButtons.add(pinBox0);
    pinButtons.add(pinBox1);
    pinButtons.add(pinBox2);
    pinButtons.add(pinBox3);
    pinButtons.add(pinBox4);

    for (EditText pinButton : pinButtons) {
      pinButton.setOnEditorActionListener(this);
      pinButton.setOnFocusChangeListener(this);
      pinButton.addTextChangedListener(new PinBoxTextWatcher(pinButton));
    }
  }

  /**
   * Populate the views after they have been setup in {@link #setupViews()}. Invoked from {@link #onStart()}
   */
  protected void populate() {
    String title = getIntent().getStringExtra("message");
    if (pinDialogTitleTextView == null) {
      Log.w(getComponentName().toShortString(), "pin dialog title view is missing in the layout");
    }
    else {
      pinDialogTitleTextView.setText(title);
    }

    int remainingAttempts = 3; //CommonDataModel.getInstance().getRemainingAttempts(); TODO
    if (remainingAttempts > 0) {
      String wrongPinText = "Wrong PIN. Attempt(s):" + remainingAttempts;
      if (wrongPinTextView == null) {
        Log.w(getComponentName().toShortString(), "wrong pin text iew is missing in the layout");
      }
      else {
        wrongPinTextView.setText(wrongPinText);
      }
    }
  }

  @Override
  public void onBackPressed() {
    // No back on the main activity
  }

  @Override
  public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
    if (actionId == EditorInfo.IME_ACTION_DONE) {
      sendLoginRequest();
      return false;
    }

    return true;
  }

  protected void sendLoginRequest() {
    String userPin = evaluatePinComplete();

    if (userPin != null && userPin.length() == pinButtons.size()) {
      showProgressBar();
      callHandler(userPin);
    }
    else {
      Toast.makeText(BasePinDialogActivity.this, "PIN not complete",
          Toast.LENGTH_SHORT).show();
    }
  }

  /**
   * /* The handler interfaces are different for each type of dialog so the subclass must handle the handler
   * invocation.
   */
  abstract protected void callHandler(String userPin);

  private String evaluatePinComplete() {
    StringBuilder sb = new StringBuilder();
    for (EditText pinBox : pinButtons) {
      if (pinBox.getText().length() == 0) {
        return null;
      }

      sb.append(pinBox.getText().toString());
    }

    return sb.toString();
  }

  protected void showProgressBar() {
    if (progressBar != null) {
      progressBar.setVisibility(View.VISIBLE);
    }
  }

  protected void hideProgressBar() {
    if (progressBar != null) {
      progressBar.setVisibility(View.INVISIBLE);
    }
  }

  protected void hideKeyboard(View v) {
    InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
    imm.hideSoftInputFromWindow(v.getWindowToken(), 0);
  }

  @Override
  public void onFocusChange(final View v, final boolean hasFocus) {
    if (ignoreFocusChange) {
      return;
    }

    if (hasFocus) {
      if (v instanceof EditText) {
        EditText pinBox = (EditText) v;
        pinBox.setText("");
      }
    }
  }

  private void focusNextPinBox(EditText pinBox) {
    if (pinBox != pinBox4) {
      int index = Math.min(pinButtons.indexOf(pinBox) + 1, pinButtons.size());
      pinButtons.get(index).requestFocus();
    } else {
      sendLoginRequest();
    }
  }

  class PinBoxTextWatcher implements TextWatcher {
    EditText pinBox;

    PinBoxTextWatcher(EditText pinBox) {
      this.pinBox = pinBox;
    }

    @Override
    public void beforeTextChanged(final CharSequence s, final int start, final int count, final int after) {
      // Ignore
    }

    @Override
    public void onTextChanged(final CharSequence s, final int start, final int before, final int count) {
      if (!TextUtils.isEmpty(s)) {
        focusNextPinBox(pinBox);
      }
    }

    @Override
    public void afterTextChanged(final Editable s) {
      // Ignore
    }
  }
}
