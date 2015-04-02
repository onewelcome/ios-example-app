package com.onegini;

import static com.onegini.OneginiConstants.AUTHORIZE_ACTION;
import static com.onegini.OneginiConstants.AWAIT_INITIALIZATION;
import static com.onegini.OneginiConstants.CHANGE_PIN_ACTION;
import static com.onegini.OneginiConstants.CHECK_IS_REGISTERED_ACTION;
import static com.onegini.OneginiConstants.CONFIRM_CURRENT_PIN_ACTION;
import static com.onegini.OneginiConstants.CONFIRM_CURRENT_PIN_CHANGE_PIN_ACTION;
import static com.onegini.OneginiConstants.CONFIRM_NEW_PIN_ACTION;
import static com.onegini.OneginiConstants.CONFIRM_NEW_PIN_CHANGE_PIN_ACTION;
import static com.onegini.OneginiConstants.DISCONNECT_ACTION;
import static com.onegini.OneginiConstants.FETCH_ANONYMOUS_ACTION;
import static com.onegini.OneginiConstants.FETCH_RESOURCE_ACTION;
import static com.onegini.OneginiConstants.INIT_PIN_CALLBACK_SESSION;
import static com.onegini.OneginiConstants.LOGOUT_ACTION;
import static com.onegini.OneginiConstants.MOBILE_AUTHENTICATION_ACTION;
import static com.onegini.OneginiConstants.VALIDATE_PIN_ACTION;

import java.util.HashMap;
import java.util.Map;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;
import org.json.JSONException;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import com.onegini.actions.AuthorizeAction;
import com.onegini.actions.AwaitInitialization;
import com.onegini.actions.ChangePinAction;
import com.onegini.actions.CheckIsRegisteredAction;
import com.onegini.actions.DisconnectAction;
import com.onegini.actions.FetchResourceAction;
import com.onegini.actions.FetchResourceAnonymouslyAction;
import com.onegini.actions.LogoutAction;
import com.onegini.actions.MobileAuthenticationAction;
import com.onegini.actions.OneginiPluginAction;
import com.onegini.actions.PinCallbackSession;
import com.onegini.actions.PinProvidedAction;
import com.onegini.actions.PluginInitializer;
import com.onegini.actions.ValidatePinAction;
import com.onegini.mobile.sdk.android.library.OneginiClient;
import com.onegini.mobile.sdk.android.library.model.OneginiClientConfigModel;

public class OneginiCordovaPlugin extends CordovaPlugin {
  private static Map<String, Class<? extends OneginiPluginAction>> actions = new HashMap<String, Class<? extends OneginiPluginAction>>();
  private OneginiClient oneginiClient;

  @Override
  protected void pluginInitialize() {
    actions.put(AWAIT_INITIALIZATION, AwaitInitialization.class);
    actions.put(INIT_PIN_CALLBACK_SESSION, PinCallbackSession.class);

    actions.put(AUTHORIZE_ACTION, AuthorizeAction.class);
    actions.put(CONFIRM_CURRENT_PIN_ACTION, PinProvidedAction.class);
    actions.put(CONFIRM_NEW_PIN_ACTION, PinProvidedAction.class);
    actions.put(CONFIRM_CURRENT_PIN_CHANGE_PIN_ACTION, PinProvidedAction.class);
    actions.put(CONFIRM_NEW_PIN_CHANGE_PIN_ACTION, PinProvidedAction.class);
    actions.put(VALIDATE_PIN_ACTION, ValidatePinAction.class);
    actions.put(CHANGE_PIN_ACTION, ChangePinAction.class);

    actions.put(FETCH_RESOURCE_ACTION, FetchResourceAction.class);
    actions.put(FETCH_ANONYMOUS_ACTION, FetchResourceAnonymouslyAction.class);

    actions.put(LOGOUT_ACTION, LogoutAction.class);
    actions.put(DISCONNECT_ACTION, DisconnectAction.class);
    actions.put(MOBILE_AUTHENTICATION_ACTION, MobileAuthenticationAction.class);
    actions.put(CHECK_IS_REGISTERED_ACTION, CheckIsRegisteredAction.class);

    final PluginInitializer initializer = new PluginInitializer();
    initializer.setup(this);
  }

  public CordovaInterface getCordova() {
    return cordova;
  }

  @Override
  public boolean execute(final String action, final JSONArray args,
                         final CallbackContext callbackContext) throws JSONException {
    if (actions.containsKey(action)) {
      final OneginiPluginAction actionInstance = buildActionClassFor(action);
      if (actionInstance == null) {
        callbackContext.error("Failed to create action class for \"" + action + "\"");
        return false;
      }
      actionInstance.execute(args, callbackContext, this);
      return true;
    }
    // TODO test call
    else if (action.equals("openPinActivity")) {
      final Context context = cordova.getActivity().getApplicationContext();
      final Intent intent = new Intent(context, PinScreenActivity.class);
      cordova.startActivityForResult(this, intent, 0); //TODO change 0 for ID
    }
    callbackContext.error("Action \"" + action + "\" is not supported");
    return false;
  }

  private OneginiPluginAction buildActionClassFor(final String action) {
    Class<? extends OneginiPluginAction> actionClass = actions.get(action);
    try {
      return actionClass.newInstance();
    } catch (Exception e) {
    }
    return null;
  }

  @Override
  public void onNewIntent(final Intent intent) {
    final Uri callbackUri = intent.getData();
    if (callbackUri == null) {
      return;
    }
    final OneginiClientConfigModel configModel = getOneginiClient().getConfigModel();
    if (configModel == null) {
      return;
    }
    final String appScheme = configModel.getAppScheme();
    if (callbackUri.getScheme().equals(appScheme)) {
      getOneginiClient().handleAuthorizationCallback(callbackUri);
    }
  }

  public void setOneginiClient(final OneginiClient oneginiClient) {
    this.oneginiClient = oneginiClient;
  }

  public OneginiClient getOneginiClient() {
    if (oneginiClient == null) {
      throw new RuntimeException("client not initialized");
    }
    return oneginiClient;
  }
}
