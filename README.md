# ParseModeSetter Plugin for Televerse

![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white)
![Televerse](https://img.shields.io/badge/Televerse-🚀-blue)
![Version](https://img.shields.io/badge/version-1.0.0-green)

**Consistent Message Formatting with ParseModeSetter Plugin**

## Overview

Streamline your Televerse bot development with `ParseModeSetterPlugin`, a transformer plugin that automates parse mode setting for various API methods. This plugin ensures consistent message formatting without the need to manually specify the parse mode each time. It simplifies your code and saves you valuable time by automatically applying your preferred text formatting across all supported Telegram Bot API methods.

## Features

✨ **Automatic Parse Mode Setting** - Set parse mode once, apply everywhere  
🎯 **Method Filtering** - Choose which API methods should have parse mode applied  
📊 **Poll Support** - Separate controls for poll questions and explanations  
🔧 **Highly Configurable** - Fine-tune behavior to match your needs  
🚀 **Easy Integration** - Simple plugin installation with Televerse's new plugin system  

## Installation

The `ParseModeSetterPlugin` is included with Televerse. No additional installation required!

```dart
import 'package:televerse/televerse.dart';
```

## Usage

### 🧪 Basic Example

Here's a code snippet demonstrating how to integrate `ParseModeSetterPlugin` with your Televerse bot:

```dart
import 'dart:io';
import 'package:televerse/televerse.dart';

void main() async {
  final bot = Bot<Context>(Platform.environment["BOT_TOKEN"]!);

  // Install ParseModeSetter plugin with HTML formatting
  bot.plugin(ParseModeSetterPlugin<Context>(
    parseMode: ParseMode.html,
  ));

  bot.command('start', (ctx) async {
    // Leverage HTML formatting without worrying about parse mode
    await ctx.reply(
      "Hello <b>World</b>\n\n"
      "This is a <i>great story of Detective Rajappan</i>. "
      "I hope you've heard of Rajappan. Well, if you haven't, he's a "
      "<tg-spoiler>super detective.</tg-spoiler>",
    );
  });

  bot.command('markdown', (ctx) async {
    // This will also use HTML parse mode automatically
    await ctx.replyWithPhoto(
      InputFile.fromUrl('https://example.com/photo.jpg'),
      caption: 'A <b>beautiful</b> photo with <i>formatted</i> caption!',
    );
  });

  await bot.start();
}
```

### ⚙️ Advanced Configuration

Customize the `ParseModeSetterPlugin` using the following properties:

```dart
bot.plugin(ParseModeSetterPlugin<Context>(
  parseMode: ParseMode.markdownV2,
  
  // Specify which methods should have parse mode set
  allowedMethods: [
    APIMethod.sendMessage,
    APIMethod.sendPhoto,
    APIMethod.sendVideo,
    APIMethod.editMessageText,
    APIMethod.editMessageCaption,
  ],
  
  // Exclude specific methods from having parse mode set
  disallowedMethods: [
    APIMethod.sendVoice,
    APIMethod.sendSticker,
  ],
  
  // Control poll formatting
  setQuestionParseMode: true,     // Format poll questions
  setExplanationParseMode: false, // Don't format poll explanations
));
```

### 📋 Default Configuration

By default, `ParseModeSetterPlugin` applies parse mode to these API methods:

- `APIMethod.sendMessage`
- `APIMethod.copyMessage`
- `APIMethod.sendPhoto`
- `APIMethod.sendAudio`
- `APIMethod.sendDocument`
- `APIMethod.sendVideo`
- `APIMethod.sendAnimation`
- `APIMethod.sendVoice`
- `APIMethod.sendPoll`
- `APIMethod.editMessageText`
- `APIMethod.editMessageCaption`
- `APIMethod.editMessageMedia`
- `APIMethod.answerInlineQuery`
- `APIMethod.sendMediaGroup`

### 🎯 Multiple Parse Mode Scenarios

You can even install multiple parse mode setters for different scenarios:

```dart
// Global HTML formatting for most messages
bot.plugin(ParseModeSetterPlugin<Context>(
  parseMode: ParseMode.html,
  disallowedMethods: [APIMethod.sendPoll], // Exclude polls
));

// Separate Markdown formatting specifically for polls
bot.plugin(ParseModeSetterPlugin<Context>(
  parseMode: ParseMode.markdownV2,
  allowedMethods: [APIMethod.sendPoll], // Only polls
  setQuestionParseMode: true,
  setExplanationParseMode: true,
));
```

### 🔧 Custom Context Integration

The plugin works seamlessly with custom context types:

```dart
class MyContext extends Context {
  MyContext(super.update, super.api, super.me);
  
  // Your custom context methods
  String get userName => from?.firstName ?? 'Unknown';
}

void main() async {
  final bot = Bot<MyContext>(
    'YOUR_BOT_TOKEN',
    contextFactory: MyContext.new,
  );

  // Plugin works with any context type
  bot.plugin(ParseModeSetterPlugin<MyContext>(
    parseMode: ParseMode.html,
  ));

  bot.command('greet', (MyContext ctx) async {
    await ctx.reply('Hello <b>${ctx.userName}</b>!');
  });

  await bot.start();
}
```

## Configuration Options

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `parseMode` | `ParseMode` | **Required** | The parse mode to apply (HTML, Markdown, MarkdownV2) |
| `allowedMethods` | `List<APIMethod>` | All supported methods | API methods that should have parse mode applied |
| `disallowedMethods` | `List<APIMethod>` | `[]` | API methods that should NOT have parse mode applied |
| `setQuestionParseMode` | `bool` | `true` | Whether to apply parse mode to poll questions |
| `setExplanationParseMode` | `bool` | `true` | Whether to apply parse mode to poll explanations |

## Understanding Parse Mode

The Telegram Bot API supports rich text formatting including:

### HTML Style (`ParseMode.html`)
```html
<b>bold</b>
<i>italic</i>
<u>underline</u>
<s>strikethrough</s>
<tg-spoiler>spoiler</tg-spoiler>
<code>monospace</code>
<pre>pre-formatted</pre>
<a href="https://example.com">link</a>
```

### MarkdownV2 Style (`ParseMode.markdownV2`)
```markdown
*bold*
_italic_
__underline__
~strikethrough~
||spoiler||
`monospace`
```preformatted```
[link](https://example.com)
```

### Markdown Style (`ParseMode.markdown`) - Legacy
```markdown
*bold*
_italic_
`monospace`
```preformatted```
[link](https://example.com)
```

## Advanced Use Cases

### Conditional Parse Mode Setting

```dart
// Create a custom plugin that sets parse mode based on chat type
class ConditionalParseModePlugin<CTX extends Context> 
    implements Plugin<CTX> {
  
  @override
  String get name => 'conditional-parse-mode';
  
  @override
  void install(Bot<CTX> bot) {
    // HTML for private chats
    bot.filter(
      (ctx) => ctx.chat?.type == ChatType.private,
      (ctx, next) async {
        // Temporary parse mode setter for this context
        await next();
      },
    );
  }
}
```

### Dynamic Parse Mode Based on User Preference

```dart
bot.use((ctx, next) async {
  final userPreference = await getUserParseMode(ctx.from?.id);
  
  // Temporarily install parse mode setter
  final plugin = ParseModeSetterPlugin<Context>(
    parseMode: userPreference,
    allowedMethods: [APIMethod.sendMessage],
  );
  
  await next();
});
```

## Best Practices

1. **Choose One Parse Mode**: Stick to one parse mode throughout your bot for consistency
2. **Test Formatting**: Always test your formatted messages to ensure they render correctly
3. **Escape Special Characters**: When using user input, properly escape special characters
4. **Consider Context**: Some messages (like error messages) might not need formatting
5. **Performance**: The plugin adds minimal overhead but consider your specific use case

## Troubleshooting

### Common Issues

**Parse errors in messages:**
- Ensure you're using the correct syntax for your chosen parse mode
- Check that special characters are properly escaped
- Verify that HTML tags are properly closed

**Plugin not working:**
- Make sure you've installed the plugin with `bot.plugin()`
- Check that the API method is in the `allowedMethods` list
- Verify it's not in the `disallowedMethods` list

**Conflicts with manual parse mode:**
- The plugin will override any manually set parse mode
- Use `disallowedMethods` to exclude specific methods where you want manual control

## 🧑🻍💻 Contributing

We appreciate your interest in improving the ParseModeSetter plugin! If you find it helpful, consider starring the Televerse repository. Feel free to report any issues or suggest improvements on GitHub.

## Get Started with Televerse

For more information on Televerse, the Telegram Bot API framework used with this plugin, [visit the official repository](https://github.com/HeySreelal/televerse).

**Thank you for using ParseModeSetterPlugin! We hope it simplifies your Televerse bot development experience.**