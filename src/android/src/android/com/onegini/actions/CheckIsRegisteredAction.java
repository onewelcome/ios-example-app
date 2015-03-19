package com.onegini.actions;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;

import com.onegini.OneginiCordovaPlugin;

/**
 * Created by Robert on 19.03.15.
 */
public class CheckIsRegisteredAction implements OneginiPluginAction {

  @Override
  public void execute(final JSONArray args, final CallbackContext callbackContext, final OneginiCordovaPlugin client) {
    if (client.getOneginiClient().isRegistered()) {
      callbackContext.success();
    }
    else {
      callbackContext.error("User unregistered");
    }
  }
}
