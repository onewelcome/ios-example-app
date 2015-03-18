package com.onegini.actions;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;

import com.onegini.OneginiCordovaPlugin;

public class AwaitInitialization implements OneginiPluginAction {

  private static CallbackContext pluginInitializedCallback;

  public static void notifyPluginInitialized() {
    if (pluginInitializedCallback == null) {
      return;
    }

    pluginInitializedCallback.success();
  }

  public static void notifyPluginInitializationFailed() {
    if (pluginInitializedCallback == null) {
      return;
    }

    pluginInitializedCallback.error("Failed to initialize plugin.");
  }

  @Override
  public void execute(final JSONArray args, final CallbackContext callbackContext, final OneginiCordovaPlugin client) {
    pluginInitializedCallback = callbackContext;
  }
}
