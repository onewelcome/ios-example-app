package com.onegini.util;

import android.content.Context;
import android.net.ConnectivityManager;

public class DeviceUtil {

  /**
   * Determine if device might be a tablet, by checking device density
   *
   * @return boolean TRUE if device might be a tablet
   */
  public static boolean isTablet(final Context context) {
    final int resourceId = context.getResources().getIdentifier("is_tablet", "bool", context.getPackageName());
    return context.getResources().getBoolean(resourceId);
  }

  /**
   * Verifies whenever device is able to establish network connections.
   *
   * @return boolean {@code true} whenever network connectivity exists and it is possible to establish connections and
   * pass data
   */
  public static boolean isConnected(final Context context) {
    final ConnectivityManager cm = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
    if (cm.getActiveNetworkInfo() != null
        && cm.getActiveNetworkInfo().isAvailable()
        && cm.getActiveNetworkInfo().isConnected()) {
      return true;
    }
    else {
      return false;
    }
  }

  /**
   * Verifies whenever device is NOT able to establish network connections.
   *
   * @return boolean {@code true} whenever network connectivity does not exists and it is impossible to establish
   * connections and pass data
   */
  public static boolean isNotConnected(final Context context) {
    return !isConnected(context);
  }
}
