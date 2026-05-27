import '../../../flutter_quill.dart';

void _reportFontSizeFailure({
  required QuillStyleErrorHandler? onError,
  required dynamic sizeValue,
  required String functionName,
  required String reason,
}) {
  final error =
      ArgumentError.value(sizeValue, 'sizeValue', '$reason for $functionName');
  notifyQuillStyleError(
    handler: onError,
    error: error,
    stackTrace: StackTrace.current,
    context: functionName,
    dedupKey: '$functionName:$reason:$sizeValue',
    message: 'flutter_quill: $reason font size value "$sizeValue" – '
        'falling back to default.',
  );
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
    _reportFontSizeFailure(
      onError: onError,
      sizeValue: sizeValue,
      functionName: 'getFontSize',
      reason: 'unsupported-type',
    );
    return null;
  }

  final fontSize = double.tryParse(sizeValue);
  if (fontSize == null) {
    _reportFontSizeFailure(
      onError: onError,
      sizeValue: sizeValue,
      functionName: 'getFontSize',
      reason: 'unparseable',
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
    _reportFontSizeFailure(
      onError: onError,
      sizeValue: sizeValue,
      functionName: 'getFontSizeAsDouble',
      reason: 'unsupported-type',
    );
    return null;
  }

  final fontSize = double.tryParse(sizeValue);
  if (fontSize == null) {
    _reportFontSizeFailure(
      onError: onError,
      sizeValue: sizeValue,
      functionName: 'getFontSizeAsDouble',
      reason: 'unparseable',
    );
    return null;
  }
  return fontSize;
}
