package com.onegini.action;

import static com.onegini.resource.ResourceRequest.PARAMETERS_WITH_HEADERS_LENGTH;
import static com.onegini.resource.ResourceRequest.buildRequestFromArgs;
import static com.onegini.response.GeneralResponse.CONNECTIVITY_PROBLEM;
import static com.onegini.util.DeviceUtil.isConnected;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;

import android.content.Context;
import com.onegini.OneginiCordovaPlugin;
import com.onegini.resource.AnonymousRequestAdapterFactory;
import com.onegini.resource.RequestAdapterFactory;
import com.onegini.resource.ResourceClientFactory;
import com.onegini.resource.ResourceRequest;
import com.onegini.resource.ResourceRequestCallback;
import com.onegini.util.CallbackResultBuilder;

public class FetchResourceAnonymouslyAction implements OneginiPluginAction {

  @Override
  public void execute(final JSONArray args, final CallbackContext callbackContext, final OneginiCordovaPlugin client) {
    if (args.length() != PARAMETERS_WITH_HEADERS_LENGTH) {
      callbackContext.error("Invalid parameter, expected 6, got " + args.length() + ".");
      return;
    }

    final CallbackResultBuilder callbackResultBuilder = new CallbackResultBuilder();
    final Context context = client.getCordova().getActivity().getApplication();

    if (isConnected(context)) {
      final ResourceRequest resourceRequest = buildRequestFromArgs(args);
      if (resourceRequest == null) {
        callbackContext.error("Failed to fetch resource, invalid params.");
        return;
      }

      final String requestMethod = resourceRequest.getRequestMethodString();
      final ResourceRequestCallback resourceRequestCallback = new ResourceRequestCallback(callbackContext);
      final RequestAdapterFactory requestAdapterFactory = new AnonymousRequestAdapterFactory(client.getOneginiClient());

      new ResourceClientFactory(resourceRequestCallback, requestAdapterFactory)
          .build(requestMethod)
          .send(client.getOneginiClient(), resourceRequest, callbackContext, context);
    } else {
      callbackContext.sendPluginResult(
          callbackResultBuilder
              .withErrorReason(CONNECTIVITY_PROBLEM.getName())
              .build());
    }
  }

}
