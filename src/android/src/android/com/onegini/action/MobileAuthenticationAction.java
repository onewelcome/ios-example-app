package com.onegini.action;

import static com.onegini.response.GeneralResponse.CONNECTIVITY_PROBLEM;
import static com.onegini.response.MobileAuthEnrollmentResponse.ENROLLMENT_AUTHENTICATION_ERROR;
import static com.onegini.response.MobileAuthEnrollmentResponse.ENROLLMENT_DEVICE_ALREADY_ENROLLED;
import static com.onegini.response.MobileAuthEnrollmentResponse.ENROLLMENT_ERROR;
import static com.onegini.response.MobileAuthEnrollmentResponse.ENROLLMENT_INVALID_CREDENTIALS;
import static com.onegini.response.MobileAuthEnrollmentResponse.ENROLLMENT_INVALID_REQUEST;
import static com.onegini.response.MobileAuthEnrollmentResponse.ENROLLMENT_INVALID_TRANSACTION;
import static com.onegini.response.MobileAuthEnrollmentResponse.ENROLLMENT_NOT_AVAILABLE;
import static com.onegini.response.MobileAuthEnrollmentResponse.ENROLLMENT_SUCCESS;
import static com.onegini.response.MobileAuthEnrollmentResponse.ENROLLMENT_USER_ALREADY_ENROLLED;
import static com.onegini.util.DeviceUtil.isNotConnected;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;
import org.json.JSONException;

import android.content.Context;
import com.onegini.OneginiCordovaPlugin;
import com.onegini.gcm.GCMHelper;
import com.onegini.mobile.sdk.android.library.handlers.OneginiMobileAuthEnrollmentHandler;
import com.onegini.model.ConfigModel;
import com.onegini.resource.ResourceRequest;
import com.onegini.util.CallbackResultBuilder;

public class MobileAuthenticationAction implements OneginiPluginAction {

  private CallbackResultBuilder callbackResultBuilder;

  public MobileAuthenticationAction() {
    callbackResultBuilder = new CallbackResultBuilder();
  }

  @Override
  public void execute(final JSONArray args, final CallbackContext callbackContext, final OneginiCordovaPlugin client) {
    if (args.length() != 1) {
      callbackContext.error("Invalid parameter, expected 1, got " + args.length() + ".");
      return;
    }

    final Context context = client.getCordova().getActivity().getApplication();
    if (isNotConnected(context)) {
      callbackContext.sendPluginResult(callbackResultBuilder.withErrorReason(CONNECTIVITY_PROBLEM.getName()).build()
      );
      return;
    }

    try {
      final String[] scopes = ResourceRequest.parseScopes(args.getJSONArray(0));
      final ConfigModel configModel = (ConfigModel) client.getOneginiClient().getConfigModel();
      final String gcmSenderId = configModel.getGcmSenderId();
      enroll(client, scopes, gcmSenderId, callbackContext);
    } catch (JSONException e) {
      callbackContext.error("Invalid parameter, failed to read scopes," + e.getMessage());
    }
  }

  private void enroll(final OneginiCordovaPlugin client, final String[] scopes, final String gcmSenderId, final CallbackContext callbackContext) {
    final GCMHelper gcmHelper = new GCMHelper(client.getCordova().getActivity());
    gcmHelper.registerGCMService(client.getOneginiClient(), scopes, gcmSenderId, buildEnrollHandlerForCallback(callbackContext));
  }

  private OneginiMobileAuthEnrollmentHandler buildEnrollHandlerForCallback(final CallbackContext callbackContext) {
    return new OneginiMobileAuthEnrollmentHandler() {
      @Override
      public void enrollmentSuccess() {
        callbackContext.success(ENROLLMENT_SUCCESS.getName());
      }

      @Override
      public void enrollmentError() {
        callbackContext.sendPluginResult(
            callbackResultBuilder
                .withErrorReason(ENROLLMENT_ERROR.getName())
                .build());
      }

      @Override
      public void enrollmentAuthenticationError() {
        callbackContext.sendPluginResult(
            callbackResultBuilder
                .withErrorReason(ENROLLMENT_AUTHENTICATION_ERROR.getName())
                .build());
      }

      @Override
      public void enrollmentException(final Exception exception) {
        callbackContext.sendPluginResult(
            callbackResultBuilder
                .withErrorReason(ENROLLMENT_ERROR.getName())
                .build());
      }

      @Override
      public void enrollmentNotAvailable() {
        callbackContext.sendPluginResult(
            callbackResultBuilder
                .withErrorReason(ENROLLMENT_NOT_AVAILABLE.getName())
                .build());
      }

      @Override
      public void enrollmentInvalidRequest() {
        callbackContext.sendPluginResult(
            callbackResultBuilder
                .withErrorReason(ENROLLMENT_INVALID_REQUEST.getName())
                .build());
      }

      @Override
      public void enrollmentInvalidClientCredentials() {
        callbackContext.sendPluginResult(
            callbackResultBuilder
                .withErrorReason(ENROLLMENT_INVALID_CREDENTIALS.getName())
                .build());
      }

      @Override
      public void enrollmentDeviceAlreadyEnrolled() {
        callbackContext.sendPluginResult(
            callbackResultBuilder
                .withErrorReason(ENROLLMENT_DEVICE_ALREADY_ENROLLED.getName())
                .build());
      }

      @Override
      public void enrollmentUserAlreadyEnrolled() {
        callbackContext.sendPluginResult(
            callbackResultBuilder
                .withErrorReason(ENROLLMENT_USER_ALREADY_ENROLLED.getName())
                .build());
      }

      @Override
      public void enrollmentInvalidTransaction() {
        callbackContext.sendPluginResult(
            callbackResultBuilder
                .withErrorReason(ENROLLMENT_INVALID_TRANSACTION.getName())
                .build());
      }
    };
  }
}
