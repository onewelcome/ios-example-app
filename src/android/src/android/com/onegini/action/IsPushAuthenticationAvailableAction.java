package com.onegini.action;


import org.apache.cordova.CallbackContext;
import org.json.JSONArray;

import android.content.Context;
import com.onegini.OneginiCordovaPlugin;

public class IsPushAuthenticationAvailableAction implements OneginiPluginAction {
  @Override
  public void execute(final JSONArray args, final CallbackContext callbackContext, final OneginiCordovaPlugin client) {
    final Context applicationContext = client.cordova.getActivity().getApplicationContext();
    if (client.getOneginiClient().isPushNotificationEnabled(applicationContext)) {
      callbackContext.success();
    }
    else {
      callbackContext.error("Not enrolled for mobile authentication");
    }
  }
}
