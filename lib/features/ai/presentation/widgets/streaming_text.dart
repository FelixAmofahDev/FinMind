import 'dart:async';
import 'package:flutter/material.dart';

import 'markdown_renderer.dart';

/// Reveals [content] progressively to mimic a streamed response,
/// then renders through MarkdownRenderer so formatting still works.
class StreamingText extends StatefulWidget {
  const StreamingText({
    super.key,
    required this.content,
    required this.textColor,
    required this.headingColor,
    required this.linkColor,
    this.animate = true,
    this.onComplete,
  });

  final String content;
  final Color textColor;
  final Color headingColor;
  final Color linkColor;
  final bool animate;
  final VoidCallback? onComplete;

  @override
  State<StreamingText> createState() => _StreamingTextState();
}

class _StreamingTextState extends State<StreamingText> {
  Timer? _timer;
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    if (widget.animate) {
      _startAnimation();
    } else {
      _charCount = widget.content.length;
    }
  }

  @override
  void didUpdateWidget(covariant StreamingText oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the content changes (e.g. new message reused the widget), restart.
    if (oldWidget.content != widget.content) {
      _timer?.cancel();
      _charCount = widget.animate ? 0 : widget.content.length;
      if (widget.animate) _startAnimation();
    }
  }

  void _startAnimation() {
    const chunkSize = 3; // characters revealed per tick — tweak for speed
    const tickDuration = Duration(milliseconds: 12);
    _timer = Timer.periodic(tickDuration, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _charCount = (_charCount + chunkSize).clamp(0, widget.content.length);
      });
      if (_charCount >= widget.content.length) {
        timer.cancel();
        widget.onComplete?.call();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visibleText = widget.content.substring(0, _charCount);
    return MarkdownRenderer(
      content: visibleText,
      textColor: widget.textColor,
      headingColor: widget.headingColor,
      linkColor: widget.linkColor,
    );
  }
}