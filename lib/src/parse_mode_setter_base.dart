part of '../parse_mode_setter.dart';

/// A transformer plugin for Televerse that automatically sets the parse mode for API methods.
///
/// The `ParseModeSetterPlugin` class implements the `TransformerPlugin` interface and
/// is used to set the parse mode (e.g., Markdown, HTML) for various API methods
/// in Telegram bot interactions. This ensures that messages, captions, and
/// poll questions/explanations are formatted correctly according to the specified
/// parse mode.
///
/// This plugin provides several properties for configuration:
/// - `parseMode`: The parse mode to be set (e.g., Markdown, HTML).
/// - `allowedMethods`: A list of API methods that are allowed to have their parse mode set.
/// - `disallowedMethods`: A list of API methods that are not allowed to have their parse mode set.
/// - `setQuestionParseMode`: A boolean indicating whether to set the parse mode for poll questions.
/// - `setExplanationParseMode`: A boolean indicating whether to set the parse mode for poll explanations.
///
/// Example usage:
///
/// ```dart
/// final bot = Bot<Context>('YOUR_BOT_TOKEN');
///
/// bot.plugin(ParseModeSetterPlugin<Context>(
///   parseMode: ParseMode.markdownV2,
///   allowedMethods: [APIMethod.sendMessage, APIMethod.sendPhoto],
///   disallowedMethods: [APIMethod.sendVoice],
///   setQuestionParseMode: true,
///   setExplanationParseMode: false,
/// ));
///
/// // Now all messages will automatically use MarkdownV2 parse mode
/// bot.command('start', (ctx) async {
///   await ctx.reply('*Welcome* to _Televerse_!'); // Will be parsed as MarkdownV2
/// });
/// ```
class ParseModeSetterPlugin<CTX extends Context>
    implements TransformerPlugin<CTX> {
  /// The parse mode to be set (e.g., Markdown, HTML).
  final ParseMode parseMode;

  /// A list of API methods that are allowed to have their parse mode set.
  final List<APIMethod> allowedMethods;

  /// A list of API methods that are not allowed to have their parse mode set.
  final List<APIMethod> disallowedMethods;

  /// A boolean indicating whether to set the parse mode for poll questions. (Only checked for `sendPoll` method)
  final bool setQuestionParseMode;

  /// A boolean indicating whether to set the parse mode for poll explanations. (Only checked for `sendPoll` method)
  final bool setExplanationParseMode;

  /// Constructs an instance of `ParseModeSetterPlugin`.
  ///
  /// The constructor allows you to specify the following:
  ///
  /// * **[parseMode]:** The parse mode to be set (e.g., Markdown, HTML).
  ///
  /// * **[allowedMethods]:** This is a list of API methods that are allowed
  /// to have their parse mode set. Defaults to a list containing methods for sending
  /// various content types like messages, photos, audio, documents, videos, animations,
  /// voices, polls, and editing messages.
  ///
  ///   Defaults to list containing:
  ///   - `APIMethod.sendMessage`
  ///   - `APIMethod.copyMessage`
  ///   - `APIMethod.sendPhoto`
  ///   - `APIMethod.sendAudio`
  ///   - `APIMethod.sendDocument`
  ///   - `APIMethod.sendVideo`
  ///   - `APIMethod.sendAnimation`
  ///   - `APIMethod.sendVoice`
  ///   - `APIMethod.sendPoll`
  ///   - `APIMethod.editMessageText`
  ///   - `APIMethod.editMessageCaption`
  ///   - `APIMethod.editMessageMedia`
  ///   - `APIMethod.sendMediaGroup`
  ///   - `APIMethod.answerInlineQuery`
  ///
  /// * **[disallowedMethods]:** This is a list of API methods that are explicitly
  /// prohibited from having their parse mode set. Defaults to an empty list.
  ///
  /// * **[setQuestionParseMode]:** This defines whether to set the parse mode for
  /// poll questions. Defaults to true.
  ///
  /// * **[setExplanationParseMode]:** This defines whether to set the parse mode for
  /// poll explanations. Defaults to true.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// final bot = Bot<Context>('YOUR_BOT_TOKEN');
  ///
  /// bot.plugin(ParseModeSetterPlugin<Context>(
  ///   parseMode: ParseMode.markdownV2,
  ///   allowedMethods: [APIMethod.sendMessage, APIMethod.sendPhoto],
  ///   disallowedMethods: [APIMethod.sendVoice],
  ///   setQuestionParseMode: true,
  ///   setExplanationParseMode: false,
  /// ));
  /// ```
  ///
  /// In this example, the parse mode is set to MarkdownV2 for `sendMessage` and `sendPhoto` methods,
  /// while it is explicitly not set for the `sendVoice` method. The parse mode is also set for
  /// poll questions but not for poll explanations.
  const ParseModeSetterPlugin(
    this.parseMode, {
    this.allowedMethods = const [
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
      APIMethod.editMessageMedia,
      APIMethod.answerInlineQuery,
      APIMethod.sendMediaGroup,
    ],
    this.disallowedMethods = const [],
    this.setExplanationParseMode = true,
    this.setQuestionParseMode = true,
  });

  @override
  String get name => 'parse-mode-setter';

  @override
  String get version => '1.0.0';

  @override
  List<String> get dependencies => [];

  @override
  String? get description =>
      'Automatically sets parse mode for API methods that support text formatting';

  @override
  Transformer get transformer => _ParseModeSetterTransformer(
        parseMode: parseMode,
        allowedMethods: allowedMethods,
        disallowedMethods: disallowedMethods,
        setQuestionParseMode: setQuestionParseMode,
        setExplanationParseMode: setExplanationParseMode,
      );

  @override
  void install(Bot<CTX> bot) {
    bot.api.use(transformer);
  }

  @override
  void uninstall(Bot<CTX> bot) {
    bot.api.removeTransformer(transformer);
  }
}

