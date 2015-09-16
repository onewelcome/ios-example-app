package com.onegini.response;

public enum MobileAuthEnrollmentResponse {
  ENROLLMENT_SUCCESS("mobileAuthenticationEnrollSuccess"),
  ENROLLMENT_ERROR("mobileAuthentication"),
  ENROLLMENT_AUTHENTICATION_ERROR("enrollmentAuthenticationError"),
  ENROLLMENT_NOT_AVAILABLE("enrollmentNotAvailable"),
  ENROLLMENT_INVALID_REQUEST("enrollmentInvalidRequest"),
  ENROLLMENT_INVALID_CREDENTIALS("enrollmentInvalidClientCredentials"),
  ENROLLMENT_DEVICE_ALREADY_ENROLLED("enrollmentDeviceAlreadyEnrolled"),
  ENROLLMENT_USER_ALREADY_ENROLLED("enrollmentUserAlreadyEnrolled"),
  ENROLLMENT_INVALID_TRANSACTION("enrollmentInvalidTransaction");
  private final String name;

  MobileAuthEnrollmentResponse(final String name) {
    this.name = name;
  }

  public String getName() {
    return this.name;
  }
}
