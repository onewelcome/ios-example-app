package com.onegini.resource;

import org.apache.cordova.CallbackContext;

import android.content.Context;
import com.onegini.mobile.sdk.android.library.OneginiClient;

public class PostResourceRequestCommand implements ResourceRequestCommand {

  private final ResourceRequestCallback resourceRequestCallback;
  private final RequestAdapterFactory requestAdapterFactory;

  public PostResourceRequestCommand(final ResourceRequestCallback resourceRequestCallback, final RequestAdapterFactory restAdapterFactory) {
    this.resourceRequestCallback = resourceRequestCallback;
    this.requestAdapterFactory = restAdapterFactory;
  }

  public void send(final OneginiClient oneginiClient, final ResourceRequest resourceRequest, final CallbackContext callbackContext, final Context context) {
    requestAdapterFactory
        .buildPostRequestAdapter()
        .call(resourceRequest.getPath(), getRequestBody(resourceRequest), resourceRequestCallback.buildResponseCallback());
  }

  private String getRequestBody(final ResourceRequest resourceRequest) {
    final String params = resourceRequest.getParams().toString();
    if (params == null) {
      return "{}";
    }
    return params;
  }

}