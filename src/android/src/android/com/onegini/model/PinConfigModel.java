package com.onegini.model;

import com.google.gson.annotations.SerializedName;

public class PinConfigModel {

  @SerializedName("pinForegroundColor")
  private String foregroundColor;
  @SerializedName("pinBackgroundColor")
  private String backgroundColor;
  @SerializedName("pinLogoImage")
  private String logoImage;
  @SerializedName("pinKeyColor")
  private String keyColor; // currently not used in Android
  @SerializedName("pinKeyNormalStateImage")
  private String keyNormalStateImage;
  @SerializedName("pinKeyHighlightedStateImage")
  private String keyHighlightedStateImage;
  @SerializedName("pinDeleteKeyNormalStateImage")
  private String deleteKeyNormalStateImage;
  @SerializedName("pinDeleteKeyHighlightedStateImage")
  private String deleteKeyHighlightedStateImage;

  public String getDeleteKeyHighlightedStateImage() {
    return deleteKeyHighlightedStateImage;
  }

  public String getForegroundColor() {
    return foregroundColor;
  }

  public String getBackgroundColor() {
    return backgroundColor;
  }

  public String getLogoImage() {
    return logoImage;
  }

  public String getKeyColor() {
    return keyColor;
  }

  public String getKeyNormalStateImage() {
    return keyNormalStateImage;
  }

  public String getKeyHighlightedStateImage() {
    return keyHighlightedStateImage;
  }

  public String getDeleteKeyNormalStateImage() {
    return deleteKeyNormalStateImage;
  }
}