/// Internal transformer class that handles the actual parse mode setting logic.
class _ParseModeSetterTransformer extends Transformer {
  /// The parse mode to be set (e.g., Markdown, HTML).
  final ParseMode parseMode;

  /// A list of API methods that are allowed to have their parse mode set.
  final List<APIMethod> allowedMethods;

  /// A list of API methods that are not allowed to have their parse mode set.
  final List<APIMethod> disallowedMethods;

  /// A boolean indicating whether to set the parse mode for poll questions.
  final bool setQuestionParseMode;

  /// A boolean indicating whether to set the parse mode for poll explanations.
  final bool setExplanationParseMode;

  /// Creates the internal parse mode setter transformer.
  const _ParseModeSetterTransformer({
    required this.parseMode,
    required this.allowedMethods,
    required this.disallowedMethods,
    required this.setQuestionParseMode,
    required this.setExplanationParseMode,
  });

  @override
  String get description => 'Sets parse mode for text formatting in API calls';

  @override
  Future<Map<String, dynamic>> transform(
    APICaller call,
    APIMethod method, [
    Payload? payload,
  ]) async {
    // Check if method is allowed
    if (!allowedMethods.contains(method)) {
      return await call(method, payload);
    }

    // Check if method is explicitly disallowed
    if (disallowedMethods.contains(method)) {
      return await call(method, payload);
    }

    // If no payload, just call the method
    if (payload == null) {
      return await call(method, payload);
    }

    // Clone payload to avoid modifying the original
    final modifiedPayload = Payload(
      Map<String, dynamic>.from(payload.params),
      payload.files,
    );

    const kParseMode = "parse_mode";
    final isSendPoll = method == APIMethod.sendPoll;

    if (isSendPoll) {
      // Handle poll-specific parse modes
      if (setExplanationParseMode) {
        modifiedPayload.params["explanation_parse_mode"] = parseMode.toJson();
      }
      if (setQuestionParseMode) {
        modifiedPayload.params["question_parse_mode"] = parseMode.toJson();
      }
    } else if (method == APIMethod.answerInlineQuery) {
      // Handle inline query results
      final List<dynamic>? results = modifiedPayload.params['results'];
      if (results != null) {
        const supported = [
          "voice",
          "audio",
          "video",
          "photo",
          "mpeg4_gif",
          "gif",
          "document",
        ];

        for (int i = 0; i < results.length; i++) {
          final result = results[i];
          if (result is Map<String, dynamic>) {
            // Set parse mode for supported result types
            if (supported.contains(result['type'])) {
              result[kParseMode] = parseMode.toJson();
            }

            // Set parse mode for input message content
            final inputMessageContent = result['input_message_content'];
            if (inputMessageContent is Map<String, dynamic> &&
                inputMessageContent["message_text"] != null) {
              inputMessageContent[kParseMode] = parseMode.toJson();
            }
          }
        }
        modifiedPayload.params['results'] = results;
      }
    } else if (method == APIMethod.editMessageMedia) {
      // Handle media editing
      final media = modifiedPayload.params["media"];
      if (media is Map<String, dynamic> && media["caption"] != null) {
        media[kParseMode] = parseMode.toJson();
        modifiedPayload.params["media"] = media;
      }
    } else if (method == APIMethod.sendMediaGroup) {
      // Handle media group
      final List<dynamic>? media = modifiedPayload.params["media"];
      if (media != null) {
        for (int i = 0; i < media.length; i++) {
          final mediaItem = media[i];
          if (mediaItem is Map<String, dynamic> &&
              mediaItem["caption"] != null) {
            mediaItem[kParseMode] = parseMode.toJson();
          }
        }
        modifiedPayload.params["media"] = media;
      }
    } else {
      // For all other methods, set the parse mode directly
      modifiedPayload.params[kParseMode] = parseMode.toJson();
    }

    return await call(method, modifiedPayload);
  }
}
