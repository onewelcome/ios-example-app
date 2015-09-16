package com.onegini.action;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;

import com.onegini.OneginiCordovaPlugin;

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
