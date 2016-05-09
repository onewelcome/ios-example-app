package com.onegini.resource;

import org.apache.cordova.CallbackContext;

import android.content.Context;
import com.onegini.mobile.sdk.android.library.OneginiClient;

public interface ResourceRequestCommand {

  void send(OneginiClient oneginiClient, ResourceRequest resourceRequest, CallbackContext callbackContext, Context context);

}