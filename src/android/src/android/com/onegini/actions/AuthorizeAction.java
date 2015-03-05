package com.onegini.actions;

import static com.onegini.OneginiAuthorizationStatus.AUTHORIZATION_ERROR;
import static com.onegini.OneginiAuthorizationStatus.AUTHORIZATION_ERROR_CLIENT_REG_FAILED;
import static com.onegini.OneginiAuthorizationStatus.AUTHORIZATION_ERROR_INVALID_GRANT;
import static com.onegini.OneginiAuthorizationStatus.AUTHORIZATION_ERROR_INVALID_GRANT_TYPE;
import static com.onegini.OneginiAuthorizationStatus.AUTHORIZATION_ERROR_INVALID_REQUEST;
import static com.onegini.OneginiAuthorizationStatus.AUTHORIZATION_ERROR_INVALID_SCOPE;
import static com.onegini.OneginiAuthorizationStatus.AUTHORIZATION_ERROR_INVALID_STATE;
import static com.onegini.OneginiAuthorizationStatus.AUTHORIZATION_ERROR_NOT_AUTHENTICATED;
import static com.onegini.OneginiAuthorizationStatus.AUTHORIZATION_ERROR_NOT_AUTHORIZED;
import static com.onegini.OneginiAuthorizationStatus.AUTHORIZATION_ERROR_TOO_MANY_PIN_FAILURES;
import static com.onegini.OneginiAuthorizationStatus.AUTHORIZATION_SUCCESS;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;
import org.json.JSONException;

import com.onegini.OneginiCordovaPlugin;
import com.onegini.mobile.sdk.android.library.handlers.OneginiAuthorizationHandler;
import com.onegini.scope.ScopeParser;

public class AuthorizeAction implements OneginiPluginAction {

  private static String authorizationCallbackId;
  public static String getAuthorizationCallbackId() {
    return authorizationCallbackId;
  }

  public static void removeAuthorizationCallback() {
    authorizationCallbackId = null;
  }

  @Override
  public void execute(final JSONArray args, final CallbackContext callbackContext, final OneginiCordovaPlugin client) {
    if (args.length() != 1) {
      callbackContext.error("Failed to authorize, invalid parameter.");
      return;
    }
    authorizationCallbackId = callbackContext.getCallbackId();

    try {
      final String[] scopes = new ScopeParser().getScopesAsArray(args);
      client.getOneginiClient().authorize(scopes, new OneginiAuthorizationHandler() {
        @Override
        public void authorizationSuccess() {
          callbackContext.success(AUTHORIZATION_SUCCESS.getName());
        }

        @Override
        public void authorizationError() {
          callbackContext.error(AUTHORIZATION_ERROR.getName());
        }

        @Override
        public void authorizationException(Exception e) {
          callbackContext.error(AUTHORIZATION_ERROR.getName());
        }

        @Override
        public void authorizationErrorInvalidRequest() {
          callbackContext.error(AUTHORIZATION_ERROR_INVALID_REQUEST.getName());
        }

        @Override
        public void authorizationErrorClientRegistrationFailed() {
          callbackContext.error(AUTHORIZATION_ERROR_CLIENT_REG_FAILED.getName());
        }

        @Override
        public void authorizationErrorInvalidState() {
          callbackContext.error(AUTHORIZATION_ERROR_INVALID_STATE.getName());
        }

        @Override
        public void authorizationErrorInvalidGrant(int i) {
          callbackContext.error(AUTHORIZATION_ERROR_INVALID_GRANT.getName());
        }

        @Override
        public void authorizationErrorNotAuthenticated() {
          callbackContext.error(AUTHORIZATION_ERROR_NOT_AUTHENTICATED.getName());
        }

        @Override
        public void authorizationErrorInvalidScope() {
          callbackContext.error(AUTHORIZATION_ERROR_INVALID_SCOPE.getName());
        }

        @Override
        public void authorizationErrorNotAuthorized() {
          callbackContext.error(AUTHORIZATION_ERROR_NOT_AUTHORIZED.getName());
        }

        @Override
        public void authorizationErrorInvalidGrantType() {
          callbackContext.error(AUTHORIZATION_ERROR_INVALID_GRANT_TYPE.getName());
        }

        @Override
        public void authorizationErrorTooManyPinFailures() {
          callbackContext.error(AUTHORIZATION_ERROR_TOO_MANY_PIN_FAILURES.getName());
        }

        @Override
        public void authorizationClientConfigFailed() {
          callbackContext.error(AUTHORIZATION_ERROR.getName());
        }
      });
    } catch (JSONException e) {
      callbackContext.error(AUTHORIZATION_ERROR.getName());
    }
  }
}
