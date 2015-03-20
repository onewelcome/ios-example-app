package com.onegini.actions;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;

import com.onegini.OneginiCordovaPlugin;

public class AwaitInitialization implements OneginiPluginAction {

  private static CallbackContext pluginInitializedCallback;

  public static void notifyIfPluginInitialized() {
    if (pluginInitializedCallback == null) {
      return;
    }

    if (PluginInitializer.isConfigured() &&
        isPinCallbackSessionSet()) {
      pluginInitializedCallback.success();
    }
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

    notifyIfPluginInitialized();
  }

  private static boolean isPinCallbackSessionSet() {
    return PinCallbackSession.getPinCallback() != null;
  }
}
