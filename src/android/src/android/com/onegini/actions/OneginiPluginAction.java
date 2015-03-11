package com.onegini.actions;

import com.onegini.OneginiCordovaPlugin;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;

public interface OneginiPluginAction {
     void execute(JSONArray args, CallbackContext callbackContext, OneginiCordovaPlugin client) ;
}
