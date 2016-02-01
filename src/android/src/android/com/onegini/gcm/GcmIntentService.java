package com.onegini.gcm;

import android.app.IntentService;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import com.google.android.gms.gcm.GoogleCloudMessaging;
import com.onegini.dialog.AcceptWithPinDialog;
import com.onegini.dialog.ConfirmationDialogSelectorHandler;
import com.onegini.dialog.CreatePinNativeDialogHandler;
import com.onegini.dialog.CurrentPinNativeDialogHandler;
import com.onegini.mobile.sdk.android.library.OneginiClient;

public class GcmIntentService extends IntentService {

  static final String TAG = "Notifications";

  public GcmIntentService() {
    super("GcmIntentService");
  }

  @Override
  public void onCreate() {
    super.onCreate();
  }

  @Override
  protected void onHandleIntent(final Intent intent) {
    final Bundle extras = intent.getExtras();
    final GoogleCloudMessaging gcm = GoogleCloudMessaging.getInstance(this);
    final String messageType = gcm.getMessageType(intent);

    if (!extras.isEmpty()) {
      if (GoogleCloudMessaging.MESSAGE_TYPE_SEND_ERROR.equals(messageType)) {
        Log.i(TAG, "Error");
      } else if (GoogleCloudMessaging.MESSAGE_TYPE_DELETED.equals(messageType)) {
        Log.i(TAG, "Deleted");
        // If it's a regular GCM message, do some work.
      } else if (GoogleCloudMessaging.MESSAGE_TYPE_MESSAGE.equals(messageType)) {
        Log.i(TAG, "Received: " + extras.toString());
      }
      getOneginiClient().handlePushNotification(extras);
    }
    // Release the wake lock provided by the WakefulBroadcastReceiver.
    GcmBroadcastReceiver.completeWakefulIntent(intent);
  }

  private OneginiClient getOneginiClient() {
    if (OneginiClient.getInstance() == null) {
      OneginiClient.setupInstance(getApplicationContext());

      final OneginiClient client = OneginiClient.getInstance();
      client.setCreatePinDialog(new CreatePinNativeDialogHandler(this));
      client.setCurrentPinDialog(new CurrentPinNativeDialogHandler(this));
      client.setConfirmationWithPinDialog(new AcceptWithPinDialog(this));
      client.setConfirmationDialogSelector(new ConfirmationDialogSelectorHandler(this));
      return client;
    }
    return OneginiClient.getInstance();
  }

}
