package com.onegini.action;

import static com.onegini.OneginiConstants.KEYSTORE_HASH;

import org.apache.cordova.Config;

import android.app.Application;
import android.content.Context;
import com.onegini.OneginiCordovaPlugin;
import com.onegini.dialog.ConfirmationDialogSelectorHandler;
import com.onegini.dialog.CreatePinNativeDialogHandler;
import com.onegini.dialog.CurrentPinNativeDialogHandler;
import com.onegini.mobile.sdk.android.library.OneginiClient;
import com.onegini.mobile.sdk.android.library.utils.dialogs.DialogProvider;
import com.onegini.model.ConfigModel;
import com.onegini.util.MessageResourceReader;

public class PluginInitializer {

  private static boolean configured;

  public static boolean isConfigured() {
    return configured;
  }

  public void setup(final OneginiCordovaPlugin client) {
    final Application application = client.getCordova().getActivity().getApplication();

    final ConfigModel configModel = retrieveConfiguration();
    if (configModel == null) {
      return;
    }

    setupDialogs(application.getApplicationContext());

    final int keystoreResourcePointer = client.getCordova().getActivity().getResources().getIdentifier("keystore", "raw", application.getPackageName());
    configModel.setCertificatePinningKeyStore(keystoreResourcePointer);
    configModel.setKeyStoreHash(KEYSTORE_HASH);

    final Context applicationContext = client.cordova.getActivity().getApplicationContext();
    final OneginiClient oneginiClient = OneginiClient.setupInstance(applicationContext, configModel);
    client.setOneginiClient(oneginiClient);

    setupURLHandler(oneginiClient, configModel);
    MessageResourceReader.setupInstance(applicationContext);

    configured = true;
  }

  private void setupDialogs(final Context context) {
    DialogProvider.setInstance();
    DialogProvider.getInstance().setOneginiCreatePinDialog(new CreatePinNativeDialogHandler(context));
    DialogProvider.getInstance().setOneginiCurrentPinDialog(new CurrentPinNativeDialogHandler(context));
    DialogProvider.getInstance().getConfirmationDialog().setConfirmationDialogSelector(new ConfirmationDialogSelectorHandler());
  }

  private ConfigModel retrieveConfiguration() {
    return ConfigModel.from(Config.getPreferences());
  }

  private void setupURLHandler(final OneginiClient client, final ConfigModel configModel) {
    if (configModel.useEmbeddedWebview()) {
      client.setOneginiURLHandler(new URLHandler());
    }
  }

}
