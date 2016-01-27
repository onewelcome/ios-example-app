package com.onegini.dialog;


import android.content.Intent;
import android.view.View;
import android.widget.TextView;

public class AcceptWithPinDialogActivity extends BasePinDialogActivity {

  TextView titleText;

  @Override
  int getContentView() {
    return resources.getIdentifier("pin_accept_dialog", "layout", packageName);
  }

  @Override
  protected void setupViews() {
    super.setupViews();
    titleText = (TextView) findViewById(resources.getIdentifier("titleText", "id", packageName));
  }

  @Override
  protected void populate() {
    super.populate();
    final Intent intent = getIntent();

    if (titleText != null) {
      String s = intent.getStringExtra("title");
      titleText.setText(s);
    }

    int attemptCount = intent.getIntExtra("attemptCount", 0);
    int maxAllowedAttempts = intent.getIntExtra("maxAllowedAttempts", 3);

    if (attemptCount > 0) {
      wrongPinTextView.setVisibility(View.VISIBLE);
      wrongPinTextView.setText(String.format("Wrong PIN, attempt(s)%d/%d", attemptCount + 1, maxAllowedAttempts));
    }
    else {
      wrongPinTextView.setVisibility(View.INVISIBLE);
    }
  }

  @Override
  protected void callHandler(final String userPin) {
    try {
      if (screenOn.isHeld()) {
        screenOn.release();
      }
      AcceptWithPinDialog.handler.confirmationPositiveClick(userPin.toCharArray());
    }
    finally {
      finish();
    }
  }

  public void onDenyButtonClicked(View v) {
    try {
      if (screenOn.isHeld()) {
        screenOn.release();
      }
      AcceptWithPinDialog.handler.confirmationNegativeClick();
    }
    finally {
      finish();
    }
  }
}
