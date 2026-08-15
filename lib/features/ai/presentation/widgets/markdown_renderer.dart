import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownRenderer extends StatelessWidget {
  const MarkdownRenderer({
    super.key,
    required this.content,
    this.textColor,
    this.codeBackgroundColor,
    this.codeTextColor,
    this.headingColor,
    this.linkColor,
  });

  final String content;
  final Color? textColor;
  final Color? codeBackgroundColor;
  final Color? codeTextColor;
  final Color? headingColor;
  final Color? linkColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveTextColor = textColor ?? theme.colorScheme.onSurface;
    final effectiveCodeBackground =
        codeBackgroundColor ?? theme.colorScheme.surfaceContainerHighest;
    final effectiveCodeTextColor =
        codeTextColor ?? theme.colorScheme.onSurface;
    final effectiveHeadingColor = headingColor ?? theme.colorScheme.primary;
    final effectiveLinkColor =
        linkColor ?? theme.colorScheme.primary;

    return MarkdownBody(
      data: content,
      styleSheet: MarkdownStyleSheet(
        p: TextStyle(color: effectiveTextColor, fontSize: 15, height: 1.5),
        strong: TextStyle(
            color: effectiveTextColor, fontSize: 15, fontWeight: FontWeight.w800),
        em: TextStyle(
            color: effectiveTextColor,
            fontSize: 15,
            fontStyle: FontStyle.italic),
        blockquote: TextStyle(color: effectiveTextColor, fontSize: 15),
        code: TextStyle(
          color: effectiveCodeTextColor,
          fontSize: 13,
          fontFamily: 'monospace',
        ),
        codeblockDecoration: BoxDecoration(
          color: effectiveCodeBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        codeblockPadding: const EdgeInsets.all(12),
        h1: TextStyle(
          color: effectiveHeadingColor,
          fontSize: 22,
          fontWeight: FontWeight.w800,
          height: 1.3,
        ),
        h2: TextStyle(
          color: effectiveHeadingColor,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          height: 1.3,
        ),
        h3: TextStyle(
          color: effectiveHeadingColor,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          height: 1.3,
        ),
        h4: TextStyle(
          color: effectiveHeadingColor,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          height: 1.3,
        ),
        listBullet: TextStyle(color: effectiveTextColor),
        blockSpacing: 8,
        listIndent: 24,
        tableHead: TextStyle(
          color: effectiveTextColor,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
        tableBody: TextStyle(color: effectiveTextColor, fontSize: 14),
        tableBorder: TableBorder.all(
          color: theme.colorScheme.outlineVariant,
          width: 1,
        ),
        tableColumnWidth: const FlexColumnWidth(),
        tablePadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        blockquoteDecoration: BoxDecoration(
          color: effectiveCodeBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border(
            left: BorderSide(color: effectiveLinkColor, width: 3),
          ),
        ),
        blockquotePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        a: TextStyle(color: effectiveLinkColor),
        del: TextStyle(
          color: effectiveTextColor,
          decoration: TextDecoration.lineThrough,
        ),
      ),
    );
  }
}
