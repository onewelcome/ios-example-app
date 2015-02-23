package com.onegini.actions;

import android.content.Context;

import com.google.gson.Gson;
import com.onegini.OneginiCordovaPlugin;
import com.onegini.mobile.sdk.android.library.OneginiClient;
import com.onegini.mobile.sdk.android.library.handlers.OneginiPinProvidedHandler;
import com.onegini.mobile.sdk.android.library.model.OneginiClientConfigModel;
import com.onegini.mobile.sdk.android.library.utils.dialogs.AlertInterface;
import com.onegini.mobile.sdk.android.library.utils.dialogs.ConfirmationDialogSelector;
import com.onegini.mobile.sdk.android.library.utils.dialogs.ConfirmationWithPin;
import com.onegini.mobile.sdk.android.library.utils.dialogs.ContextAwareDialogProvider;
import com.onegini.mobile.sdk.android.library.utils.dialogs.PinDialogInterface;
import com.onegini.model.ConfigModel;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class InitAction implements OneginiPluginAction {
    Gson gson = new Gson();

    @Override
    public boolean execute(JSONArray args, CallbackContext callbackContext, OneginiCordovaPlugin client) {
        if (args.length() == 2) {
            try {
                JSONObject configuration = args.getJSONObject(0);
                ContextAwareDialogProvider.setInstance(null);
                ContextAwareDialogProvider.getInstance().getPinDialog().setPinDialog(getPinDialImpl());
                ContextAwareDialogProvider.getInstance().getConfirmationDialog().setConfirmationDialogSelector(getConfirmationDialogSelectorImpl());
                ContextAwareDialogProvider.getInstance().getConfirmationWithPinDialog().setConfirmationWithPinDialog(getConfirmationWitkPinDialog());
                OneginiClientConfigModel configModel = gson.fromJson(configuration.toString(), ConfigModel.class);
                Context applicationContext = client.cordova.getActivity().getApplicationContext();
                OneginiClient oneginiClient = OneginiClient.setupInstance(applicationContext, configModel);
                client.setOneginiClient(oneginiClient);
                callbackContext.success();
                return true;
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
        callbackContext.error("Bad configuration");
        return false;
    }

    private ConfirmationWithPin getConfirmationWitkPinDialog() {
        return new ConfirmationWithPin() {
            @Override
            public void showConfirmation(String s, String s2, int i, int i2, ConfirmationWithPinHandler confirmationWithPinHandler) {

            }

            @Override
            public void setContext(Context context) {

            }
        };
    }

    private ConfirmationDialogSelector getConfirmationDialogSelectorImpl() {
        return new ConfirmationDialogSelector() {
            @Override
            public AlertInterface selectConfirmationDialog(String s) {
                return null;
            }

            @Override
            public void setContext(Context context) {

            }
        };
    }

    private PinDialogInterface getPinDialImpl() {
        return new PinDialogInterface() {
            @Override
            public void showDialog(OneginiPinProvidedHandler oneginiPinProvidedHandler, String s) {

            }

            @Override
            public void setContext(Context context) {

            }

            @Override
            public void pinBlackListed(String s) {

            }

            @Override
            public void pinShouldNotBeASequence(String s) {

            }

            @Override
            public void pinShouldNotUseSimilarDigits(String s, int i) {

            }

            @Override
            public void pinTooShort(String s) {

            }

            @Override
            public void pinsNotEqual(String s) {

            }
        };
    }
}
