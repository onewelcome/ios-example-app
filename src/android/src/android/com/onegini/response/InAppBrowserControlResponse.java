package com.onegini.response;

public enum InAppBrowserControlResponse {
  CLOSE_IN_APP_BROWSER("closeInAppBrowser");

  private final String name;

  InAppBrowserControlResponse(final String name) {
    this.name = name;
  }

  public String getName() {
    return this.name;
  }

}
