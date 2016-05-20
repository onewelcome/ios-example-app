package com.onegini.action.authorization;

import static com.onegini.response.GeneralResponse.CONNECTIVITY_PROBLEM;
import static com.onegini.util.DeviceUtil.isConnected;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;

import android.content.Context;
import com.onegini.OneginiCordovaPlugin;
import com.onegini.action.ForgotPinHandler;
import com.onegini.dialog.PinScreenActivity;
import com.onegini.mobile.sdk.android.library.handlers.OneginiAuthorizationHandler;
import com.onegini.scope.ScopeParser;
import com.onegini.util.CallbackResultBuilder;

public class AuthorizationActionExecutor {

  private static CallbackContext callbackContext;
  private final AuthorizationActionHandler authorizationActionHandler;

  public static CallbackContext getCallbackContext() {
    return callbackContext;
  }

  public AuthorizationActionExecutor(final AuthorizationActionHandler authorizationActionHandler) {
    this.authorizationActionHandler = authorizationActionHandler;
  }

  public void execute(final JSONArray args, final CallbackContext callbackContext, final OneginiCordovaPlugin client) {
    if (isPreviousAuthorizationCompleted()) {
      saveCallbackContextForGlobalUsage(callbackContext);
      authorize(args, client);
    }
  }

  private void authorize(final JSONArray args, final OneginiCordovaPlugin client) {
    final Context context = client.getCordova().getActivity().getApplication();
    final CallbackResultBuilder callbackResultBuilder = new CallbackResultBuilder();

    if (isConnected(context)) {
      String[] scopes = getScopes(args);
      OneginiAuthorizationHandler authorizationHandler = new DefaultOneginiAuthorizationHandler(callbackResultBuilder, callbackContext, context, client);
      authorizationActionHandler.authorize(scopes, authorizationHandler);
    } else {
      sendCallbackResult(callbackResultBuilder
          .withErrorReason(CONNECTIVITY_PROBLEM.getName())
          .build());
    }
  }

  private String[] getScopes(final JSONArray args) {
    try {
      return new ScopeParser().getScopesAsArray(args.getJSONArray(0));
    } catch (final JSONException exception) {
      return new String[0];
    }
  }

  private void saveCallbackContextForGlobalUsage(final CallbackContext callbackContext) {
    this.callbackContext = callbackContext;
    ForgotPinHandler.setCallbackContext(callbackContext);
  }

  private void sendCallbackResult(final PluginResult result) {
    if (PinScreenActivity.getInstance() != null) {
      PinScreenActivity.getInstance().finish();
    }
    callbackContext.sendPluginResult(result);
  }

  private boolean isPreviousAuthorizationCompleted() {
    return callbackContext == null || callbackContext.isFinished();
  }

}
