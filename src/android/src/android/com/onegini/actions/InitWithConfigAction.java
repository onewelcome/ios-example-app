package com.onegini.actions;

import static com.onegini.OneginiConstants.INIT_WITH_CONFIG_ACTION;
import static com.onegini.OneginiConstants.KEYSTORE_HASH;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Application;
import android.content.Context;
import com.google.gson.Gson;
import com.onegini.OneginiCordovaPlugin;
import com.onegini.dialogs.ConfirmationDialogSelectorHandler;
import com.onegini.dialogs.CreatePinDialogHandler;
import com.onegini.dialogs.CurrentPinDialogHandler;
import com.onegini.mobile.sdk.android.library.OneginiClient;
import com.onegini.mobile.sdk.android.library.utils.dialogs.DialogProvider;
import com.onegini.model.ConfigModel;

public class InitWithConfigAction implements OneginiPluginAction {

  private static boolean isConfigured;

  private Gson gson;

  public InitWithConfigAction() {
    gson = new Gson();
  }

  @Override
  public void execute(final JSONArray args, final CallbackContext callbackContext,
                      final OneginiCordovaPlugin client) {
    if (isConfigured) {
      return;
    }
    
    setupDialogs();
    isConfigured = setupConfiguration(args, client);
    if (isConfigured) {
      callbackContext.success(INIT_WITH_CONFIG_ACTION);
    }
    else {
      callbackContext.error("Failed to initialize plugin, wrong or missing configuration.");
    }
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

      setupURLHandler(oneginiClient, configModel);

      return true;
    } catch (JSONException e) {
      e.printStackTrace();
      return false;
    }
  }

  private void setupDialogs() {
    DialogProvider.setInstance();
    DialogProvider.getInstance().setOneginiCreatePinDialog(new CreatePinDialogHandler());
    DialogProvider.getInstance().setOneginiCurrentPinDialog(new CurrentPinDialogHandler());
    DialogProvider.getInstance().getConfirmationDialog()
        .setConfirmationDialogSelector(new ConfirmationDialogSelectorHandler());
  }

  private void setupURLHandler(final OneginiClient client, final ConfigModel configModel) {
    if (configModel.useEmbeddedWebview()) {
      client.setOneginiURLHandler(new URLHandler());
    }
  }
}
