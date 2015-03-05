package com.onegini.util;


public enum OneginiAuthorizationStatus {

  AUTHORIZATION_SUCCSESS("authorizationSuccess"),
  AUTHORIZATION_REQUEST("requestAuthorization"),
  AUTHORIZATION_ERROR("authorizationError"),
  AUTHORIZATION_ERROR_CLIENT_REG_FAILED("authorizationErrorClientRegistrationFailed"),
  AUTHORIZATION_ERROR_INVALID_GRANT("authorizationErrorInvalidGrant"),
  AUTHORIZATION_ERROR_TOO_MANY_PIN_FAILURES("authorizationErrorTooManyPinFailures"),
  AUTHORIZATION_ERROR_NOT_AUTHENTICATED("authorizationErrorNotAuthenticated"),
  AUTHORIZATION_ERROR_INVALID_SCOPE("authorizationErrorInvalidScope"),
  AUTHORIZATION_ERROR_INVALID_STATE("authorizationErrorInvalidState"),
  AUTHORIZATION_ERROR_NO_ACCESS("authorizationErrorNoAccessToken"),
  AUTHORIZATION_ERROR_NOT_AUTHORIZED("authorizationErrorNotAuthorized"),
  AUTHORIZATION_ERROR_INVALID_REQUEST("authorizationErrorInvalidRequest"),
  AUTHORIZATION_ERROR_INVALID_GRANT_TYPE("authorizationErrorInvalidGrantType"),
  AUTHORIZATION_ERROR_NO_AUTH_GRANT("authorizationErrorNoAuthorizationGrant");

  private final String name;

  private OneginiAuthorizationStatus(final String name) {
    this.name = name;
  }

  public String getName() {
    return name;
  }

}
