package com.onegini.action;

import static com.onegini.resource.ResourceRequest.PARAMETERS_WITH_HEADERS_LENGTH;
import static com.onegini.resource.ResourceRequest.buildRequestFromArgs;
import static com.onegini.resource.ResourceRequestCallback.sendCallbackResult;
import static com.onegini.response.GeneralResponse.CONNECTIVITY_PROBLEM;
import static com.onegini.util.DeviceUtil.isConnected;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;

import android.content.Context;
import com.onegini.OneginiCordovaPlugin;
import com.onegini.resource.RequestAdapterFactory;
import com.onegini.resource.ResourceClientFactory;
import com.onegini.resource.ResourceRequest;
import com.onegini.resource.ResourceRequestCallback;
import com.onegini.util.ResourcePluginResultBuilder;

public class FetchResourceAction implements OneginiPluginAction {

  @Override
  public void execute(final JSONArray args, final CallbackContext callbackContext, final OneginiCordovaPlugin client) {
    if (args.length() != PARAMETERS_WITH_HEADERS_LENGTH) {
      sendCallbackResult(callbackContext, new ResourcePluginResultBuilder("Invalid parameter, expected 4, got " + args.length() + ".").withError().build());
      return;
    }

    final Context context = client.getCordova().getActivity().getApplication();

    if (isConnected(context)) {
      final ResourceRequest resourceRequest = buildRequestFromArgs(args);
      if (resourceRequest == null) {
        sendCallbackResult(callbackContext, new ResourcePluginResultBuilder("Failed to fetch resource, invalid params.").withError().build());
        return;
      }

      final String requestMethod = resourceRequest.getRequestMethodString();
      final ResourceRequestCallback resourceRequestCallback = new ResourceRequestCallback(callbackContext);
      final RequestAdapterFactory requestAdapterFactory =
          new RequestAdapterFactory(client.getOneginiClient().getResourceRetrofitClient(), client.getOneginiClient(), resourceRequest);

      new ResourceClientFactory(resourceRequestCallback, requestAdapterFactory)
          .build(requestMethod)
          .send(client.getOneginiClient(), resourceRequest, callbackContext, context);
    } else {
      sendCallbackResult(callbackContext, new ResourcePluginResultBuilder(CONNECTIVITY_PROBLEM.getName()).withError().build());
    }
  }

}
