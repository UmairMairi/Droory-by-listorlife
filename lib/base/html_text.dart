import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class HtmlText extends StatelessWidget {
  final String html;

  const HtmlText({super.key, required this.html});

  @override
  Widget build(BuildContext context) {
    return Html(
      data: html,
      onLinkTap: (url, map, element) {
        if (url != null) {
          print("Opening $url...");
          // Use url_launcher package or other method to open the link
        }
      },
    );
  }
}
