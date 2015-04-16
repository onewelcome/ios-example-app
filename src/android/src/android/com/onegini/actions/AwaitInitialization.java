package com.onegini.actions;

import static com.onegini.responses.GeneralResponse.CONNECTIVITY_PROBLEM;
import static com.onegini.util.DeviceUtil.isNotConnected;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;

import android.content.Context;
import com.onegini.OneginiCordovaPlugin;
import com.onegini.util.CallbackResultBuilder;

public class AwaitInitialization implements OneginiPluginAction {

  private static CallbackContext pluginInitializedCallback;

  public static void notifyIfPluginInitialized() {
    if (pluginInitializedCallback == null) {
      return;
    }

    if (PluginInitializer.isConfigured() &&
        isPinCallbackSessionSet() &&
        isInAppBrowserControlCallbackSessionSet()) {
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

    final CallbackResultBuilder callbackResultBuilder = new CallbackResultBuilder();
    final Context context = client.getCordova().getActivity().getApplication();

    if (isNotConnected(context)) {
      callbackContext.sendPluginResult(callbackResultBuilder
              .withErrorReason(CONNECTIVITY_PROBLEM.getName())
              .build());
      return;
    }

    notifyIfPluginInitialized();
  }

  private static boolean isPinCallbackSessionSet() {
    return PinCallbackSession.getPinCallback() != null;
  }

  private static boolean isInAppBrowserControlCallbackSessionSet() {
    return InAppBrowserControlSession.getInAppBrowserControlCallback() != null;
  }
}
