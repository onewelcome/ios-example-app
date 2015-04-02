package com.onegini.actions;

import static com.onegini.OneginiConstants.KEYSTORE_HASH;
import static com.onegini.OneginiConstants.SHOULD_SHOW_NATIVE_SCREENS_CONFIG_PROPERTY;

import org.apache.cordova.Config;
import org.apache.cordova.CordovaPreferences;

import android.app.Application;
import android.content.Context;
import com.onegini.OneginiCordovaPlugin;
import com.onegini.dialogs.ConfirmationDialogSelectorHandler;
import com.onegini.dialogs.CreatePinDialogHandler;
import com.onegini.dialogs.CurrentPinDialogHandler;
import com.onegini.mobile.sdk.android.library.OneginiClient;
import com.onegini.mobile.sdk.android.library.utils.dialogs.DialogProvider;
import com.onegini.model.ConfigModel;
import com.onegini.util.JSONResourceReader;

public class PluginInitializer {

  private static boolean configured;

  public static boolean isConfigured() {
    return configured;
  }

  public void setup(final OneginiCordovaPlugin client) {
    setupDialogs();

    final Application application = client.getCordova().getActivity().getApplication();

    final ConfigModel configModel = retrieveConfiguration(client, application);
    if (configModel == null) {
      configured = false;
      return;
    }

    final int keystoreResourcePointer = client.getCordova().getActivity().getResources()
        .getIdentifier("keystore", "raw", application.getPackageName());
    configModel.setCertificatePinningKeyStore(keystoreResourcePointer);
    configModel.setKeyStoreHash(KEYSTORE_HASH);

    final Context applicationContext = client.cordova.getActivity().getApplicationContext();
    final OneginiClient oneginiClient = OneginiClient.setupInstance(applicationContext, configModel);
    client.setOneginiClient(oneginiClient);

    setupURLHandler(oneginiClient, configModel);
    setupUseOfNativeScreens();

    configured = true;
  }

  private void setupUseOfNativeScreens() {
    final CordovaPreferences preferences = Config.getPreferences();
    final boolean shouldUseNativeScreens = preferences.getBoolean(SHOULD_SHOW_NATIVE_SCREENS_CONFIG_PROPERTY, true);
    OneginiCordovaPlugin.setShouldShowNativeScreens(shouldUseNativeScreens);
  }

  private ConfigModel retrieveConfiguration(final OneginiCordovaPlugin client, final Application application) {
    final int configurationPointer = client.getCordova().getActivity().getResources()
        .getIdentifier("config", "raw", application.getPackageName());
    final JSONResourceReader jsonResourceReader = new JSONResourceReader();
    final String configString = jsonResourceReader.parse(client.getCordova().getActivity().getResources(), configurationPointer);
    return jsonResourceReader.map(ConfigModel.class, configString);
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
