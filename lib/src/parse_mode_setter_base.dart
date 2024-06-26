part of '../parse_mode_setter.dart';

/// A transformer plugin for Televerse that automatically sets the parse mode for API methods.
///
/// The `ParseModeSetter` class implements the `Transformer` interface and
/// is used to set the parse mode (e.g., Markdown, HTML) for various API methods
/// in Telegram bot interactions. This ensures that messages, captions, and
/// poll questions/explanations are formatted correctly according to the specified
/// parse mode.
///
/// This transformer provides several properties for configuration:
/// - `parseMode`: The parse mode to be set (e.g., Markdown, HTML).
/// - `allowedMethods`: A list of API methods that are allowed to have their parse mode set.
/// - `disallowedMethods`: A list of API methods that are not allowed to have their parse mode set.
/// - `setQuestionParseMode`: A boolean indicating whether to set the parse mode for poll questions.
/// - `setExplanationParseMode`: A boolean indicating whether to set the parse mode for poll explanations.
///
/// Example usage:
///
/// ```dart
/// final parseModeSetter = ParseModeSetter(
///   ParseMode.markdownV2,
///   allowedMethods: [APIMethod.sendMessage, APIMethod.sendPhoto],
///   disallowedMethods: [APIMethod.sendVoice],
///   setQuestionParseMode: true,
///   setExplanationParseMode: false,
/// );
///
/// bot.use(parseModeSetter);
/// ```
///
/// In this example, the parse mode is set to MarkdownV2 for `sendMessage` and `sendPhoto` methods,
/// while it is explicitly not set for the `sendVoice` method. The parse mode is also set for
/// poll questions but not for poll explanations.
class ParseModeSetter implements Transformer {
  /// A list of API methods that are allowed to have their parse mode set.
  final List<APIMethod> allowedMethods;

  /// A list of API methods that are not allowed to have their parse mode set.
  final List<APIMethod> disallowedMethods;

  /// A boolean indicating whether to set the parse mode for poll questions. (Only checked for `sendPoll` method)
  final bool setQuestionParseMode;

  /// A boolean indicating whether to set the parse mode for poll explanations. (Only checked for `sendPoll` method)
  final bool setExplanationParseMode;

  /// The parse mode to be set (e.g., Markdown, HTML).
  final ParseMode parseMode;

  /// Constructs an instance of `ParseModeSetter`.
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
  /// final parseModeSetter = ParseModeSetter(
  ///   ParseMode.markdownV2,
  ///   allowedMethods: [APIMethod.sendMessage, APIMethod.sendPhoto],
  ///   disallowedMethods: [APIMethod.sendVoice],
  ///   setQuestionParseMode: true,
  ///   setExplanationParseMode: false,
  /// );
  ///
  /// bot.use(parseModeSetter);
  /// ```
  ///
  /// In this example, the parse mode is set to Markdown for `sendMessage` and `sendPhoto` methods,
  /// while it is explicitly not set for the `sendVoice` method. The parse mode is also set for
  /// poll questions but not for poll explanations.
  const ParseModeSetter(
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
      APIMethod.editMessageCaption,
      APIMethod.answerInlineQuery,
      APIMethod.editMessageMedia,
      APIMethod.sendMediaGroup,
    ],
    this.disallowedMethods = const [],
    this.setExplanationParseMode = true,
    this.setQuestionParseMode = true,
  });

  @override
  Future<Map<String, dynamic>> transform(
    APICaller call,
    APIMethod method,
    Payload payload,
  ) {
    if (!allowedMethods.contains(method)) {
      return call(method, payload);
    }
    if (disallowedMethods.contains(method)) {
      return call(method, payload);
    }
    const kParseMode = "parse_mode";

    final isSendPoll = method == APIMethod.sendPoll;

    if (isSendPoll) {
      if (setExplanationParseMode) {
        payload["explanation_parse_mode"] = parseMode.value;
      }
      if (setQuestionParseMode) {
        payload["question_parse_mode"] = parseMode.value;
      }
    } else if (method == APIMethod.answerInlineQuery) {
      const supported = [
        "voice",
        "audio",
        "video",
        "photo",
        "mpeg4_gif",
        "gif",
        "document",
      ];

      final List<dynamic> results = payload['results'];
      for (int i = 0; i < results.length; i++) {
        if (supported.contains(results[i]['type'])) {
          results[i][kParseMode] = parseMode.value;
        }
        if (results[i]['input_message_content']?["message_text"] != null) {
          results[i]['input_message_content'][kParseMode] = parseMode.value;
        }
      }
      payload['results'] = results;
    } else if (method == APIMethod.editMessageMedia) {
      if (payload["media"]["caption"] != null) {
        payload["media"][kParseMode] = parseMode.value;
      }
    } else if (method == APIMethod.sendMediaGroup) {
      final List<dynamic> media = payload["media"];
      for (int i = 0; i < media.length; i++) {
        if (media[i]["caption"] != null) {
          media[i][kParseMode] = parseMode.value;
        }
      }
      payload["media"] = media;
    } else {
      payload[kParseMode] = parseMode.value;
    }

    return call(method, payload);
  }
}
