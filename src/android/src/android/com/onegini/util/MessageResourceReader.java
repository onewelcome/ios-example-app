package com.onegini.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import android.content.Context;

public class MessageResourceReader {

  private static MessageResourceReader instance;

  private Properties messages;

  public static void setupInstance(final Context context) {
    if (instance == null) {
      instance = new MessageResourceReader(context);
    }
  }

  public static MessageResourceReader getInstance() {
    if (instance == null) {
      throw new RuntimeException("Message resources not initialized.");
    }
    return instance;
  }

  public static String getMessageForKey(final String key) {
    return getInstance().getString(key);
  }

  private MessageResourceReader(final Context context) {
    final int messagesPointer = context.getResources().getIdentifier("messages", "raw", context.getPackageName());
    final InputStream inputStream = context.getResources().openRawResource(messagesPointer);
    this.messages = new Properties();
    try {
      messages.load(inputStream);
      inputStream.close();
    }
    catch (final IOException e) {
      throw new RuntimeException();
    }
  }

  public String getString(final String key) {
    return messages.getProperty(key);
  }
}
