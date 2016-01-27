package com.onegini.dialog;


import android.widget.ImageView;
import android.widget.TextView;
import com.onegini.mobile.sdk.android.library.utils.dialogs.AlertInterface;

public class NotificationAlertActivity extends BaseAlertActivity {

  private ImageView alertImage;
  private TextView alertText;

  @Override
  protected int getContentView() {
    return getResources().getIdentifier("alert_vertical", "layout", getPackageName());
  }

  @Override
  protected void setupViews() {
    alertImage = (ImageView) findViewById(getResources().getIdentifier("alertImage", "id", getPackageName()));
    alertText = (TextView) findViewById(getResources().getIdentifier("alertText", "id", getPackageName()));

  }

  @Override
  protected AlertInterface.AlertHandler getAlertHandler() {
    return ConfirmationDialog.handler;
  }

  protected void populate() {
    alertText.setText(getIntent().getStringExtra("message"));
  }
}
