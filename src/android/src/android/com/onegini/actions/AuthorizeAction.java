package com.onegini.actions;

import com.onegini.OneginiCordovaPlugin;
import com.onegini.mobile.sdk.android.library.handlers.OneginiAuthorizationHandler;
import com.onegini.scope.ScopeParser;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;
import org.json.JSONException;

public class AuthorizeAction implements OneginiPluginAction {
    @Override
    public boolean execute(JSONArray args, final CallbackContext callbackContext, OneginiCordovaPlugin client) {
        if (args.length() == 1) {
            try {
                String[] scopes = new ScopeParser().getScopesAsArray(args);
                client.getOneginiClient().authorize(scopes, new OneginiAuthorizationHandler() {
                    @Override
                    public void authorizationSuccess() {
                        callbackContext.success();
                    }

                    @Override
                    public void authorizationError() {
                        callbackContext.error("");
                    }

                    @Override
                    public void authorizationException(Exception e) {
                        callbackContext.error("");
                    }

                    @Override
                    public void authorizationErrorInvalidRequest() {
                        callbackContext.error("");
                    }

                    @Override
                    public void authorizationErrorClientRegistrationFailed() {
                        callbackContext.error("");
                    }

                    @Override
                    public void authorizationErrorInvalidState() {
                        callbackContext.error("");
                    }

                    @Override
                    public void authorizationErrorInvalidGrant(int i) {
                        callbackContext.error("");
                    }

                    @Override
                    public void authorizationErrorNotAuthenticated() {
                        callbackContext.error("");
                    }

                    @Override
                    public void authorizationErrorInvalidScope() {
                        callbackContext.error("");
                    }

                    @Override
                    public void authorizationErrorNotAuthorized() {
                        callbackContext.error("");
                    }

                    @Override
                    public void authorizationErrorInvalidGrantType() {
                        callbackContext.error("");
                    }

                    @Override
                    public void authorizationErrorTooManyPinFailures() {
                        callbackContext.error("");
                    }

                    @Override
                    public void authorizationClientConfigFailed() {
                        callbackContext.error("");
                    }
                });
                return true;
            } catch (JSONException e) {
                callbackContext.error(e.getMessage());
            }
        }
        callbackContext.error("");
        return false;
    }
}
