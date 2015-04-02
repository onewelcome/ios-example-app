package com.onegini.dialogs;

import static com.onegini.dialogs.PinDialogMessages.PIN_DIALOG_BLACKLISTED;
import static com.onegini.dialogs.PinDialogMessages.PIN_DIALOG_CHOOSE_PIN;
import static com.onegini.dialogs.PinDialogMessages.PIN_DIALOG_PINS_NOT_EQUAL;
import static com.onegini.dialogs.PinDialogMessages.PIN_DIALOG_SEQUENCE;
import static com.onegini.dialogs.PinDialogMessages.PIN_DIALOG_SIMILAR;
import static com.onegini.dialogs.PinDialogMessages.PIN_DIALOG_TOO_SHORT;
import static com.onegini.dialogs.PinDialogMessages.PIN_DIALOG_VERIFY_PIN;

import java.util.Arrays;

import android.content.Context;
import android.content.Intent;
import com.onegini.actions.InAppBrowserControlSession;
import com.onegini.mobile.sdk.android.library.OneginiClient;
import com.onegini.mobile.sdk.android.library.handlers.OneginiPinProvidedHandler;
import com.onegini.mobile.sdk.android.library.utils.dialogs.OneginiCreatePinDialog;

public class CreatePinNativeDialogHandler implements OneginiCreatePinDialog {

  private interface OneginiPinWithConfirmationHandler extends OneginiPinProvidedHandler {
    void verifiedPinProvided(final char[] pin);
  }

  private Context context;
  static OneginiPinProvidedHandler oneginiPinProvidedHandler;

  private char[] pin;

  private char[] getPin() {
    return pin;
  }

  private void setPin(final char[] pin) {
    this.pin = Arrays.copyOf(pin, pin.length);
  }

  private void nullifyPin(final char[] pin) {
    for (int i = 0; i < pin.length; i++) {
      pin[i] = '\0';
    }
  }
  private boolean isPinVerificationCall() {
    return pin != null;
  }

  public CreatePinNativeDialogHandler(final Context context) {
    this.context = context;
  }

  @Override
  public void createPin(final OneginiPinProvidedHandler oneginiPinProvidedHandler) {
    InAppBrowserControlSession.closeInAppBrowser();

    final Intent intent = new Intent(context, PinScreenActivity.class);
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
    intent.putExtra("title", PIN_DIALOG_CHOOSE_PIN);
    context.startActivity(intent);

    PinScreenActivity.setCreatePinFlow(true);

    if (OneginiClient.getInstance().getConfigModel().shouldConfirmNewPin()) {
      this.oneginiPinProvidedHandler = new OneginiPinWithConfirmationHandler() {
        @Override
        public void onPinProvided(final char[] pin) {
          if (isPinVerificationCall()) {
            verifiedPinProvided(pin);
            return;
          }

          if (!OneginiClient.getInstance().isPinValid(pin, CreatePinNativeDialogHandler.this)) {
            return;
          }

          setPin(pin);
          notifyActivity(PIN_DIALOG_VERIFY_PIN);
        }

        @Override
        public void verifiedPinProvided(final char[] pin) {
          final boolean pinsEqual = Arrays.equals(getPin(), pin);
          if (pinsEqual) {
            oneginiPinProvidedHandler.onPinProvided(pin);
          }
          else {
            notifyActivity(PIN_DIALOG_PINS_NOT_EQUAL);
          }
          nullifyPin(getPin());
        }
      };
    }
    else {
      this.oneginiPinProvidedHandler = oneginiPinProvidedHandler;
    }
  }

  @Override
  public void pinBlackListed() {
    notifyActivity(PIN_DIALOG_BLACKLISTED);
  }

  @Override
  public void pinShouldNotBeASequence() {
    notifyActivity(PIN_DIALOG_SEQUENCE);
  }

  @Override
  public void pinShouldNotUseSimilarDigits(final int maxSimilarDigits) {
    notifyActivity(PIN_DIALOG_SIMILAR + ". The max is " + maxSimilarDigits);
  }

  @Override
  public void pinTooShort() {
    notifyActivity(PIN_DIALOG_TOO_SHORT);
  }

  private void notifyActivity(final String type, final String message) {
    final Intent intent = new Intent(context, PinScreenActivity.class);
    intent.putExtra(type, message);
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

    context.startActivity(intent);
  }

  private void notifyActivity(final String message) {
    notifyActivity("message", message);
  }
}
