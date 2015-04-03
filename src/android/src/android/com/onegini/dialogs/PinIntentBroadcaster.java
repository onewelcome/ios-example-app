package com.onegini.dialogs;

import android.content.Context;
import android.content.Intent;

public class PinIntentBroadcaster {

  public static String TITLE = "title";
  public static String MESSAGE = "message";

  public static void broadcastWithMessage(final Context context, final String message) {
    broadcastWithTitleAndMessage(context, null, message);
  }

  public static void broadcastWithTitle(final Context context, final String title) {
    broadcastWithTitleAndMessage(context, title, null);
  }

  public static void broadcastWithTitleAndMessage(final Context context, final String title, final String message) {
    final Intent intent = new Intent(context, PinScreenActivity.class);
    if (title != null) {
      intent.putExtra(TITLE, title);
    }
    if (message != null) {
      intent.putExtra(MESSAGE, message);
    }
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

    context.startActivity(intent);
  }

}
