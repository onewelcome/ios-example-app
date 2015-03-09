package com.onegini.actions;

import com.onegini.OneginiCordovaPlugin;
import com.onegini.mobile.sdk.android.library.OneginiClient;
import com.onegini.mobile.sdk.android.library.handlers.OneginiLogoutHandler;
import com.onegini.mobile.sdk.android.library.handlers.OneginiRevokeHandler;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;

public class LogoutAction implements OneginiPluginAction {
  @Override
  public void execute(final JSONArray args, final CallbackContext callbackContext,
                         final OneginiCordovaPlugin client) {
    client.getOneginiClient().logout(new OneginiLogoutHandler() {
      @Override
      public void revokeSuccess() {
        callbackContext.success();
      }

      @Override
      public void revokeError() {
        callbackContext.error("Failed to logout user.");
      }
    });
  }
}
