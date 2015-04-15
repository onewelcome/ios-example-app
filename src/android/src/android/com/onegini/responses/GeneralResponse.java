package com.onegini.responses;

public enum GeneralResponse {

  CONNECTIVITY_PROBLEM("connectivityProblem"),
  UNSUPPORTED_APP_VERSION("unsupportedAppVersion");

  private final String name;

  GeneralResponse(final String name) {
    this.name = name;
  }

  public String getName() {
    return name;
  }
}
