package com.onegini.action;

import static com.onegini.OneginiConstants.KEYSTORE_HASH;

import org.apache.cordova.Config;

import android.app.Application;
import android.content.Context;
import com.onegini.OneginiCordovaPlugin;
import com.onegini.dialog.CreatePinNativeDialogHandler;
import com.onegini.dialog.CreatePinNonNativeDialogHandler;
import com.onegini.dialog.CurrentPinNativeDialogHandler;
import com.onegini.dialog.CurrentPinNonNativeDialogHandler;
import com.onegini.mobile.sdk.android.library.OneginiClient;
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

    // @todo we need to decide if non-native PIN screen should be maintained
    final boolean shouldUseNativeScreens = true;
    client.setShouldUseNativeScreens(shouldUseNativeScreens);

    final int keystoreResourcePointer = client.getCordova().getActivity().getResources()
        .getIdentifier("keystore", "raw", application.getPackageName());
    configModel.setCertificatePinningKeyStore(keystoreResourcePointer);
    configModel.setKeyStoreHash(KEYSTORE_HASH);

    final Context applicationContext = client.cordova.getActivity().getApplicationContext();
    final OneginiClient oneginiClient = OneginiClient.setupInstance(applicationContext, configModel);
    setupDialogs(shouldUseNativeScreens, oneginiClient, applicationContext);

    client.setOneginiClient(oneginiClient);

    setupURLHandler(oneginiClient, configModel);
    MessageResourceReader.setupInstance(applicationContext);

    configured = true;
  }

  private void setupDialogs(final boolean shouldUseNativeScreens, final OneginiClient oneginiClient, final Context context) {
    if (shouldUseNativeScreens) {
      oneginiClient.setCreatePinDialog(new CreatePinNativeDialogHandler(context));
      oneginiClient.setCurrentPinDialog(new CurrentPinNativeDialogHandler(context));
    } else {
      oneginiClient.setCreatePinDialog(new CreatePinNonNativeDialogHandler());
      oneginiClient.setCurrentPinDialog(new CurrentPinNonNativeDialogHandler());
    }
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
