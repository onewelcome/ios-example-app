package com.onegini.util;

import static org.apache.cordova.PluginResult.Status.ERROR;
import static org.apache.cordova.PluginResult.Status.OK;

import org.apache.cordova.PluginResult;

public class CallbackResultBuilder {

  private PluginResult result;

  public CallbackResultBuilder withSuccess() {
    result = new PluginResult(OK);
    return this;
  }

  public CallbackResultBuilder withSuccessMessage(final String message) {
    result = new PluginResult(OK, message);
    return this;
  }

  public CallbackResultBuilder withError() {
    result = new PluginResult(ERROR);
    return this;
  }

  public CallbackResultBuilder withErrorMessage(final String message) {
    result = new PluginResult(ERROR, message);
    return this;
  }

  public CallbackResultBuilder withCallbackKept() {
    result.setKeepCallback(true);
    return this;
  }

  public PluginResult build() {
    return result;
  }
}
