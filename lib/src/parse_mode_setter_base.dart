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

    final isSendPoll = method == APIMethod.sendPoll;

    if (isSendPoll) {
      if (setExplanationParseMode) {
        payload["explanation_parse_mode"] = parseMode.value;
      }
      if (setQuestionParseMode) {
        payload["question_parse_mode"] = parseMode.value;
      }
    } else {
      payload["parse_mode"] = parseMode.value;
    }

    return call(method, payload);
  }
}
