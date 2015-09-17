package com.onegini.exception;

public class PluginConfigException extends RuntimeException {
  public PluginConfigException() {
    super();
  }

  public PluginConfigException(final String detailMessage) {
    super(detailMessage);
  }

  public PluginConfigException(final String detailMessage, final Throwable throwable) {
    super(detailMessage, throwable);
  }

  public PluginConfigException(final Throwable throwable) {
    super(throwable);
  }
}