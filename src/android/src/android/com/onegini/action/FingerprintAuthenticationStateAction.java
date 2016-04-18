package com.onegini.action;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;

import com.onegini.OneginiCordovaPlugin;
import com.onegini.mobile.sdk.android.library.OneginiClient;
import com.onegini.util.CallbackResultBuilder;

public class FingerprintAuthenticationStateAction implements OneginiPluginAction {

  @Override
  public void execute(final JSONArray args, final CallbackContext callbackContext, final OneginiCordovaPlugin client) {
    final OneginiClient oneginiClient = client.getOneginiClient();
    if (oneginiClient.isEnrolledForFingerprintAuthentication()) {
      sendFingerpringEnabledResponse(callbackContext);
    } else {
      sendFingerpringDisabledResponse(callbackContext);
    }
  }

  private void sendFingerpringEnabledResponse(final CallbackContext callbackContext) {
    callbackContext.sendPluginResult(new CallbackResultBuilder().withSuccess().build());
  }

  private void sendFingerpringDisabledResponse(final CallbackContext callbackContext) {
    callbackContext.sendPluginResult(new CallbackResultBuilder().withError().build());
  }

}
