package com.onegini.helper;

import static com.onegini.dialogs.PinScreenActivity.SCREEN_MODE_CHANGE_PIN_CONFIRM_PIN;
import static com.onegini.dialogs.PinScreenActivity.SCREEN_MODE_CHANGE_PIN_CREATE_PIN;
import static com.onegini.dialogs.PinScreenActivity.SCREEN_MODE_LOGIN;
import static com.onegini.dialogs.PinScreenActivity.SCREEN_MODE_LOGIN_BEFORE_CHANGE_PIN;
import static com.onegini.dialogs.PinScreenActivity.SCREEN_MODE_REGISTRATION_CONFIRM_PIN;
import static com.onegini.dialogs.PinScreenActivity.SCREEN_MODE_REGISTRATION_CREATE_PIN;
import static com.onegini.model.MessageKey.CHANGE_PIN_HELP_MESSAGE;
import static com.onegini.model.MessageKey.CHANGE_PIN_HELP_TITLE;
import static com.onegini.model.MessageKey.CHANGE_PIN_INFO_LABEL;
import static com.onegini.model.MessageKey.CHANGE_PIN_KEYBOARD_TITLE;
import static com.onegini.model.MessageKey.CHANGE_PIN_SCREEN_TITLE;
import static com.onegini.model.MessageKey.CONFIRM_CHANGE_PIN_HELP_MESSAGE;
import static com.onegini.model.MessageKey.CONFIRM_CHANGE_PIN_HELP_TITLE;
import static com.onegini.model.MessageKey.CONFIRM_CHANGE_PIN_INFO_LABEL;
import static com.onegini.model.MessageKey.CONFIRM_CHANGE_PIN_KEYBOARD_TITLE;
import static com.onegini.model.MessageKey.CONFIRM_CHANGE_PIN_SCREEN_TITLE;
import static com.onegini.model.MessageKey.CONFIRM_PIN_HELP_MESSAGE;
import static com.onegini.model.MessageKey.CONFIRM_PIN_HELP_TITLE;
import static com.onegini.model.MessageKey.CONFIRM_PIN_INFO_LABEL;
import static com.onegini.model.MessageKey.CONFIRM_PIN_KEYBOARD_TITLE;
import static com.onegini.model.MessageKey.CONFIRM_PIN_SCREEN_TITLE;
import static com.onegini.model.MessageKey.CREATE_PIN_HELP_MESSAGE;
import static com.onegini.model.MessageKey.CREATE_PIN_HELP_TITLE;
import static com.onegini.model.MessageKey.CREATE_PIN_INFO_LABEL;
import static com.onegini.model.MessageKey.CREATE_PIN_KEYBOARD_TITLE;
import static com.onegini.model.MessageKey.CREATE_PIN_SCREEN_TITLE;
import static com.onegini.model.MessageKey.LOGIN_BEFORE_CHANGE_PIN_HELP_MESSAGE;
import static com.onegini.model.MessageKey.LOGIN_BEFORE_CHANGE_PIN_HELP_TITLE;
import static com.onegini.model.MessageKey.LOGIN_BEFORE_CHANGE_PIN_INFO_LABEL;
import static com.onegini.model.MessageKey.LOGIN_BEFORE_CHANGE_PIN_KEYBOARD_TITLE;
import static com.onegini.model.MessageKey.LOGIN_BEFORE_CHANGE_PIN_SCREEN_TITLE;
import static com.onegini.model.MessageKey.LOGIN_PIN_HELP_MESSAGE;
import static com.onegini.model.MessageKey.LOGIN_PIN_HELP_TITLE;
import static com.onegini.model.MessageKey.LOGIN_PIN_KEYBOARD_TITLE;
import static com.onegini.util.MessageResourceReader.getMessageForKey;

public class PinActivityMessageMapper {

  public static String getTitleForScreen(final int mode) {
    switch (mode) {
      case SCREEN_MODE_LOGIN_BEFORE_CHANGE_PIN:
        return getMessageForKey(LOGIN_BEFORE_CHANGE_PIN_SCREEN_TITLE.name());
      case SCREEN_MODE_REGISTRATION_CREATE_PIN:
        return getMessageForKey(CREATE_PIN_SCREEN_TITLE.name());
      case SCREEN_MODE_REGISTRATION_CONFIRM_PIN:
        return getMessageForKey(CONFIRM_PIN_SCREEN_TITLE.name());
      case SCREEN_MODE_CHANGE_PIN_CREATE_PIN:
        return getMessageForKey(CHANGE_PIN_SCREEN_TITLE.name());
      case SCREEN_MODE_CHANGE_PIN_CONFIRM_PIN:
        return getMessageForKey(CONFIRM_CHANGE_PIN_SCREEN_TITLE.name());
      case SCREEN_MODE_LOGIN:
      default:
        return "";
    }
  }

