package com.onegini.actions;

import static com.onegini.responses.OneginiAuthorizationResponse.AUTHORIZATION_ERROR;
import static com.onegini.responses.OneginiAuthorizationResponse.AUTHORIZATION_ERROR_CLIENT_REG_FAILED;
import static com.onegini.responses.OneginiAuthorizationResponse.AUTHORIZATION_ERROR_INVALID_GRANT;
import static com.onegini.responses.OneginiAuthorizationResponse.AUTHORIZATION_ERROR_INVALID_GRANT_TYPE;
import static com.onegini.responses.OneginiAuthorizationResponse.AUTHORIZATION_ERROR_INVALID_REQUEST;
import static com.onegini.responses.OneginiAuthorizationResponse.AUTHORIZATION_ERROR_INVALID_SCOPE;
import static com.onegini.responses.OneginiAuthorizationResponse.AUTHORIZATION_ERROR_INVALID_STATE;
import static com.onegini.responses.OneginiAuthorizationResponse.AUTHORIZATION_ERROR_NOT_AUTHENTICATED;
import static com.onegini.responses.OneginiAuthorizationResponse.AUTHORIZATION_ERROR_NOT_AUTHORIZED;
import static com.onegini.responses.OneginiAuthorizationResponse.AUTHORIZATION_ERROR_TOO_MANY_PIN_FAILURES;
import static com.onegini.responses.OneginiAuthorizationResponse.AUTHORIZATION_SUCCESS;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;

import com.onegini.OneginiCordovaPlugin;
import com.onegini.mobile.sdk.android.library.handlers.OneginiAuthorizationHandler;
import com.onegini.mobile.sdk.android.library.handlers.OneginiPinProvidedHandler;
import com.onegini.scope.ScopeParser;
import com.onegini.util.CallbackResultBuilder;

public class AuthorizeAction implements OneginiPluginAction {

  private final CallbackResultBuilder callbackResultBuilder;

  public AuthorizeAction() {
    callbackResultBuilder = new CallbackResultBuilder();
  }

  private static CallbackContext authorizationCallback;

  public static CallbackContext getAuthorizationCallback() {
    return authorizationCallback;
  }

  public static void clearAuthorizationSessionState() {
    authorizationCallback = null;
    awaitingPinProvidedHandler = null;
  }

  private static OneginiPinProvidedHandler awaitingPinProvidedHandler;

  public static void setAwaitingPinProvidedHandler(final OneginiPinProvidedHandler pinProvidedHandler) {
    awaitingPinProvidedHandler = pinProvidedHandler;
  }

  public static OneginiPinProvidedHandler getAwaitingPinProvidedHandler() {
    return awaitingPinProvidedHandler;
  }

  @Override
  public void execute(final JSONArray args, final CallbackContext callbackContext, final OneginiCordovaPlugin client) {
    if (args.length() != 1) {
      callbackContext.error("Failed to authorize, invalid parameter.");
      return;
    }

    authorizationCallback = callbackContext;

    try {
      final String[] scopes = new ScopeParser().getScopesAsArray(args);
      client.getOneginiClient().authorize(scopes, new OneginiAuthorizationHandler() {
        @Override
        public void authorizationSuccess() {
          sendCallbackResult(callbackResultBuilder.withSuccessMessage(AUTHORIZATION_SUCCESS.getName()).build());
        }

        @Override
        public void authorizationError() {
          sendCallbackResult(callbackResultBuilder
              .withErrorReason(AUTHORIZATION_ERROR.getName())
              .build());
        }

        @Override
        public void authorizationException(Exception e) {
          sendCallbackResult(callbackResultBuilder
              .withErrorReason(AUTHORIZATION_ERROR.getName())
              .build());
        }

        @Override
        public void authorizationErrorInvalidRequest() {
          sendCallbackResult(callbackResultBuilder
              .withErrorReason(AUTHORIZATION_ERROR_INVALID_REQUEST
                  .getName()).build());
        }

        @Override
        public void authorizationErrorClientRegistrationFailed() {
          sendCallbackResult(callbackResultBuilder
              .withErrorReason(AUTHORIZATION_ERROR_CLIENT_REG_FAILED.getName())
              .build());
        }

        @Override
        public void authorizationErrorInvalidState() {
          sendCallbackResult(callbackResultBuilder
              .withErrorReason(AUTHORIZATION_ERROR_INVALID_STATE.getName())
              .build());
        }

        @Override
        public void authorizationErrorInvalidGrant(int remainingAttempts) {
          sendCallbackResult(callbackResultBuilder
              .withErrorReason(AUTHORIZATION_ERROR_INVALID_GRANT.getName())
              .withRemainingAttempts(remainingAttempts)
              .build());
        }

        @Override
        public void authorizationErrorNotAuthenticated() {
          sendCallbackResult(callbackResultBuilder
              .withErrorReason(AUTHORIZATION_ERROR_NOT_AUTHENTICATED.getName())
              .build());
        }

        @Override
        public void authorizationErrorInvalidScope() {
          sendCallbackResult(callbackResultBuilder
              .withErrorReason(AUTHORIZATION_ERROR_INVALID_SCOPE.getName())
              .build());
        }

        @Override
        public void authorizationErrorNotAuthorized() {
          sendCallbackResult(callbackResultBuilder
              .withErrorReason(AUTHORIZATION_ERROR_NOT_AUTHORIZED.getName())
              .build());
        }

        @Override
        public void authorizationErrorInvalidGrantType() {
          sendCallbackResult(callbackResultBuilder
              .withErrorReason(AUTHORIZATION_ERROR_INVALID_GRANT_TYPE.getName())
              .build());
        }

        @Override
        public void authorizationErrorTooManyPinFailures() {
          sendCallbackResult(callbackResultBuilder
              .withErrorReason(AUTHORIZATION_ERROR_TOO_MANY_PIN_FAILURES.getName())
              .build());
        }

        @Override
        public void authorizationClientConfigFailed() {
          sendCallbackResult(callbackResultBuilder
              .withErrorReason(AUTHORIZATION_ERROR.getName())
              .build());
        }
      });
    } catch (JSONException e) {
      callbackContext.error(AUTHORIZATION_ERROR.getName());
    }
  }

  private void sendCallbackResult(final PluginResult result) {
    authorizationCallback.sendPluginResult(result);
    clearAuthorizationSessionState();
  }
}
