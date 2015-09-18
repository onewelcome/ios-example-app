package com.onegini.action;

import static com.onegini.resource.ResourceHandler.buildResourceHandlerForCallback;
import static com.onegini.resource.ResourceRequest.buildRequestFromArgs;
import static com.onegini.response.GeneralResponse.CONNECTIVITY_PROBLEM;
import static com.onegini.util.DeviceUtil.isNotConnected;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;

import android.content.Context;
import com.onegini.mobile.sdk.android.library.handlers.OneginiResourceHandler;
import com.onegini.OneginiCordovaPlugin;
import com.onegini.resource.AnonymousResourceClient;
import com.onegini.resource.ResourceRequest;
import com.onegini.util.CallbackResultBuilder;

public class FetchResourceAnonymouslyAction implements OneginiPluginAction {

  private final CallbackResultBuilder callbackResultBuilder;

  public FetchResourceAnonymouslyAction() {
    callbackResultBuilder = new CallbackResultBuilder();
  }

  @Override
  public void execute(final JSONArray args, final CallbackContext callbackContext, final OneginiCordovaPlugin client) {
    if (args.length() != 6) {
      callbackContext.error("Invalid parameter, expected 6, got " + args.length() + ".");
      return;
    }

    final Context context = client.getCordova().getActivity().getApplication();
    if (isNotConnected(context)) {
      callbackContext.sendPluginResult(
          callbackResultBuilder
              .withErrorReason(CONNECTIVITY_PROBLEM.getName())
              .build());
      return;
    }

    final ResourceRequest resourceRequest = buildRequestFromArgs(args);
    if (resourceRequest == null) {
      callbackContext.error("Failed to fetch resource, invalid params.");
      return;
    }

    final AnonymousResourceClient resClient = new AnonymousResourceClient(client.getOneginiClient(), resourceRequest);
    final OneginiResourceHandler<String> oneginiResourceHandler = buildResourceHandlerForCallback(callbackContext);
    resClient.performResourceAction(oneginiResourceHandler, resourceRequest.getScopes(), resourceRequest.getParams().toString());
  }
}
