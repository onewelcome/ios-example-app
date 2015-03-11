package com.onegini.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Arrays;

import android.util.Log;

public class HashUtil {

  private static final String TAG = HashUtil.class.getName();
  private static final String ALGORITHM_SHA_256 = "SHA-256";

  /**
   * Generate a sha256 hashed String.
   *
   * @param plain un-hashed String
   * @return hashed String.
   */
  public static String sha256(final byte[] plain) {
    return createHash(plain, ALGORITHM_SHA_256);
  }

  private static String createHash(final byte[] plain, final String algorithm) {
    try {
      final MessageDigest digest = MessageDigest.getInstance(algorithm);
      digest.update(plain);
      final byte[] messageDigest = digest.digest();

      final StringBuilder hexString = new StringBuilder();
      for (final byte aMessageDigest : messageDigest) {
        String h = Integer.toHexString(0xFF & aMessageDigest);
        while (h.length() < 2) {
          h = "0" + h;
        }
        hexString.append(h);
      }
      nullifyBytes(messageDigest);
      return hexString.toString();

    } catch (final NoSuchAlgorithmException e) {
      Log.e(TAG, e.getMessage());
      return "";
    }
  }

  public static void nullifyBytes(final byte[] bytes) {
    Arrays.fill(bytes, (byte) 0);
  }
}
