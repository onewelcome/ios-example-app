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
import static com.onegini.OneginiConstants.ENROLL_FOR_FINGEPRINT_AUTHENITCATION;
import static com.onegini.OneginiConstants.FETCH_ANONYMOUS_ACTION;
import static com.onegini.OneginiConstants.FETCH_RESOURCE_ACTION;
import static com.onegini.OneginiConstants.INIT_PIN_CALLBACK_SESSION;
import static com.onegini.OneginiConstants.IN_APP_BROWSER_CONTROL_CALLBACK_SESSION;
import static com.onegini.OneginiConstants.LOGOUT_ACTION;
import static com.onegini.OneginiConstants.MOBILE_AUTHENTICATION_ENROLL_ACTION;
import static com.onegini.OneginiConstants.CHECK_MOBILE_AUTHENTICATION_AVAILABLE_ACTION;
import static com.onegini.OneginiConstants.SETUP_SCREEN_ORIENTATION;
import static com.onegini.OneginiConstants.VALIDATE_PIN_ACTION;

import java.util.HashMap;
import java.util.Map;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;

import android.content.Intent;
import android.net.Uri;
import android.view.View;
import android.view.WindowManager;
import com.onegini.action.AuthorizeAction;
import com.onegini.action.AwaitInitialization;
import com.onegini.action.ChangePinAction;
import com.onegini.action.EnrollForFingerprintAction;
import com.onegini.action.IsPushAuthenticationAvailableAction;
import com.onegini.action.CheckIsRegisteredAction;
import com.onegini.action.DisconnectAction;
import com.onegini.action.FetchResourceAction;
import com.onegini.action.FetchResourceAnonymouslyAction;
import com.onegini.action.InAppBrowserControlSession;
import com.onegini.action.LogoutAction;
import com.onegini.action.MobileAuthenticationAction;
import com.onegini.action.OneginiPluginAction;
import com.onegini.action.PinCallbackSession;
import com.onegini.action.PinProvidedAction;
import com.onegini.action.PluginInitializer;
import com.onegini.action.SetupScreenOrientationAction;
import com.onegini.action.ValidatePinAction;
import com.onegini.mobile.sdk.android.library.OneginiClient;
import com.onegini.mobile.sdk.android.library.model.OneginiClientConfigModel;

public class OneginiCordovaPlugin extends CordovaPlugin {

  private static Map<String, Class<? extends OneginiPluginAction>> actions = new HashMap<String, Class<? extends OneginiPluginAction>>();
  private OneginiClient oneginiClient;

  @Override
  protected void pluginInitialize() {
    mapActions();

    final PluginInitializer initializer = new PluginInitializer();
    initializer.setup(this);

    preventSystemScreenshots();
    preventTextSelection();
  }

  public CordovaInterface getCordova() {
    return cordova;
  }

  @Override
  public boolean execute(final String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException {
    if (actions.containsKey(action)) {
      final OneginiPluginAction actionInstance = buildActionClassFor(action);
      if (actionInstance == null) {
        callbackContext.error("Failed to create action class for \"" + action + "\"");
        return false;
      }
      actionInstance.execute(args, callbackContext, this);
      return true;
    }
    callbackContext.error("Action \"" + action + "\" is not supported");
    return false;
  }

  private void mapActions() {
    actions.put(AWAIT_INITIALIZATION, AwaitInitialization.class);
    actions.put(INIT_PIN_CALLBACK_SESSION, PinCallbackSession.class);
    actions.put(IN_APP_BROWSER_CONTROL_CALLBACK_SESSION, InAppBrowserControlSession.class);
    actions.put(SETUP_SCREEN_ORIENTATION, SetupScreenOrientationAction.class);

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

    actions.put(MOBILE_AUTHENTICATION_ENROLL_ACTION, MobileAuthenticationAction.class);
    actions.put(CHECK_IS_REGISTERED_ACTION, CheckIsRegisteredAction.class);
    actions.put(CHECK_MOBILE_AUTHENTICATION_AVAILABLE_ACTION, IsPushAuthenticationAvailableAction.class);

    actions.put(ENROLL_FOR_FINGEPRINT_AUTHENITCATION, EnrollForFingerprintAction.class);
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

  /**
   * Prevent system from taking app screenshot when going into background and showing the screenshot
   * in the Task Manager.
   */
  private void preventSystemScreenshots() {
    getCordova().getActivity().getWindow().addFlags(WindowManager.LayoutParams.FLAG_SECURE);
  }

  /**
   * Prevent system from showing copy/paste menu after long click in webview
   */
  private void preventTextSelection() {
    webView.getView().setOnLongClickListener(new View.OnLongClickListener() {
      public boolean onLongClick(View v) {
        return true;
      }
    });
  }
}
