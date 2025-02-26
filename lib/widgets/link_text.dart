import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:linkify/linkify.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LinkText extends StatelessWidget {
  const LinkText(this.text, {super.key, this.maxLines = 40});

  final String text;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final linked = linkify(text);
    final color = Theme.of(context).colorScheme.primary;
    return RichText(
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
            children: linked
                .map(
                  (e) => switch (e) {
                    LinkableElement _ => TextSpan(
                        text: e.text,
                        style: TextStyle(color: color),
                        recognizer: TapGestureRecognizer()..onTap = () => launchUrlString(e.url),
                      ),
                    _ => TextSpan(text: e.text)
                  },
                )
                .toList()));
  }
}
