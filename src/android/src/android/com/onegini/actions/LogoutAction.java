package com.onegini.actions;

import com.onegini.OneginiCordovaPlugin;
import com.onegini.mobile.sdk.android.library.OneginiClient;
import com.onegini.mobile.sdk.android.library.handlers.OneginiRevokeHandler;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;

public class LogoutAction implements OneginiPluginAction {
    @Override
    public boolean execute(JSONArray args, final CallbackContext callbackContext, OneginiCordovaPlugin client) {
        OneginiClient oneginiClient = client.getOneginiClient();
        oneginiClient.logout(new OneginiRevokeHandler() {
            @Override
            public void revokeSuccess() {
                callbackContext.success();
            }

            @Override
            public void revokeError() {
                callbackContext.error("");
            }
        });
        return true;
    }
}
