package com.onegini.actions;

import com.onegini.OneginiCordovaPlugin;
import com.onegini.mobile.sdk.android.library.handlers.OneginiResourceHandler;
import com.onegini.resource.AnonymousResourceClient;
import com.onegini.scope.ScopeParser;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;
import org.json.JSONException;

import java.util.List;

import retrofit.client.Header;

public class FetchResourceAnonymouslyAction implements OneginiPluginAction {

  @Override
  public void execute(final JSONArray args, final CallbackContext callbackContext, final OneginiCordovaPlugin client) {
    try {
      final String requestPath = getPath(args);
      final String[] scopes = getScopes(args);
      final String requestMethod = getRequestMethod(args);
      final String[] params = getRequestParameters(args);
      final AnonymousResourceClient resourceClient = new AnonymousResourceClient(client.getOneginiClient(), requestPath,
          scopes, requestMethod);
      resourceClient.performResourceAction(getResourceHandler(callbackContext), scopes, params);
    } catch (Exception e) {
      callbackContext.error(e.getMessage());
    }
  }

  private OneginiResourceHandler<String> getResourceHandler(final CallbackContext callbackContext) {
    return new OneginiResourceHandler<String>() {
      @Override
      public void resourceSuccess(String response, List<Header> headers) {
        callbackContext.success(response);
      }

      @Override
      public void resourceCallError() {
        callbackContext.error("resourceCallError");
      }

      @Override
      public void resourceCallBadRequest() {
        callbackContext.error("resourceCallError");
      }

      @Override
      public void resourceCallErrorAuthenticationFailed() {
        callbackContext.error("resourceCallErrorAuthenticationFailed");
      }

      @Override
      public void getScopeError() {
      }

      @Override
      public void setRetry(boolean b) {
      }

      @Override
      public boolean isRetry() {
        return false;
      }

      @Override
      public void getUnauthorizedClient() {
      }

      @Override
      public void getInvalidGrantType() {

      }
    };
  }

  private String[] getRequestParameters(JSONArray args) {
    return new String[0];
  }

  private String getRequestMethod(JSONArray args) throws JSONException {
    return args.getString(2);
  }

  private String[] getScopes(JSONArray args) throws JSONException {
    ScopeParser scopeParser = new ScopeParser();
    return scopeParser.getScopesAsArray(args.getJSONArray(1));
  }


  private String getPath(JSONArray args) throws JSONException {
    return args.getString(0);
  }

}
