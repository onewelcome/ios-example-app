package com.onegini.helper;

import static com.onegini.dialogs.PinScreenActivity.SCREEN_MODE_CHANGE_PIN_CREATE_PIN;
import static com.onegini.dialogs.PinScreenActivity.SCREEN_MODE_CHANGE_PIN_CONFIRM_PIN;
import static com.onegini.dialogs.PinScreenActivity.SCREEN_MODE_LOGIN;
import static com.onegini.dialogs.PinScreenActivity.SCREEN_MODE_LOGIN_BEFORE_CHANGE_PIN;
import static com.onegini.dialogs.PinScreenActivity.SCREEN_MODE_REGISTRATION_CONFIRM_PIN;
import static com.onegini.dialogs.PinScreenActivity.SCREEN_MODE_REGISTRATION_CREATE_PIN;

import android.content.Context;
import android.content.Intent;
import com.onegini.dialogs.PinScreenActivity;

public class PinActivityStarter {

  public static void startLoginScreen(final Context context) {
    startActivity(context, SCREEN_MODE_LOGIN, null);
  }

  public static void startLoginScreen(final Context context, final String message) {
    startActivity(context, SCREEN_MODE_LOGIN, message);
  }

  public static void startLoginScreenBeforeChangePin(final Context context) {
    startActivity(context, SCREEN_MODE_LOGIN_BEFORE_CHANGE_PIN, null);
  }

  public static void startLoginScreenBeforeChangePin(final Context context, final String message) {
    startActivity(context, SCREEN_MODE_LOGIN_BEFORE_CHANGE_PIN, message);
  }

  public static void startRegistrationCreatePinScreen(final Context context) {
    startActivity(context, SCREEN_MODE_REGISTRATION_CREATE_PIN, null);
  }

  public static void startRegistrationCreatePinScreen(final Context context, final String message) {
    startActivity(context, SCREEN_MODE_REGISTRATION_CREATE_PIN, message);
  }

  public static void startRegistrationConfirmPinScreen(final Context context) {
    startActivity(context, SCREEN_MODE_REGISTRATION_CONFIRM_PIN, null);
  }

  public static void startRegistrationConfirmPinScreen(final Context context, final String message) {
    startActivity(context, SCREEN_MODE_REGISTRATION_CONFIRM_PIN, message);
  }

  public static void startChangePinCreatePinScreen(final Context context) {
    startActivity(context, SCREEN_MODE_CHANGE_PIN_CREATE_PIN, null);
  }

  public static void startChangePinCreatePinScreen(final Context context, final String message) {
    startActivity(context, SCREEN_MODE_CHANGE_PIN_CREATE_PIN, message);
  }

  public static void startChangePinConfirmPinScreen(final Context context) {
    startActivity(context, SCREEN_MODE_CHANGE_PIN_CONFIRM_PIN, null);
  }

  public static void startChangePinConfirmPinScreen(final Context context, final String message) {
    startActivity(context, SCREEN_MODE_CHANGE_PIN_CONFIRM_PIN, message);
  }

  private static void startActivity(final Context context, final int mode, final String message) {
    final Intent intent = new Intent(context, PinScreenActivity.class);
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
    intent.putExtra(PinScreenActivity.EXTRA_MESSAGE, message);
    intent.putExtra(PinScreenActivity.EXTRA_MODE, mode);
    context.startActivity(intent);
  }
}