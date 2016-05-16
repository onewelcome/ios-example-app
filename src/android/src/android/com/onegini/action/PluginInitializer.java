package com.onegini.action;

import static com.onegini.OneginiConstants.KEYSTORE_HASH;

import org.apache.cordova.Config;

import android.app.Application;
import android.content.Context;
import com.onegini.OneginiCordovaPlugin;
import com.onegini.dialog.AcceptWithPinDialog;
import com.onegini.dialog.ConfirmationDialogSelectorHandler;
import com.onegini.dialog.CreatePinNativeDialogHandler;
import com.onegini.dialog.CreatePinNonNativeDialogHandler;
import com.onegini.dialog.CurrentPinNativeDialogHandler;
import com.onegini.dialog.CurrentPinNonNativeDialogHandler;
import com.onegini.dialog.FingerprintActivity;
import com.onegini.dialog.FingerprintDialog;
import com.onegini.dialog.PushAuthenticateWithFingerprintDialog;
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

    final int keystoreResourcePointer = client.getCordova().getActivity().getResources().getIdentifier("keystore", "raw", application.getPackageName());
    configModel.setCertificatePinningKeyStore(keystoreResourcePointer);
    configModel.setKeyStoreHash(KEYSTORE_HASH);

    final Context applicationContext = client.cordova.getActivity().getApplicationContext();
    final OneginiClient oneginiClient = OneginiClient.setupInstance(applicationContext, configModel);
    client.setOneginiClient(oneginiClient);

    final boolean shouldUseNativeScreens = configModel.useNativePinScreen();
    client.setShouldUseNativeScreens(shouldUseNativeScreens);
    setupDialogs(shouldUseNativeScreens, application.getApplicationContext());

    setupDialogs(shouldUseNativeScreens, application.getApplicationContext());
    setupURLHandler(oneginiClient, configModel);
    MessageResourceReader.setupInstance(applicationContext);

    configured = true;
  }

  private void setupDialogs(final boolean shouldUseNativeScreens, final Context context) {
    final OneginiClient client = OneginiClient.getInstance();

    if (shouldUseNativeScreens) {
      client.setCreatePinDialog(new CreatePinNativeDialogHandler(context));
      client.setCurrentPinDialog(new CurrentPinNativeDialogHandler(context));
    } else {
      client.setCreatePinDialog(new CreatePinNonNativeDialogHandler());
      client.setCurrentPinDialog(new CurrentPinNonNativeDialogHandler());
    }

    client.setConfirmationWithPinDialog(new AcceptWithPinDialog(context));
    client.setConfirmationDialogSelector(new ConfirmationDialogSelectorHandler(context));
    FingerprintActivity.setFingerprintAuthorizationFallbackHandler(client.setFingerprintDialog(new FingerprintDialog(context)));
    client.setConfirmationWithFingerprintDialog(new PushAuthenticateWithFingerprintDialog(context));
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
