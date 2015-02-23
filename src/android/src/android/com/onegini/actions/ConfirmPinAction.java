package com.onegini.actions;

import com.onegini.OneginiCordovaPlugin;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;

public class ConfirmPinAction implements OneginiPluginAction{
    @Override
    public boolean execute(JSONArray args, CallbackContext callbackContext, OneginiCordovaPlugin client) {
        return false;
    }
}
