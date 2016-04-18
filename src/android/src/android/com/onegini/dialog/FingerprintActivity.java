package com.onegini.dialog;

import static com.onegini.dialog.PinScreenActivity.SCREEN_MODE_LOGIN;
import static com.onegini.model.MessageKey.FINGERPRINT_TRY_AGAIN;
import static com.onegini.model.MessageKey.FINGERPRINT_VERIFICATION;
import static com.onegini.model.MessageKey.HELP_POPUP_OK;
import static com.onegini.util.MessageResourceReader.getMessageForKey;

import android.app.Activity;
import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.LinearInterpolator;
import android.view.animation.ScaleAnimation;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import com.onegini.dialog.helper.PinActivityMessageMapper;
import com.onegini.mobile.sdk.android.library.handlers.OneginiAuthenticatorFallbackHandler;

public class FingerprintActivity extends Activity {

  public static final String EXTRA_COMMAND = "command";
  public static final String COMMAND_SHOW = "show";
  public static final String COMMAND_RECEIVED = "received";
  public static final String COMMAND_CLOSE = "close";

  private static OneginiAuthenticatorFallbackHandler FINGERPRINT_AUTHORIZATION_FALLBACK_HANDLER;

  public static void setFingerprintAuthorizationFallbackHandler(final OneginiAuthenticatorFallbackHandler fingerprintCancellationSignal) {
    FINGERPRINT_AUTHORIZATION_FALLBACK_HANDLER = fingerprintCancellationSignal;
  }

  ImageView fingerprintIco;
  TextView fingerprintMessage;
  TextView pinFallbackButton;
  TextView helpLinkTextView;

  private View.OnClickListener helpButtonListener;

  @Override
  protected void onCreate(final Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(getResources().getIdentifier("activity_fingerprint", "layout", getPackageName()));
    fingerprintIco = (ImageView) findViewById(getResources().getIdentifier("fingerprint_ico", "id", getPackageName()));
    fingerprintMessage = (TextView) findViewById(getResources().getIdentifier("fingerprint_message", "id", getPackageName()));
    pinFallbackButton = (TextView) findViewById(getResources().getIdentifier("pin_fallback_button", "id", getPackageName()));
    helpLinkTextView = (TextView) findViewById(getResources().getIdentifier("help_button", "id", getPackageName()));
    helpLinkTextView.setOnClickListener(helpButtonListener);
    helpButtonListener = new View.OnClickListener() {
      @Override
      public void onClick(final View v) {
        showHelpDialog();
      }
    };

    initFallbackButton();
  }

  @Override
  protected void onNewIntent(final Intent intent) {
    final String extraMessage = intent.getStringExtra(EXTRA_COMMAND);
    if (COMMAND_SHOW.equals(extraMessage)) {
      showFingerprintIco();
    } else if  (COMMAND_RECEIVED.equals(extraMessage)) {
      hideFingerprintIco();
    } else if (COMMAND_CLOSE.equals(extraMessage)) {
      finish();
    }
  }

  private void initFallbackButton() {
    pinFallbackButton.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(final View v) {
        if (FINGERPRINT_AUTHORIZATION_FALLBACK_HANDLER != null) {
          FINGERPRINT_AUTHORIZATION_FALLBACK_HANDLER.triggerFallback();
        }
      }
    });
  }

  private void showHelpDialog() {
    final Dialog dialog = createStyledDialog("alert_dialog");
    dialog.show();

    setDialogTitle(dialog, PinActivityMessageMapper.getTitleForHelpsScreen(SCREEN_MODE_LOGIN));
    setDialogMessage(dialog, PinActivityMessageMapper.getMessageForHelpScreen(SCREEN_MODE_LOGIN));
    prepareOkButton(dialog, getMessageForKey(HELP_POPUP_OK.name()), new View.OnClickListener() {
      @Override
      public void onClick(final View v) {
        dialog.dismiss();
      }
    });
  }

  private Dialog createStyledDialog(final String dialogLayoutName) {
    final int layoutId = getResources().getIdentifier(dialogLayoutName, "layout", getPackageName());
    final int styleId = getResources().getIdentifier("CustomDialogTheme", "style", getPackageName());

    final Dialog dialog = new Dialog(this, styleId);
    dialog.setContentView(layoutId);
    return dialog;
  }

  private void setDialogTitle(final Dialog dialog, final String title) {
    final TextView titleView = (TextView) dialog.findViewById(getResources().getIdentifier("dialog_title", "id", getPackageName()));
    titleView.setText(title);
  }

  private void setDialogMessage(final Dialog dialog, final String message) {
    final TextView messageView = (TextView) dialog.findViewById(getResources().getIdentifier("dialog_message", "id", getPackageName()));
    messageView.setText(message);
  }

  private void prepareOkButton(final Dialog dialog, final String title, final View.OnClickListener listener) {
    final Button okButton = (Button) dialog.findViewById(getResources().getIdentifier("dialog_ok_button", "id", getPackageName()));
    okButton.setText(title);
    okButton.setOnClickListener(listener);
  }

  private void showFingerprintIco() {
    fingerprintMessage.setText(getMessageForKey(FINGERPRINT_TRY_AGAIN.name()));
    fingerprintMessage.startAnimation(getBlinkAnimation());

    fingerprintIco.setVisibility(View.VISIBLE);
    pinFallbackButton.setVisibility(View.VISIBLE);
  }

  private void hideFingerprintIco() {
    fingerprintMessage.setText(getMessageForKey(FINGERPRINT_VERIFICATION.name()));
    fingerprintIco.setVisibility(View.INVISIBLE);
    pinFallbackButton.setVisibility(View.INVISIBLE);
  }

  public Animation getBlinkAnimation(){
    final Animation animation = new ScaleAnimation(1.0f, 1.1f, 1.0f, 1.1f);
    animation.setDuration(100);
    animation.setInterpolator(new LinearInterpolator());
    animation.setRepeatCount(1);
    animation.setRepeatMode(Animation.REVERSE);

    return animation;
  }
}
