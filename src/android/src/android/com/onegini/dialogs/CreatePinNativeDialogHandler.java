package com.onegini.dialogs;

import static com.onegini.dialogs.PinIntentBroadcaster.broadcastWithMessage;
import static com.onegini.dialogs.PinIntentBroadcaster.broadcastWithTitle;
import static com.onegini.dialogs.PinIntentBroadcaster.broadcastWithTitleAndMessage;
import static com.onegini.model.MessageKey.KEYBOARD_TITLE_CREATE_PIN;
import static com.onegini.model.MessageKey.KEYBOARD_TITLE_VERIFY_PIN;
import static com.onegini.model.MessageKey.MAX_SIMILAR_DIGITS;
import static com.onegini.model.MessageKey.PIN_BLACK_LISTED;
import static com.onegini.model.MessageKey.PIN_CODES_DIFFERS;
import static com.onegini.model.MessageKey.PIN_SHOULD_NOT_BE_A_SEQUENCE;
import static com.onegini.model.MessageKey.PIN_SHOULD_NOT_USE_SIMILAR_DIGITS;
import static com.onegini.model.MessageKey.PIN_TOO_SHORT;
import static com.onegini.util.MessageResourceReader.getMessageForKey;

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
    if (pin == null) {
      this.pin = pin;
      return;
    }
    this.pin = Arrays.copyOf(pin, pin.length);
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
    intent.putExtra(PinScreenActivity.EXTRA_SCREEN_TITLE, getMessageForKey(KEYBOARD_TITLE_CREATE_PIN.name()));
    intent.putExtra(PinScreenActivity.EXTRA_CREATE_PIN_FLOW, true);
    context.startActivity(intent);

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
          broadcastWithTitle(context, getMessageForKey(KEYBOARD_TITLE_VERIFY_PIN.name()));
        }

        @Override
        public void verifiedPinProvided(final char[] pin) {
          final boolean pinsEqual = Arrays.equals(getPin(), pin);
          setPin(null);
          if (pinsEqual) {
            oneginiPinProvidedHandler.onPinProvided(pin);
          }
          else {
            broadcastWithTitleAndMessage(context,
                getMessageForKey(KEYBOARD_TITLE_CREATE_PIN.name()),
                getMessageForKey(PIN_CODES_DIFFERS.name()));
          }
        }
      };
    }
    else {
      this.oneginiPinProvidedHandler = oneginiPinProvidedHandler;
    }
  }

  @Override
  public void pinBlackListed() {
    broadcastWithMessage(context, getMessageForKey(PIN_BLACK_LISTED.name()));
  }

  @Override
  public void pinShouldNotBeASequence() {
    broadcastWithMessage(context, getMessageForKey(PIN_SHOULD_NOT_BE_A_SEQUENCE.name()));
  }

  @Override
  public void pinShouldNotUseSimilarDigits(final int maxSimilarDigits) {
    final String maxSimilarDigitsKey = getMessageForKey(MAX_SIMILAR_DIGITS.name());
    final String message = getMessageForKey(PIN_SHOULD_NOT_USE_SIMILAR_DIGITS.name());
    broadcastWithMessage(context,
        message.replace(maxSimilarDigitsKey, Integer.toString(maxSimilarDigits)));
  }

  @Override
  public void pinTooShort() {
    broadcastWithMessage(context, getMessageForKey(PIN_TOO_SHORT.name()));
  }
}
