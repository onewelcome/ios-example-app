package com.onegini.action;

import static com.onegini.resource.ResourceHandler.buildResourceHandlerForCallback;
import static com.onegini.resource.ResourceRequest.PARAMETERS_WITHOUT_HEADERS_LENGTH;
import static com.onegini.resource.ResourceRequest.PARAMETERS_WITH_HEADERS_LENGTH;
import static com.onegini.resource.ResourceRequest.buildRequestFromArgs;
import static com.onegini.response.GeneralResponse.CONNECTIVITY_PROBLEM;
import static com.onegini.util.DeviceUtil.isNotConnected;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;

import android.content.Context;
import com.onegini.OneginiCordovaPlugin;
import com.onegini.resource.ResourceClient;
import com.onegini.resource.ResourceRequest;
import com.onegini.util.CallbackResultBuilder;

public class FetchResourceAction implements OneginiPluginAction {

  private final CallbackResultBuilder callbackResultBuilder;

  public FetchResourceAction() {
    callbackResultBuilder = new CallbackResultBuilder();
  }

  @Override
  public void execute(final JSONArray args, final CallbackContext callbackContext, final OneginiCordovaPlugin client) {
    if (args.length() != PARAMETERS_WITH_HEADERS_LENGTH && args.length() != PARAMETERS_WITHOUT_HEADERS_LENGTH) {
      callbackContext.error("Invalid parameter, expected 5-6, got " + args.length() + ".");
      return;
    }

    final Context context = client.getCordova().getActivity().getApplication();
    if (isNotConnected(context)) {
      callbackContext.sendPluginResult(
          callbackResultBuilder
              .withErrorReason(CONNECTIVITY_PROBLEM.getName())
              .build()
      );
      return;
    }

    final ResourceRequest resourceRequest = buildRequestFromArgs(args);
    if (resourceRequest == null) {
      callbackContext.error("Failed to fetch resource, invalid params.");
      return;
    }

    final ResourceClient resourceClient = new ResourceClient(client.getOneginiClient(), resourceRequest);
    resourceClient.performResourceAction(buildResourceHandlerForCallback(callbackContext), resourceRequest.getScopes(),
        resourceRequest.getParams().toString());
  }

}
