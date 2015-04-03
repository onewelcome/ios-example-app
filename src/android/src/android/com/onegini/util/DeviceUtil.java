package com.onegini.util;

import android.content.Context;

public class DeviceUtil {

  /**
   * Determine if device might be a tablet, by checking device density
   * @return boolean TRUE if device might be a tablet
   */
  public static boolean isTablet(final Context context) {
    final int resourceId = context.getResources().getIdentifier("is_tablet", "bool", context.getPackageName());
    return context.getResources().getBoolean(resourceId);
  }
}
