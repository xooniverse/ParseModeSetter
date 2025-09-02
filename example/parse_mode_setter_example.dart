import 'dart:io';

import 'package:parse_mode_setter/parse_mode_setter.dart';
import 'package:televerse/telegram.dart';
import 'package:televerse/televerse.dart';

final bot = Bot(Platform.environment["BOT_TOKEN"]!);

void main(List<String> args) {
  // Attach the Parse Mode Setter with passing necessary parameters.
  // Here we are setting the parse mode to HTML.
  bot.plugin(ParseModeSetterPlugin(ParseMode.html));

  bot.command('start', (ctx) async {
    // Now use HTML text within the methods, don't worry about not passing the parse mode
    await ctx.reply(htmlText());
  });

  bot.onInlineQuery((ctx) async {
    final results = InlineQueryResultBuilder().article(
      "test-id",
      "Hello",
      (content) => content.text(htmlText()),
    );
    await ctx.answerInlineQuery(results.build());
  });

  bot.command('group', (ctx) async {
    await ctx.replyWithMediaGroup([
      InputMediaPhoto(
        media: InputFile.fromUrl(
          "https://televerse-space.web.app/example/photo.jpg",
        ),
        caption: htmlText(),
      ),
      InputMediaPhoto(
        media: InputFile.fromUrl(
          "https://televerse-space.web.app/example/photo.jpg",
        ),
      ),
    ]);
  });

  bot.start();
}

String htmlText() {
  return """<b>bold</b>, <strong>bold</strong>\n
<i>italic</i>, <em>italic</em>\n
<u>underline</u>, <ins>underline</ins>\n
<s>strikethrough</s>, <strike>strikethrough</strike>, <del>strikethrough</del>\n
<span class="tg-spoiler">spoiler</span>, <tg-spoiler>spoiler</tg-spoiler>\n
<b>bold <i>italic bold <s>italic bold strikethrough <span class="tg-spoiler">italic bold strikethrough spoiler</span></s> <u>underline italic bold</u></i> bold</b>\n
<a href="http://www.example.com/">inline URL</a>\n
<a href="tg://user?id=123456789">inline mention of a user</a>\n
<tg-emoji emoji-id="5368324170671202286">👍</tg-emoji>\n
<code>inline fixed-width code</code>\n
<pre>pre-formatted fixed-width code block</pre>\n
<pre><code class="language-python">pre-formatted fixed-width code block written in the Python programming language</code></pre>\n
<blockquote>Block quotation started\nBlock quotation continued\nThe last line of the block quotation</blockquote>\n
<blockquote expandable>Expandable block quotation started\nExpandable block quotation continued\nExpandable block quotation continued\nHidden by default part of the block quotation started\nExpandable block quotation continued\nThe last line of the block quotation</blockquote>""";
}
