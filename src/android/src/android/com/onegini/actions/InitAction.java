package com.onegini.actions;

import static com.onegini.OneginiConstants.KEYSTORE_HASH;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Application;
import android.content.Context;
import com.google.gson.Gson;
import com.onegini.OneginiCordovaPlugin;
import com.onegini.mobile.sdk.android.library.OneginiClient;
import com.onegini.mobile.sdk.android.library.handlers.OneginiPinProvidedHandler;
import com.onegini.mobile.sdk.android.library.utils.dialogs.AlertInterface;
import com.onegini.mobile.sdk.android.library.utils.dialogs.ConfirmationDialogSelector;
import com.onegini.mobile.sdk.android.library.utils.dialogs.DialogProvider;
import com.onegini.mobile.sdk.android.library.utils.dialogs.OneginiCreatePinDialog;
import com.onegini.mobile.sdk.android.library.utils.dialogs.OneginiCurrentPinDialog;
import com.onegini.model.ConfigModel;

public class InitAction implements OneginiPluginAction {
  Gson gson = new Gson();

  @Override
  public boolean execute(final JSONArray args, final CallbackContext callbackContext,
                         final OneginiCordovaPlugin client) {
    setupDialogs();
    final boolean isConfigured = setupConfiguration(args, client);
    if (isConfigured) {
      callbackContext.success();
    }
    else {
      callbackContext.error("Failed to initialize plugin, wrong or missing configuration.");
    }

    return isConfigured;
  }

  private boolean setupConfiguration(final JSONArray args, final OneginiCordovaPlugin client) {
    try {
      final JSONObject configuration = args.getJSONObject(0);
      final ConfigModel configModel = gson.fromJson(configuration.toString(), ConfigModel.class);
      final Application application = client.getCordova().getActivity().getApplication();

      final int keystoreResourcePointer = client.getCordova().getActivity().getResources()
          .getIdentifier("keystore", "raw", application.getPackageName());
      configModel.setCertificatePinningKeyStore(keystoreResourcePointer);
      configModel.setKeyStoreHash(KEYSTORE_HASH);

      final Context applicationContext = client.cordova.getActivity().getApplicationContext();
      final OneginiClient oneginiClient = OneginiClient.setupInstance(applicationContext, configModel);
      client.setOneginiClient(oneginiClient);
      return true;
    } catch (JSONException e) {
      e.printStackTrace();
      return false;
    }
  }

  private void setupDialogs() {
    DialogProvider.setInstance();
    DialogProvider.getInstance().setOneginiCreatePinDialog(getOneginiCreatePinDialog());
    DialogProvider.getInstance().setOneginiCurrentPinDialog(getOneginiCurrentPinDialog());
    DialogProvider.getInstance().getConfirmationDialog()
        .setConfirmationDialogSelector(getConfirmationDialogSelectorImpl());
  }

  private OneginiCurrentPinDialog getOneginiCurrentPinDialog() {
    return new OneginiCurrentPinDialog() {
      @Override
      public void getCurrentPin(final OneginiPinProvidedHandler oneginiPinProvidedHandler) {

      }
    };
  }

  private OneginiCreatePinDialog getOneginiCreatePinDialog() {
    return new OneginiCreatePinDialog() {
      @Override
      public void createPin(final OneginiPinProvidedHandler oneginiPinProvidedHandler) {

      }

      @Override
      public void pinBlackListed() {

      }

      @Override
      public void pinShouldNotBeASequence() {

      }

      @Override
      public void pinShouldNotUseSimilarDigits(final int maxSimilar) {

      }

      @Override
      public void pinTooShort() {

      }
    };
  }

  private ConfirmationDialogSelector getConfirmationDialogSelectorImpl() {
    return new ConfirmationDialogSelector() {
      @Override
      public AlertInterface selectConfirmationDialog(final String s) {
        return null;
      }

      @Override
      public void setContext(final Context context) {

      }
    };
  }

}
