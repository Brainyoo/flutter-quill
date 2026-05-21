import 'package:flutter/foundation.dart';

import '../../../flutter_quill.dart';

void _reportFontSizeError(
  QuillStyleErrorHandler? onError,
  Object error,
  String contextLabel,
) {
  if (onError == null) return;
  try {
    onError(error, StackTrace.current, context: contextLabel);
  } catch (_) {
    // Never let the handler itself crash rendering.
  }
}

dynamic getFontSize(dynamic sizeValue, {QuillStyleErrorHandler? onError}) {
  if (sizeValue is String) {
    if (['small', 'normal', 'large', 'huge'].contains(sizeValue)) {
      return sizeValue;
    }
    if (sizeValue.endsWith('px')) {
      return double.tryParse(sizeValue.replaceAll('px', ''));
    }
  }

  if (sizeValue is double) {
    return sizeValue;
  }

  if (sizeValue is int) {
    return sizeValue.toDouble();
  }

  if (sizeValue is! String) {
    debugPrint('flutter_quill: unsupported font size value "$sizeValue" – '
        'falling back to default.');
    _reportFontSizeError(
      onError,
      ArgumentError.value(sizeValue, 'sizeValue', 'unsupported type'),
      'getFontSize',
    );
    return null;
  }

  final fontSize = double.tryParse(sizeValue);
  if (fontSize == null) {
    debugPrint('flutter_quill: invalid font size "$sizeValue" – '
        'falling back to default.');
    _reportFontSizeError(
      onError,
      ArgumentError.value(sizeValue, 'sizeValue', 'unparseable'),
      'getFontSize',
    );
    return null;
  }
  return fontSize;
}

double? getFontSizeAsDouble(
  dynamic sizeValue, {
  required DefaultStyles defaultStyles,
  QuillStyleErrorHandler? onError,
}) {
  if (sizeValue is String) {
    if (['small', 'normal', 'large', 'huge'].contains(sizeValue)) {
      return switch (sizeValue) {
        'small' => defaultStyles.sizeSmall?.fontSize,
        'normal' => null,
        'large' => defaultStyles.sizeLarge?.fontSize,
        'huge' => defaultStyles.sizeHuge?.fontSize,
        String() => null,
      };
    }
    if (sizeValue.endsWith('px')) {
      return double.tryParse(sizeValue.replaceAll('px', ''));
    }
  }

  if (sizeValue is double) {
    return sizeValue;
  }

  if (sizeValue is int) {
    return sizeValue.toDouble();
  }

  if (sizeValue is! String) {
    debugPrint('flutter_quill: unsupported font size value "$sizeValue" – '
        'falling back to default.');
    _reportFontSizeError(
      onError,
      ArgumentError.value(sizeValue, 'sizeValue', 'unsupported type'),
      'getFontSizeAsDouble',
    );
    return null;
  }

  final fontSize = double.tryParse(sizeValue);
  if (fontSize == null) {
    debugPrint('flutter_quill: invalid font size "$sizeValue" – '
        'falling back to default.');
    _reportFontSizeError(
      onError,
      ArgumentError.value(sizeValue, 'sizeValue', 'unparseable'),
      'getFontSizeAsDouble',
    );
    return null;
  }
  return fontSize;
}
