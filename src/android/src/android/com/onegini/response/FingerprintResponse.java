package com.onegini.response;

public enum FingerprintResponse {
  FINGERPRINT_ENROLMENT_SUCCESS("fingerprint_enrolment_success"),
  FINGERPRINT_ENROLMENT_FAILURE("fingerprint_enrolment_failure"),
  FINGERPRINT_ENROLMENT_FAILURE_TOO_MANY_PIN_ATTEMPTS("fingerprint_enrolment_failure_too_many_attempts");

  private final String name;

  FingerprintResponse(final String name) {
    this.name = name;
  }

  public String getName() {
    return name;
  }
}
