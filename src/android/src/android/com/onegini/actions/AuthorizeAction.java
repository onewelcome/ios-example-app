package com.onegini.actions;

import static com.onegini.dialogs.PinDialogMessages.PIN_INVALID;
import static com.onegini.dialogs.PinDialogMessages.REMAINING_ATTEMPTS_KEY;
import static com.onegini.dialogs.PinIntentBroadcaster.broadcastWithMessage;
import static com.onegini.responses.GeneralResponse.NO_INTERNET_CONNECTION;
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
import static com.onegini.util.DeviceUtil.isNotConnected;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;

import android.content.Context;
import com.onegini.OneginiCordovaPlugin;
import com.onegini.dialogs.PinScreenActivity;
import com.onegini.mobile.sdk.android.library.handlers.OneginiAuthorizationHandler;
import com.onegini.scope.ScopeParser;
import com.onegini.util.CallbackResultBuilder;

public class AuthorizeAction implements OneginiPluginAction {

  private final CallbackResultBuilder callbackResultBuilder;
  private static CallbackContext callbackContext;

  public static CallbackContext getCallbackContext() {
    return callbackContext;
  }

  public AuthorizeAction() {
    callbackResultBuilder = new CallbackResultBuilder();
  }

  private Context context;

  @Override
  public void execute(final JSONArray args, final CallbackContext callbackContext, final OneginiCordovaPlugin client) {
    if (args.length() != 1) {
      callbackContext.error("Failed to authorize, invalid parameter.");
      return;
    }
    this.callbackContext = callbackContext;
    this.context = client.getCordova().getActivity().getApplication();

    if (isNotConnected(context)) {
      sendCallbackResult(callbackResultBuilder
              .withErrorReason(NO_INTERNET_CONNECTION.getName())
              .build()
      );
      return;
    }

    try {
      final String[] scopes = new ScopeParser().getScopesAsArray(args);
      client.getOneginiClient().authorize(scopes, new OneginiAuthorizationHandler() {
        @Override
        public void authorizationSuccess() {
          sendCallbackResult(callbackResultBuilder
              .withSuccessMessage(AUTHORIZATION_SUCCESS.getName())
              .build());
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
          // that is the only notification which impacts the pin screen within OneginiAuthorizationHandler
          if (client.shouldUseNativeScreens()) {
            broadcastWithMessage(context,
                PIN_INVALID.replace(REMAINING_ATTEMPTS_KEY, Integer.toString(remainingAttempts)));
          }
          else {
            sendCallbackResult(callbackResultBuilder
                .withErrorReason(AUTHORIZATION_ERROR_INVALID_GRANT.getName())
                .withRemainingAttempts(remainingAttempts)
                .build());
          }
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
    }
    catch (JSONException e) {
      callbackContext.error(AUTHORIZATION_ERROR.getName());
    }
  }

  private void sendCallbackResult(final PluginResult result) {
    if (PinScreenActivity.getInstance() != null) {
      PinScreenActivity.getInstance().finish();
    }
    callbackContext.sendPluginResult(result);
  }

}
