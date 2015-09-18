package com.onegini.model;

import java.lang.RuntimeException;

import org.apache.cordova.CordovaPreferences;

import android.os.Build;
import com.google.gson.annotations.SerializedName;
import com.onegini.mobile.sdk.android.library.model.OneginiClientConfigModel;
import com.onegini.exception.PluginConfigException;

public class ConfigModel implements OneginiClientConfigModel {

  public static ConfigModel from(final CordovaPreferences preferences) {
    final ConfigModel config = new ConfigModel();

    config.appIdentifier = getStringFromPreferences(preferences, "kOGAppIdentifier");
    config.appScheme = getStringFromPreferences(preferences, "kOGAppScheme");
    config.appVersion = getStringFromPreferences(preferences, "kOGAppVersion");
    config.baseUrl = getStringFromPreferences(preferences, "kOGAppBaseURL");
    config.resourceBaseUrl = getStringFromPreferences(preferences, "kOGResourceBaseURL");

    config.maxPinFailures = preferences.getInteger("kOGMaxPinFailures", 3);
    config.useEmbeddedWebview = preferences.getBoolean("kOGUseEmbeddedWebview", true);
    config.shouldGetIdToken = preferences.getBoolean("kOGShouldGetIdToken", false);

    return config;
  }

  private static String getStringFromPreferences(final CordovaPreferences preferences, final String key) throws PluginConfigException {
    final String value = preferences.getString(key, null);
    if (value == null) {
      throw new PluginConfigException("Missing property in config.xml file: "+key);
    }
    return value;
  }

  private String appPlatform = "android";
  private String appIdentifier;
  private String appScheme;
  private String appVersion;
  private String baseUrl;
  private String resourceBaseUrl;

  private int maxPinFailures;
  private boolean shouldGetIdToken;
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

  public boolean useEmbeddedWebview() {
    return useEmbeddedWebview;
  }
}
