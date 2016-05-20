package com.onegini.action;

import static com.onegini.dialog.helper.PinActivityStarter.startLoginScreen;
import static com.onegini.model.MessageKey.AUTHORIZATION_ERROR_PIN_INVALID;
import static com.onegini.model.MessageKey.REMAINING_ATTEMPTS;
import static com.onegini.response.FingerprintResponse.FINGERPRINT_ENROLMENT_FAILURE;
import static com.onegini.response.FingerprintResponse.FINGERPRINT_ENROLMENT_FAILURE_TOO_MANY_PIN_ATTEMPTS;
import static com.onegini.response.FingerprintResponse.FINGERPRINT_ENROLMENT_SUCCESS;
import static com.onegini.response.OneginiPinResponse.PIN_CURRENT_INVALID;
import static com.onegini.util.MessageResourceReader.getMessageForKey;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;

import android.app.Application;
import com.onegini.OneginiCordovaPlugin;
import com.onegini.dialog.PinScreenActivity;
import com.onegini.mobile.sdk.android.library.OneginiClient;
import com.onegini.mobile.sdk.android.library.handlers.OneginiFingerprintEnrollmentHandler;
import com.onegini.util.CallbackResultBuilder;

public class EnrollForFingerprintAction implements OneginiPluginAction {

  private CallbackResultBuilder callbackResultBuilder;

  public EnrollForFingerprintAction() {
    callbackResultBuilder = new CallbackResultBuilder();
  }

  @Override
  public void execute(final JSONArray args, final CallbackContext callbackContext, final OneginiCordovaPlugin client) {
    final Application context = client.getCordova().getActivity().getApplication();

    final OneginiClient oneginiClient = client.getOneginiClient();
    oneginiClient.enrollForFingerprintAuthentication(new OneginiFingerprintEnrollmentHandler() {
      @Override
      public void enrollmentSuccess() {
        if (PinScreenActivity.getInstance() != null) {
          PinScreenActivity.getInstance().finish();
        }
        callbackContext.success(FINGERPRINT_ENROLMENT_SUCCESS.getName());
      }

      @Override
      public void enrollmentFailure() {
        callbackContext.sendPluginResult(callbackResultBuilder
            .withErrorReason(FINGERPRINT_ENROLMENT_FAILURE.getName())
            .build());
      }

      @Override
      public void enrollmentErrorInvalidPin(final int remainingAttempts) {
        if (client.shouldUseNativeScreens()) {
          final String remainingAttemptsKey = getMessageForKey(REMAINING_ATTEMPTS.name());
          final String message = getMessageForKey(AUTHORIZATION_ERROR_PIN_INVALID.name());

          startLoginScreen(context, message.replace(remainingAttemptsKey, Integer.toString(remainingAttempts)));
        } else {
          callbackContext.sendPluginResult(callbackResultBuilder
              .withErrorReason(PIN_CURRENT_INVALID.getName())
              .withRemainingAttempts(remainingAttempts)
              .build());
        }
      }

      @Override
      public void enrollmentErrorTooManyPinFailures() {
        callbackContext.sendPluginResult(callbackResultBuilder
            .withErrorReason(FINGERPRINT_ENROLMENT_FAILURE_TOO_MANY_PIN_ATTEMPTS.getName())
            .build());
      }
    });
  }
}
