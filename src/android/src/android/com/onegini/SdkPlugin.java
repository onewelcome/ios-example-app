package com.onegini;

import com.onegini.mobile.sdk.android.library.OneginiClient;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;

public class SdkPlugin extends CordovaPlugin {

        @Override
        public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {

               try {
                     OneginiClient oneginiClient = OneginiClient.getInstance();
                     callbackContext.success();
                     return true;
                } catch (Exception e) {
                  callbackContext.error(e.getMessage());
                  return false;
               }
	}

}
