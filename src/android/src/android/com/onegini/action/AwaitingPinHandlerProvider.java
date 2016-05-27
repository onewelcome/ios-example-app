package com.onegini.action;

import com.onegini.mobile.sdk.android.library.handlers.OneginiPinProvidedHandler;

public class AwaitingPinHandlerProvider {

  private static AwaitingPinHandlerProvider awaitingPinHandlerProvider;
  private OneginiPinProvidedHandler awaitingPinProvidedHandler;

  public static AwaitingPinHandlerProvider getInstance() {
    if (awaitingPinHandlerProvider == null) {
      awaitingPinHandlerProvider = new AwaitingPinHandlerProvider();
    }
    return awaitingPinHandlerProvider;
  }

  public void setAwaitingPinProvidedHandler(final OneginiPinProvidedHandler awaitingPinProvidedHandler) {
    this.awaitingPinProvidedHandler = awaitingPinProvidedHandler;
  }

  public OneginiPinProvidedHandler getAwaitingPinProvidedHandler() {
    return awaitingPinProvidedHandler;
  }
}
