package com.onegini.actions;

import static com.onegini.OneginiConstants.KEYSTORE_HASH;
import static com.onegini.OneginiConstants.SHOULD_SHOW_NATIVE_SCREENS_CONFIG_PROPERTY;

import org.apache.cordova.Config;
import org.apache.cordova.CordovaPreferences;

import android.app.Application;
import android.content.Context;
import com.onegini.OneginiCordovaPlugin;
import com.onegini.dialogs.ConfirmationDialogSelectorHandler;
import com.onegini.dialogs.CreatePinNativeDialogHandler;
import com.onegini.dialogs.CreatePinNonNativeDialogHandler;
import com.onegini.dialogs.CurrentPinNativeDialogHandler;
import com.onegini.dialogs.CurrentPinNonNativeDialogHandler;
import com.onegini.mobile.sdk.android.library.OneginiClient;
import com.onegini.mobile.sdk.android.library.utils.dialogs.DialogProvider;
import com.onegini.model.ConfigModel;
import com.onegini.util.JSONResourceReader;
import com.onegini.util.MessageResourceReader;

public class PluginInitializer {

  private static boolean configured;

  public static boolean isConfigured() {
    return configured;
  }

  public void setup(final OneginiCordovaPlugin client) {
    final Application application = client.getCordova().getActivity().getApplication();

    final boolean shouldUseNativeScreen = setupUseOfNativeScreens(client);
    setupDialogs(shouldUseNativeScreen, application.getApplicationContext());


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
    MessageResourceReader.setupInstance(applicationContext);

    configured = true;
  }

  private boolean setupUseOfNativeScreens(final OneginiCordovaPlugin client) {
    final CordovaPreferences preferences = Config.getPreferences();
    final boolean shouldUseNativeScreens = preferences.getBoolean(SHOULD_SHOW_NATIVE_SCREENS_CONFIG_PROPERTY, true);
    client.setShouldUseNativeScreens(shouldUseNativeScreens);
    return shouldUseNativeScreens;
  }

  private void setupDialogs(final boolean shouldUseNativeScreens, final Context context) {
    DialogProvider.setInstance();
    if (shouldUseNativeScreens) {
      DialogProvider.getInstance().setOneginiCreatePinDialog(new CreatePinNativeDialogHandler(context));
      DialogProvider.getInstance().setOneginiCurrentPinDialog(new CurrentPinNativeDialogHandler(context));
    }
    else {
      DialogProvider.getInstance().setOneginiCreatePinDialog(new CreatePinNonNativeDialogHandler());
      DialogProvider.getInstance().setOneginiCurrentPinDialog(new CurrentPinNonNativeDialogHandler());
    }
    DialogProvider.getInstance().getConfirmationDialog()
        .setConfirmationDialogSelector(new ConfirmationDialogSelectorHandler());
  }

  private ConfigModel retrieveConfiguration(final OneginiCordovaPlugin client, final Application application) {
    final int configurationPointer = client.getCordova().getActivity().getResources()
        .getIdentifier("config", "raw", application.getPackageName());
    final JSONResourceReader jsonResourceReader = new JSONResourceReader();
    final String configString = jsonResourceReader.parse(client.getCordova().getActivity().getResources(), configurationPointer);
    return jsonResourceReader.map(ConfigModel.class, configString);
  }

  private void setupURLHandler(final OneginiClient client, final ConfigModel configModel) {
    if (configModel.useEmbeddedWebview()) {
      client.setOneginiURLHandler(new URLHandler());
    }
  }

}
