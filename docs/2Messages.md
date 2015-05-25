# 2. How to change in-app messages

All in-app messages that can be customized can be found in `/src/generic/messages/messages.properties` file. Due to a fact that, depending on the configuration, application can show native screens the `messages.properties` file is loaded by both the top level HTML5 app and the plugin itself.

The file contains messages in "KEY=VALUE" format, with one line per message. Lines starting with `#` are treated as comments.