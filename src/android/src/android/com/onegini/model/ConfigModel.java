package com.onegini.model;

import android.os.Build;
import com.google.gson.annotations.SerializedName;
import com.onegini.mobile.sdk.android.library.model.OneginiClientConfigModel;

public class ConfigModel implements OneginiClientConfigModel {
  @SerializedName("shouldGetIdToken")
  private boolean shouldGetIdToken;
  @SerializedName("kOGAppIdentifier")
  private String appIdentifier;
  @SerializedName("kOGAppPlatform")
  private String appPlatform;
  @SerializedName("kOGAppScheme")
  private String appScheme;
  @SerializedName("kOGAppVersion")
  private String appVersion;
  @SerializedName("kAppBaseURL")
  private String baseUrl;
  @SerializedName("kOGMaxPinFailures")
  private int maxPinFailures;
  @SerializedName("kOGResourceBaseURL")
  private String resourceBaseUrl;
  @SerializedName("kOGShouldConfirmNewPin")
  private boolean shouldConfirmNewPin;
  @SerializedName("kOGShouldDirectlyShowPushMessage")
  private boolean shouldDirectlyShowPushMessage;

  @SerializedName("kOGUseEmbeddedWebview")
  private boolean useEmbeddedWebview;

  private int certificatePinningKeyStore;
  private String keyStoreHash;

  @Override
  public String getAppIdentifier() {
    return appIdentifier;
  }

  @Override
  public String getAppPlatform() {
    return appPlatform;
  }

  @Override
  public String getAppScheme() {
    return appScheme;
  }

  @Override
  public String getAppVersion() {
    return appVersion;
  }

  @Override
  public String getBaseUrl() {
    return baseUrl;
  }

  @Override
  public int getMaxPinFailures() {
    return maxPinFailures;
  }

  @Override
  public String getResourceBaseUrl() {
    return resourceBaseUrl;
  }

  @Override
  public boolean shouldConfirmNewPin() {
    return shouldConfirmNewPin;
  }

  @Override
  public boolean shouldDirectlyShowPushMessage() {
    return shouldDirectlyShowPushMessage;
  }

  @Override
  public int getCertificatePinningKeyStore() {
    return certificatePinningKeyStore;
  }

  public void setCertificatePinningKeyStore(int certificatePinningKeyStore) {
    this.certificatePinningKeyStore = certificatePinningKeyStore;
  }

  @Override
  public String getKeyStoreHash() {
    return keyStoreHash;
  }

  public void setKeyStoreHash(String keyStoreHash) {
    this.keyStoreHash = keyStoreHash;
  }

  @Override
  public String getDeviceName() {
    return Build.BRAND + " " + Build.MODEL;
  }

  @Override
  public boolean shouldGetIdToken() {
    return shouldGetIdToken;
  }

  @Override
  public boolean shouldStoreCookies() {
    return true;
  }

  @Override
  public int getHttpClientTimeout() {
    return 0;
  }

  @Override
  public boolean debugDetectionEnabled() {
    return false;
  }

  public boolean useEmbeddedWebview() {
    return useEmbeddedWebview;
  }

  @Override
  public String toString() {
    return "ConfigModel{" +
        "  appIdentifier='" + appIdentifier + "'" +
        ", appPlatform='" + appPlatform + "'" +
        ", appScheme='" + appScheme + "'" +
        ", appVersion='" + appVersion + "'" +
        ", baseURL='" + baseUrl + "'" +
        ", confirmNewPin='" + shouldConfirmNewPin + "'" +
        ", directlyShowPushMessage='" + shouldDirectlyShowPushMessage + "'" +
        ", maxPinFailures='" + maxPinFailures + "'" +
        ", resourceBaseURL='" + resourceBaseUrl + "'" +
        ", keyStoreHash='" + getKeyStoreHash() + "'" +
        ", idTokenRequested='" + shouldGetIdToken + "'" +
        "}";
  }
}
