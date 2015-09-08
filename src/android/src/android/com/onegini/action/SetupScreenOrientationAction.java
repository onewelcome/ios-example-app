package com.onegini.action;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;

import android.app.Activity;
import android.content.pm.ActivityInfo;
import com.onegini.OneginiCordovaPlugin;
import com.onegini.util.DeviceUtil;

public class SetupScreenOrientationAction implements OneginiPluginAction {
  @Override
  public void execute(final JSONArray args, final CallbackContext callbackContext, final OneginiCordovaPlugin client) {
    final Activity activity = client.getCordova().getActivity();
    final boolean mightBeTablet = DeviceUtil.isTablet(activity.getApplication());
    if (mightBeTablet) {
      activity.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
    }
    else {
      activity.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
    }
  }
}
