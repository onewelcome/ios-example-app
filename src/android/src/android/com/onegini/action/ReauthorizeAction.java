package com.onegini.action;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;

import com.onegini.OneginiCordovaPlugin;
import com.onegini.action.authorization.AuthorizationActionExecutor;
import com.onegini.action.authorization.AuthorizationActionHandler;
import com.onegini.action.authorization.AuthorizationActionHandlerFactory;

public class ReauthorizeAction implements OneginiPluginAction {

  @Override
  public void execute(final JSONArray args, final CallbackContext callbackContext, final OneginiCordovaPlugin client) {
    final AuthorizationActionHandler authorizationActionHandler = new AuthorizationActionHandlerFactory(client).buildForReauthorization();
    new AuthorizationActionExecutor(authorizationActionHandler).execute(args, callbackContext, client);
  }

}
