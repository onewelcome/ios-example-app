package com.onegini.action;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;

import com.onegini.OneginiCordovaPlugin;
import com.onegini.mobile.sdk.android.library.OneginiClient;
import com.onegini.util.CallbackResultBuilder;

public class DisableFingerprintAuthenticationAction implements OneginiPluginAction {

  @Override
  public void execute(final JSONArray args, final CallbackContext callbackContext, final OneginiCordovaPlugin client) {
    final OneginiClient oneginiClient = client.getOneginiClient();
    oneginiClient.disableFingerprintAuthentication();

    callbackContext.sendPluginResult(new CallbackResultBuilder().withSuccess().build());
  }

}
