package com.onegini.dialogs;

import static com.onegini.model.MessageKey.MAX_SIMILAR_DIGITS;
import static com.onegini.model.MessageKey.PIN_BLACK_LISTED;
import static com.onegini.model.MessageKey.PIN_CODES_DIFFERS;
import static com.onegini.model.MessageKey.PIN_SHOULD_NOT_BE_A_SEQUENCE;
import static com.onegini.model.MessageKey.PIN_SHOULD_NOT_USE_SIMILAR_DIGITS;
import static com.onegini.model.MessageKey.PIN_TOO_SHORT;
import static com.onegini.util.MessageResourceReader.getMessageForKey;
import static com.onegini.util.PinActivityStarter.startConfirmPinScreen;
import static com.onegini.util.PinActivityStarter.startCreatePinScreen;

import java.util.Arrays;

import android.content.Context;
import com.onegini.actions.InAppBrowserControlSession;
import com.onegini.mobile.sdk.android.library.OneginiClient;
import com.onegini.mobile.sdk.android.library.handlers.OneginiPinProvidedHandler;
import com.onegini.mobile.sdk.android.library.utils.dialogs.OneginiCreatePinDialog;
import com.onegini.util.PinActivityStarter;

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

    startCreatePinScreen(context);

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
        startConfirmPinScreen(context);
      }

      @Override
      public void verifiedPinProvided(final char[] pin) {
        final boolean pinsEqual = Arrays.equals(getPin(), pin);
        setPin(null);
        if (pinsEqual) {
          oneginiPinProvidedHandler.onPinProvided(pin);
        } else {
          startCreatePinScreen(context, getMessageForKey(PIN_CODES_DIFFERS.name()));
        }
      }
    };
  }

  @Override
  public void pinBlackListed() {
    startCreatePinScreen(context, getMessageForKey(PIN_BLACK_LISTED.name()));
  }

  @Override
  public void pinShouldNotBeASequence() {
    startCreatePinScreen(context, getMessageForKey(PIN_SHOULD_NOT_BE_A_SEQUENCE.name()));
  }

  @Override
  public void pinShouldNotUseSimilarDigits(final int maxSimilarDigits) {
    final String maxSimilarDigitsKey = getMessageForKey(MAX_SIMILAR_DIGITS.name());
    final String message = getMessageForKey(PIN_SHOULD_NOT_USE_SIMILAR_DIGITS.name());

    startCreatePinScreen(context, message.replace(maxSimilarDigitsKey, Integer.toString(maxSimilarDigits)));
  }

  @Override
  public void pinTooShort() {
    PinActivityStarter.startCreatePinScreen(context, getMessageForKey(PIN_TOO_SHORT.name()));
  }
}
