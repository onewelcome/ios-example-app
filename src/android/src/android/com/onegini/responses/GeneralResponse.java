package com.onegini.responses;

public enum GeneralResponse {

  NO_INTERNET_CONNECTION("noInternetConnection");
  
  private final String name;

  GeneralResponse(final String name) {
    this.name = name;
  }

  public String getName() {
    return name;
  }
}
