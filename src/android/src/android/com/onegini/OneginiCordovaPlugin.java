package com.onegini;

import com.onegini.actions.AuthorizeAction;
import com.onegini.actions.DisconnectAction;
import com.onegini.actions.FetchResourceAction;
import com.onegini.actions.FetchResourceAnonymouslyAction;
import com.onegini.actions.InitAction;
import com.onegini.actions.LogoutAction;
import com.onegini.actions.OneginiPluginAction;
import com.onegini.mobile.sdk.android.library.OneginiClient;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;
import org.json.JSONException;

import java.util.HashMap;
import java.util.Map;

public class OneginiCordovaPlugin extends CordovaPlugin {
    private static Map<String, Class<? extends OneginiPluginAction>> actions = new HashMap<String, Class<? extends OneginiPluginAction>>();
    private OneginiClient oneginiClient;

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        actions.put("initWithConfig", InitAction.class);
        actions.put("authorize", AuthorizeAction.class);
        actions.put("fetchResource", FetchResourceAction.class);
        actions.put("fetchAnonymousResource", FetchResourceAnonymouslyAction.class);
        actions.put("logout", LogoutAction.class);
        actions.put("disconnect", DisconnectAction.class);
        //  actions.put("clearCredentials", null);
        //  actions.put("clearTokens", null);


//        actions.put("confirmPin", null);
//        actions.put("confirmPinWithVerification", null);
//        actions.put("requestAuthorization", null);
//        actions.put("askForPin", null);
//        actions.put("askForPinWithVerification", null);
//        actions.put("authorizationSuccess", null);
//        actions.put("askForPinChangeWithVerification", null);
//        actions.put("changePin", null);
//        actions.put("confirmChangePinWithVerification", null);
//        actions.put("cancelPinChange", null);
    }

    public CordovaInterface getCordova() {
        return cordova;
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (actions.containsKey(action)) {
            Class<? extends OneginiPluginAction> actionClass = actions.get(action);
            try {
                OneginiPluginAction oneginiPluginAction = actionClass.newInstance();
                return oneginiPluginAction.execute(args, callbackContext, this);
            } catch (Exception e) {
                callbackContext.error(e.getMessage());
                return false;
            }
        }
        callbackContext.error("Action \"" + action + "\" is not supported");
        return false;
    }

    public void setOneginiClient(OneginiClient oneginiClient) {
        this.oneginiClient = oneginiClient;
    }

    public OneginiClient getOneginiClient() {
        if (oneginiClient == null) {
            throw new RuntimeException("client not initialized");
        }
        return oneginiClient;
    }
}