  public static String getMessageForPinLabel(final int mode) {
    switch (mode) {
      case SCREEN_MODE_LOGIN_BEFORE_CHANGE_PIN:
        return getMessageForKey(LOGIN_BEFORE_CHANGE_PIN_INFO_LABEL.name());
      case SCREEN_MODE_REGISTRATION_CREATE_PIN:
        return getMessageForKey(CREATE_PIN_INFO_LABEL.name());
      case SCREEN_MODE_REGISTRATION_CONFIRM_PIN:
        return getMessageForKey(CONFIRM_PIN_INFO_LABEL.name());
      case SCREEN_MODE_CHANGE_PIN_CREATE_PIN:
        return getMessageForKey(CHANGE_PIN_INFO_LABEL.name());
      case SCREEN_MODE_CHANGE_PIN_CONFIRM_PIN:
        return getMessageForKey(CONFIRM_CHANGE_PIN_INFO_LABEL.name());
      case SCREEN_MODE_LOGIN:
      default:
        return "";
    }
  }

  public static String getTitleForKeyboard(final int mode) {
    switch (mode) {
      case SCREEN_MODE_LOGIN:
        return getMessageForKey(LOGIN_PIN_KEYBOARD_TITLE.name());
      case SCREEN_MODE_LOGIN_BEFORE_CHANGE_PIN:
        return getMessageForKey(LOGIN_BEFORE_CHANGE_PIN_KEYBOARD_TITLE.name());
      case SCREEN_MODE_REGISTRATION_CREATE_PIN:
        return getMessageForKey(CREATE_PIN_KEYBOARD_TITLE.name());
      case SCREEN_MODE_REGISTRATION_CONFIRM_PIN:
        return getMessageForKey(CONFIRM_PIN_KEYBOARD_TITLE.name());
      case SCREEN_MODE_CHANGE_PIN_CREATE_PIN:
        return getMessageForKey(CHANGE_PIN_KEYBOARD_TITLE.name());
      case SCREEN_MODE_CHANGE_PIN_CONFIRM_PIN:
        return getMessageForKey(CONFIRM_CHANGE_PIN_KEYBOARD_TITLE.name());
      default:
        return "";
  }

  public static String getTitleForHelpsScreen(final int mode) {
    switch (mode) {
      case SCREEN_MODE_LOGIN:
        return getMessageForKey(LOGIN_PIN_HELP_TITLE.name());
      case SCREEN_MODE_LOGIN_BEFORE_CHANGE_PIN:
        return getMessageForKey(LOGIN_BEFORE_CHANGE_PIN_HELP_TITLE.name());
      case SCREEN_MODE_REGISTRATION_CREATE_PIN:
        return getMessageForKey(CREATE_PIN_HELP_TITLE.name());
      case SCREEN_MODE_REGISTRATION_CONFIRM_PIN:
        return getMessageForKey(CONFIRM_PIN_HELP_TITLE.name());
      case SCREEN_MODE_CHANGE_PIN_CREATE_PIN:
        return getMessageForKey(CHANGE_PIN_HELP_TITLE.name());
      case SCREEN_MODE_CHANGE_PIN_CONFIRM_PIN:
        return getMessageForKey(CONFIRM_CHANGE_PIN_HELP_TITLE.name());
      default:
        return "";
    }
  }

  public static String getMessageForHelpScreen(final int mode) {
    switch (mode) {
      case SCREEN_MODE_LOGIN:
        return getMessageForKey(LOGIN_PIN_HELP_MESSAGE.name());
      case SCREEN_MODE_LOGIN_BEFORE_CHANGE_PIN:
        return getMessageForKey(LOGIN_BEFORE_CHANGE_PIN_HELP_MESSAGE.name());
      case SCREEN_MODE_REGISTRATION_CREATE_PIN:
        return getMessageForKey(CREATE_PIN_HELP_MESSAGE.name());
      case SCREEN_MODE_REGISTRATION_CONFIRM_PIN:
        return getMessageForKey(CONFIRM_PIN_HELP_MESSAGE.name());
      case SCREEN_MODE_CHANGE_PIN_CREATE_PIN:
        return getMessageForKey(CHANGE_PIN_HELP_MESSAGE.name());
      case SCREEN_MODE_CHANGE_PIN_CONFIRM_PIN:
        return getMessageForKey(CONFIRM_CHANGE_PIN_HELP_MESSAGE.name());
      default:
        return "";
    }
  }
}
