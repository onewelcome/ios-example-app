package com.onegini.action;

import static com.onegini.dialog.helper.PinActivityStarter.startLoginScreen;
import static com.onegini.model.MessageKey.AUTHORIZATION_ERROR_PIN_INVALID;
import static com.onegini.model.MessageKey.REMAINING_ATTEMPTS;
import static com.onegini.response.GeneralResponse.CONNECTIVITY_PROBLEM;
import static com.onegini.response.GeneralResponse.UNSUPPORTED_APP_VERSION;
import static com.onegini.response.OneginiAuthorizationResponse.AUTHORIZATION_ERROR;
import static com.onegini.response.OneginiAuthorizationResponse.AUTHORIZATION_ERROR_CLIENT_REG_FAILED;
import static com.onegini.response.OneginiAuthorizationResponse.AUTHORIZATION_ERROR_INVALID_GRANT;
import static com.onegini.response.OneginiAuthorizationResponse.AUTHORIZATION_ERROR_INVALID_GRANT_TYPE;
import static com.onegini.response.OneginiAuthorizationResponse.AUTHORIZATION_ERROR_INVALID_REQUEST;
import static com.onegini.response.OneginiAuthorizationResponse.AUTHORIZATION_ERROR_INVALID_SCOPE;
import static com.onegini.response.OneginiAuthorizationResponse.AUTHORIZATION_ERROR_INVALID_STATE;
import static com.onegini.response.OneginiAuthorizationResponse.AUTHORIZATION_ERROR_NOT_AUTHENTICATED;
import static com.onegini.response.OneginiAuthorizationResponse.AUTHORIZATION_ERROR_NOT_AUTHORIZED;
import static com.onegini.response.OneginiAuthorizationResponse.AUTHORIZATION_ERROR_TOO_MANY_PIN_FAILURES;
import static com.onegini.response.OneginiAuthorizationResponse.AUTHORIZATION_ERROR_UNSUPPORTED_OS;
import static com.onegini.response.OneginiAuthorizationResponse.AUTHORIZATION_SUCCESS;
import static com.onegini.util.DeviceUtil.isNotConnected;
import static com.onegini.util.MessageResourceReader.getMessageForKey;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;

import android.content.Context;
import com.onegini.OneginiCordovaPlugin;
import com.onegini.dialog.PinScreenActivity;
import com.onegini.mobile.sdk.android.library.handlers.OneginiAuthorizationHandler;
import com.onegini.scope.ScopeParser;
import com.onegini.util.CallbackResultBuilder;

public class AuthorizeAction implements OneginiPluginAction {

  private static CallbackResultBuilder callbackResultBuilder;
  private static CallbackContext callbackContext;

  public static CallbackContext getCallbackContext() {
    return callbackContext;
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

    this.callbackContext = callbackContext;
    ForgotPinHandler.setCallbackContext(callbackContext);
    this.context = client.getCordova().getActivity().getApplication();

    if (isNotConnected(context)) {
      sendCallbackResult(callbackResultBuilder
          .withErrorReason(CONNECTIVITY_PROBLEM.getName())
          .build());
      return;
    }

    String[] scopes = new String[args.length()];
    if (args.length() > 0) {
      try {
        scopes = new ScopeParser().getScopesAsArray(args.getJSONArray(0));
      } catch (final JSONException exception) {
      }
    }

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

      @Override
      public void authorizationErrorUnsupportedOS() {
        sendCallbackResult(callbackResultBuilder
            .withErrorReason(AUTHORIZATION_ERROR_UNSUPPORTED_OS.getName())
            .build());
      }
    });
  }
}
