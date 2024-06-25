import 'dart:io';

import 'package:parse_mode_setter/parse_mode_setter.dart';
import 'package:televerse/televerse.dart';

final bot = Bot(Platform.environment["BOT_TOKEN"]!);

void main(List<String> args) {
  // Attach the Parse Mode Setter with passing necessary parameters.
  // Here we are setting the parse mode to HTML.
  bot.use(ParseModeSetter(ParseMode.html));

  bot.command('start', (ctx) async {
    // Now use HTML text within the methods, don't worry about not passing the parse mode
    await ctx.reply(
      "Hello <b>World</b>\n\nThis is a <i>great story of the Detective Rajappan</i>. I hope you've heard of Rajappan. "
      "Well, if you haven't he's a <tg-spoiler>super detective.</tg-spoiler>",
    );
  });

  bot.start();
}
