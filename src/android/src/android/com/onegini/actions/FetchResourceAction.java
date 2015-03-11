package com.onegini.actions;

import static com.onegini.resource.ResourceHandler.buildResourceHandlerForCallback;
import static com.onegini.resource.ResourceRequest.buildRequestFromArgs;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;

import com.onegini.OneginiCordovaPlugin;
import com.onegini.resource.ResourceClient;
import com.onegini.resource.ResourceRequest;

public class FetchResourceAction implements OneginiPluginAction {
  @Override
  public void execute(final JSONArray args, final CallbackContext callbackContext, final OneginiCordovaPlugin client) {
    if (args.length() != 5) {
      callbackContext.error("Invalid parameter, expected 5, got " + args.length() + ".");
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
