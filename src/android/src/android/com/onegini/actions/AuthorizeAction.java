package com.onegini.actions;

import static com.onegini.model.MessageKey.AUTHORIZATION_ERROR_PIN_INVALID;
import static com.onegini.model.MessageKey.REMAINING_ATTEMPTS;
import static com.onegini.responses.GeneralResponse.CONNECTIVITY_PROBLEM;
import static com.onegini.responses.GeneralResponse.UNSUPPORTED_APP_VERSION;
import static com.onegini.responses.OneginiAuthorizationResponse.AUTHORIZATION_ERROR;
import static com.onegini.responses.OneginiAuthorizationResponse.AUTHORIZATION_ERROR_CLIENT_REG_FAILED;
import static com.onegini.responses.OneginiAuthorizationResponse.AUTHORIZATION_ERROR_INVALID_GRANT;
import static com.onegini.responses.OneginiAuthorizationResponse.AUTHORIZATION_ERROR_INVALID_GRANT_TYPE;
import static com.onegini.responses.OneginiAuthorizationResponse.AUTHORIZATION_ERROR_INVALID_REQUEST;
import static com.onegini.responses.OneginiAuthorizationResponse.AUTHORIZATION_ERROR_INVALID_SCOPE;
import static com.onegini.responses.OneginiAuthorizationResponse.AUTHORIZATION_ERROR_INVALID_STATE;
import static com.onegini.responses.OneginiAuthorizationResponse.AUTHORIZATION_ERROR_NOT_AUTHENTICATED;
import static com.onegini.responses.OneginiAuthorizationResponse.AUTHORIZATION_ERROR_NOT_AUTHORIZED;
import static com.onegini.responses.OneginiAuthorizationResponse.AUTHORIZATION_ERROR_PIN_FORGOTTEN;
import static com.onegini.responses.OneginiAuthorizationResponse.AUTHORIZATION_ERROR_TOO_MANY_PIN_FAILURES;
import static com.onegini.responses.OneginiAuthorizationResponse.AUTHORIZATION_SUCCESS;
import static com.onegini.util.DeviceUtil.isNotConnected;
import static com.onegini.util.MessageResourceReader.getMessageForKey;
import static com.onegini.util.PinActivityStarter.startLoginScreen;

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
import com.onegini.util.PinActivityStarter;

public class AuthorizeAction implements OneginiPluginAction {

  private static CallbackResultBuilder callbackResultBuilder;
  private static CallbackContext callbackContext;

  public static CallbackContext getCallbackContext() {
    return callbackContext;
  }

  /**
   * Methoad called by native PIN screen if user clicks "Reset PIN" button.
   */
  public static void onPinReset() {
    if (callbackContext == null || callbackContext.isFinished()) {
      return;
    }

    sendCallbackResult(callbackResultBuilder
      .withErrorReason(AUTHORIZATION_ERROR_PIN_FORGOTTEN.getName())
      .build()
    );
  }

  private static void sendCallbackResult(final PluginResult result) {
    if (PinScreenActivity.getInstance() != null) {
      PinScreenActivity.getInstance().finish();
    }
    callbackContext.sendPluginResult(result);
  }

  public AuthorizeAction() {
    callbackResultBuilder = new CallbackResultBuilder();
  }

  private Context context;

  private boolean isExecuting() {
    return callbackContext != null && !callbackContext.isFinished();
  }

  @Override
  public void execute(final JSONArray args, final CallbackContext callbackContext, final OneginiCordovaPlugin client) {
    // if flow already started and not finished yet, don't start it again
    if (isExecuting()) {
      return;
    }

    if (args.length() != 1) {
      callbackContext.error("Failed to authorize, invalid parameter.");
      return;
    }
    this.callbackContext = callbackContext;
    this.context = client.getCordova().getActivity().getApplication();

    if (isNotConnected(context)) {
      sendCallbackResult(callbackResultBuilder
              .withErrorReason(CONNECTIVITY_PROBLEM.getName())
              .build());
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
              .withErrorReason(CONNECTIVITY_PROBLEM.getName())
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
            final String remainingAttemptsKey = getMessageForKey(REMAINING_ATTEMPTS.name());
            final String message = getMessageForKey(AUTHORIZATION_ERROR_PIN_INVALID.name());

            startLoginScreen(context, message.replace(remainingAttemptsKey, Integer.toString(remainingAttempts)));
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

        @Override
        public void authorizationErrorInvalidApplication() {
          sendCallbackResult(callbackResultBuilder
              .withErrorReason(UNSUPPORTED_APP_VERSION.getName())
              .build());
        }
      });
    }
    catch (JSONException e) {
      callbackContext.error(AUTHORIZATION_ERROR.getName());
    }
  }
}
