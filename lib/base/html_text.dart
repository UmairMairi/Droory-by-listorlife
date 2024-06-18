import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HtmlText extends StatelessWidget {
  final String html;

  const HtmlText({super.key, required this.html});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: parseHtml(html, context),
    );
  }

  TextSpan parseHtml(String html, BuildContext context) {
    final RegExp exp = RegExp(r"<\/?[^>]+>");
    final List<InlineSpan> children = [];
    final List<String> parts = html.split(exp);
    final Iterable<RegExpMatch> matches = exp.allMatches(html);

    int index = 0;
    bool bold = false, italic = false, underline = false;
    String? link;

    for (final RegExpMatch match in matches) {
      final String tag = match.group(0)!.toLowerCase();
      final String text = parts[index].trim();

      if (text.isNotEmpty) {
        children.add(TextSpan(
          text: text,
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            fontStyle: italic ? FontStyle.italic : FontStyle.normal,
            decoration:
                underline ? TextDecoration.underline : TextDecoration.none,
            color: link != null ? Colors.blue : Colors.black,
          ),
          recognizer: link != null
              ? (TapGestureRecognizer()..onTap = () => _handleLinkTap(link!))
              : null,
        ));
      }

      if (tag.contains("</")) {
        if (tag.contains("b")) bold = false;
        if (tag.contains("i")) italic = false;
        if (tag.contains("u")) underline = false;
        if (tag.contains("a")) link = null;
      } else {
        if (tag.contains("b")) bold = true;
        if (tag.contains("i")) italic = true;
        if (tag.contains("u")) underline = true;
        if (tag.contains("a")) link = tag.split('"')[1];
      }

      index++;
    }

    if (parts.length > index) {
      children.add(TextSpan(text: parts[index].trim()));
    }

    return TextSpan(children: children);
  }

  void _handleLinkTap(String url) {
    print("Opening $url...");
    // Use url_launcher package or other method to open the link
  }
}
