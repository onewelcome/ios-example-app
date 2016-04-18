package com.onegini.action.authorization;

import com.onegini.OneginiCordovaPlugin;
import com.onegini.mobile.sdk.android.library.handlers.OneginiAuthorizationHandler;

public class AuthorizationActionHandlerFactory {

  private final OneginiCordovaPlugin client;

  public AuthorizationActionHandlerFactory(final OneginiCordovaPlugin client) {
    this.client = client;
  }

  public AuthorizationActionHandler buildForAuthorization() {
    return new AuthorizationActionHandler() {
      @Override
      public void authorize(final String[] scopes, final OneginiAuthorizationHandler authorizationHandler) {
        client.getOneginiClient().authorize(scopes, authorizationHandler);
      }
    };
  }

  public AuthorizationActionHandler buildForReauthorization() {
    return new AuthorizationActionHandler() {
      @Override
      public void authorize(final String[] scopes, final OneginiAuthorizationHandler authorizationHandler) {
        client.getOneginiClient().reauthorize(scopes, authorizationHandler);
      }
    };
  }

}
