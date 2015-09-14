package com.onegini.actions;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;

import com.onegini.OneginiCordovaPlugin;
import com.onegini.mobile.sdk.android.library.handlers.OneginiLogoutHandler;

public class LogoutAction implements OneginiPluginAction {
  @Override
  public void execute(final JSONArray args, final CallbackContext callbackContext,
                         final OneginiCordovaPlugin client) {
    client.getOneginiClient().logout(new OneginiLogoutHandler() {
      @Override
      public void logoutSuccess() {
        callbackContext.success();
      }

      @Override
      public void logoutError() {
        callbackContext.error("Failed to logout user.");
      }
    });
  }
}
