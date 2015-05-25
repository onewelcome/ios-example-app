package com.onegini.util;

import static com.onegini.dialogs.PinScreenActivity.SCREEN_MODE_CONFIRM_PIN;
import static com.onegini.dialogs.PinScreenActivity.SCREEN_MODE_CREATE_PIN;
import static com.onegini.dialogs.PinScreenActivity.SCREEN_MODE_LOGIN;

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

  public static void startCreatePinScreen(final Context context) {
    startActivity(context, SCREEN_MODE_CREATE_PIN, null);
  }

  public static void startCreatePinScreen(final Context context, final String message) {
    startActivity(context, SCREEN_MODE_CREATE_PIN, message);
  }

  public static void startConfirmPinScreen(final Context context) {
    startActivity(context, SCREEN_MODE_CONFIRM_PIN, null);
  }

  public static void startConfirmPinScreen(final Context context, final String message) {
    startActivity(context, SCREEN_MODE_CONFIRM_PIN, message);
  }

  private static void startActivity(final Context context, final int mode, final String message) {
    final Intent intent = new Intent(context, PinScreenActivity.class);
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
    intent.putExtra(PinScreenActivity.EXTRA_MODE, SCREEN_MODE_LOGIN);
    context.startActivity(intent);

  }
}