package com.onegini.action;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.Config;
import org.json.JSONArray;
import org.json.JSONException;

import com.onegini.OneginiCordovaPlugin;
import com.onegini.exception.PluginConfigException;
import com.onegini.model.ConfigModel;
import com.onegini.util.CallbackResultBuilder;

public class PropertyReaderAction implements OneginiPluginAction {

  @Override
  public void execute(final JSONArray args, final CallbackContext callbackContext, final OneginiCordovaPlugin client) {
    if (isValidRequest(args)) {
      final String key = readKey(args);
      final String value = readProperty(key);
      sendResult(callbackContext, value);
    } else {
      sendEmptyResult(callbackContext);
    }
  }

  private boolean isValidRequest(final JSONArray args) {
    return isRequestedKeyValid(args);
  }

  private boolean isRequestedKeyValid(final JSONArray args) {
    return args.length() == 1 && !args.optString(0).isEmpty();
  }

  private String readKey(final JSONArray args) {
    try {
      return args.getString(0);
    } catch (final JSONException e) {
      return "";
    }
  }

  private String readProperty(final String key) {
    try {
      return ConfigModel.getStringFromPreferences(Config.getPreferences(), key);
    } catch (PluginConfigException e) {
      return "";
    }
  }

  private void sendResult(final CallbackContext callbackContext, final String propertyValue) {
    callbackContext.sendPluginResult(new CallbackResultBuilder().withSuccessMessage(propertyValue).build());
  }

  private void sendEmptyResult(final CallbackContext callbackContext) {
    sendResult(callbackContext, "");
  }

}
