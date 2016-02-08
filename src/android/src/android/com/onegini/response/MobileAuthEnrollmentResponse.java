package com.onegini.response;

public enum MobileAuthEnrollmentResponse {
  ENROLLMENT_SUCCESS("enrollmentSuccess"),
  ENROLLMENT_ERROR("enrollmentError"),
  ENROLLMENT_AUTHENTICATION_ERROR("enrollmentErrorAuthenticationError"),
  ENROLLMENT_NOT_AVAILABLE("enrollmentErrorNotAvailable"),
  ENROLLMENT_INVALID_REQUEST("enrollmentErrorInvalidRequest"),
  ENROLLMENT_INVALID_CREDENTIALS("enrollmentErrorInvalidClientCredentials"),
  ENROLLMENT_DEVICE_ALREADY_ENROLLED("enrollmentErrorDeviceAlreadyEnrolled"),
  ENROLLMENT_USER_ALREADY_ENROLLED("enrollmentErrorUserAlreadyEnrolled"),
  ENROLLMENT_INVALID_TRANSACTION("enrollmentErrorInvalidTransaction");
  private final String name;

  MobileAuthEnrollmentResponse(final String name) {
    this.name = name;
  }

  public String getName() {
    return this.name;
  }
}
