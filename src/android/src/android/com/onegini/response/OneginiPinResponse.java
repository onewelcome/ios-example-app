package com.onegini.response;

public enum OneginiPinResponse {

  // Authorization flow pin responses
  ASK_FOR_CURRENT_PIN("askForCurrentPin"),
  ASK_FOR_NEW_PIN("askForNewPin"),

  // Pin validation responses
  PIN_BLACKLISTED("pinBlackListed"),
  PIN_SHOULD_NOT_BE_A_SEQUENCE("pinShouldNotBeASequence"),
  PIN_SHOULD_NOT_USE_SIMILAR_DIGITS("pinShouldNotUseSimilarDigits"),
  PIN_MAX_SIMILAR_DIGITS("maxSimilarDigits"),
  PIN_TOO_SHORT("pinTooShort"),
  PIN_ENTRY_ERROR("pinEntryError"),
  PIN_VALIDATION_FAILED_INVALID_CLIENT("pinValidationErrorInvalidClient"),

  // Pin change flow responses
  PIN_CURRENT_INVALID("invalidCurrentPin"),
  PIN_CHANGE_ERROR("pinChangeError"),
  PIN_CHANGE_ASK_FOR_NEW_PIN("askNewPinForChangeRequest"),
  PIN_CHANGE_ASK_FOR_CURRENT_PIN("askCurrentPinForChangeRequest"),
  PIN_CHANGE_ERROR_TOO_MANY_ATTEMPTS("pinChangeErrorTooManyAttempts"),
  PIN_CHANGED("pinChanged");

  private final String name;

  private OneginiPinResponse(final String name) {
    this.name = name;
  }

  public String getName() {
    return name;
  }
}
