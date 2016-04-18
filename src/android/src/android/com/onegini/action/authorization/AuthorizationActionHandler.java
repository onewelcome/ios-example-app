package com.onegini.action.authorization;

import com.onegini.mobile.sdk.android.library.handlers.OneginiAuthorizationHandler;

public interface AuthorizationActionHandler {

  void authorize(String[] scopes, OneginiAuthorizationHandler authorizationHandler);

}
