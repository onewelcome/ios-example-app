package com.onegini.action;

import com.onegini.mobile.sdk.android.library.handlers.OneginiPinProvidedHandler;

public class PinHandlerProvider {

  private static PinHandlerProvider pinHandlerProvider;
  private OneginiPinProvidedHandler oneginiPinProvidedHandler;

  public static PinHandlerProvider getInstance() {
    if (pinHandlerProvider == null) {
      pinHandlerProvider = new PinHandlerProvider();
    }
    return pinHandlerProvider;
  }

  public void setOneginiPinProvidedHandler(final OneginiPinProvidedHandler oneginiPinProvidedHandler) {
    this.oneginiPinProvidedHandler = oneginiPinProvidedHandler;
  }

  public OneginiPinProvidedHandler getOneginiPinProvidedHandler() {
    return oneginiPinProvidedHandler;
  }
}
