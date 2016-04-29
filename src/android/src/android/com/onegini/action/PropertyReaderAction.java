package com.onegini.action;

import static com.onegini.model.ConfigModel.CONFIG_KEY_APP_BASE_URL;

import java.util.Arrays;
import java.util.List;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.Config;
import org.json.JSONArray;
import org.json.JSONException;

import com.onegini.OneginiCordovaPlugin;
import com.onegini.model.ConfigModel;
import com.onegini.util.CallbackResultBuilder;

public class PropertyReaderAction implements OneginiPluginAction {

  private static List<String> supportedKeys = Arrays.asList(CONFIG_KEY_APP_BASE_URL);

  @Override
  public void execute(final JSONArray args, final CallbackContext callbackContext, final OneginiCordovaPlugin client) {
    if (isValidRequest(args)) {
      final ConfigProperty requestedProperty = new ConfigProperty(args);
      final String propertyValue = readProperty(requestedProperty.getKey());
      sendResult(callbackContext, propertyValue);
    } else {
      sendEmptyResult(callbackContext);
    }
  }

  private String readProperty(final String propertyKey) {
    if (supportedKeys.contains(propertyKey)) {
      return ConfigModel.getStringFromPreferences(Config.getPreferences(), propertyKey);
    } else {
      return "";
    }
  }

  private void sendEmptyResult(final CallbackContext callbackContext) {
    sendResult(callbackContext, "");
  }

  private void sendResult(final CallbackContext callbackContext, final String propertyValue) {
    callbackContext.sendPluginResult(new CallbackResultBuilder().withSuccessMessage(propertyValue).build());
  }

  private boolean isValidRequest(final JSONArray args) {
    return new RequestValidator(args).isValid();
  }

  private static class ConfigProperty {

    private final JSONArray args;

    ConfigProperty(final JSONArray args) {
      this.args = args;
    }

    String getKey() {
      try {
        return args.getString(0);
      } catch (JSONException e) {
        return "";
      }
    }

  }

  private static class RequestValidator {

    private JSONArray args;

    public RequestValidator(final JSONArray args) {
      this.args = args;
    }

    boolean isValid() {
      return isConfigParameterValid();
    }

    private boolean isConfigParameterValid() {
      return args.length() == 1 && !args.optString(0).isEmpty();
    }
  }

}
