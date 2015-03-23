package com.onegini.responses;

public enum ResourceCallResponse {
  RESOURCE_CALL_ERROR("resourceCallError"),
  RESOURCE_CALL_AUTH_FAILED("resourceErrorAuthenticationFailed"),
  RESOURCE_CALL_SCOPE_ERROR("scopeError"),
  RESOURCE_CALL_BAD_REQUEST("resourceBadRequest"),
  RESOURCE_CALL_UNAUTHORIZED("unauthorizedClient"),
  RESOURCE_CALL_INVALID_GRANT("invalidGrant");

  private final String name;

  ResourceCallResponse(final String name) {
    this.name = name;
  }

  public String getName() {
    return this.name;
  }
}
