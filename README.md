# ParseModeSetter for Televerse

![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white)
![Televerse](https://img.shields.io/badge/Televerse-🚀-blue)
![Version](https://img.shields.io/pub/v/parse_mode_setter)

Consistent Message Formatting with ParseModeSetter

## Overview

Streamline your Televerse bot development with `ParseModeSetter`, a Transformer
plugin that automates parse mode setting for various API methods. This plugin
ensures consistent message formatting without the need to manually specify the
parse mode each time. It simplifies you r code and saves you valuable time.

## Installation

1. Add the `parse_mode_setter` package to your project using Dart's package
   manager:

   ```bash
   dart pub add parse_mode_setter
   ```

## Usage

### 🧪 Example

Here's a code snippet demonstrating how to integrate `ParseModeSetter` with your
Televerse bot:

```dart
import 'dart:io';
import 'package:parse_mode_setter/parse_mode_setter.dart';
import 'package:televerse/televerse.dart';

final bot = Bot(Platform.environment["BOT_TOKEN"]!);

void main(List<String> args) {
  // Attach ParseModeSetter, setting the parse mode to HTML in this case.
  bot.use(ParseModeSetter(ParseMode.html));

  bot.command('start', (ctx) async {
    // Leverage HTML formatting within methods without worrying about parse mode.
    await ctx.reply(
      "Hello <b>World</b>\n\nThis is a <i>great story of the Detective Rajappan</i>."
      " I hope you've heard of Rajappan. Well, if you haven't, he's a"
      " <tg-spoiler>super detective.</tg- spoiler>",
    );
  });

  bot.start();
}
```

### ⚙️ Configuration

Customize the `ParseModeSetter` class using the following properties:

- `allowedMethods`: A list of API methods allowed to have their parse mode set.
  Defaults to:
  ```dart
  [
    APIMethod.sendMessage,
    APIMethod.copyMessage,
    APIMethod.sendPhoto,
    APIMethod.sendAudio,
    APIMethod.sendDocument,
    APIMethod.sendVideo,
    APIMethod.sendAnimation,
    APIMethod.sendVoice,
    APIMethod.sendPoll,
    APIMethod.editMessageText,
    APIMethod.editMessageCaption,
  ]
  ```
- `disallowedMethods`: A list of API methods that should not have their parse
  mode set. Defaults to an empty list.
- `setQuestionParseMode`: A boolean indicating whether to set the parse mode for
  poll questions. Defaults to `true`.
- `setExplanationParseMode`: A boolean indicating whether to set the parse mode
  for poll explanations. Defaults to `true`.

### Example Configuration

```dart
final parseModeSetter = ParseModeSetter(
  ParseMode.markdown,
  allowedMethods: [APIMethod.sendMessage, APIMethod.sendPhoto],
  disallowedMethods: [APIMethod.sendVoice],
  setQuestionParseMode: true,
  setExplanationParseMode: false,
);

bot.use(parseModeSetter);
```

In this configuration:

- The parse mode is set to Markdown for `sendMessage` and `sendPhoto` methods.
- The parse mode is explicitly not set for the `sendVoice` method.
- The parse mode is set for poll questions but not for poll explanations.

## Understanding Parse Mode

The Telegram Bot API supports basic formatting for messages, including bold,
italic, underline, strikethrough, spoiler text, block quotes, inline links, and
pre-formatted code. Telegram clients render these styles accordingly. You can
specify text entities directly or use markdown-style or HTML-style formatting.

## 🧑🏻‍💻 Contributing

We appreciate your interest in `ParseModeSetter`! If you find it helpful,
consider starring the repository. Feel free to report any issues or suggest
improvements on GitHub.

## Get Started with Televerse

For more information on Televerse, the Telegram Bot API library used in this
plugin,
[visit the official repository](https://github.com/HeySreelal/televerse).

**Thank you for using `ParseModeSetter`! We hope it simplifies your Televerse
bot development experience.**
