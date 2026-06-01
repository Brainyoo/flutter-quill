import 'package:flutter/foundation.dart';

import 'editor_config.dart' show QuillStyleErrorHandler;

/// Reports a style/attribute interpretation failure via [handler] and
/// emits a [debugPrint] [message] for the dev console.
///
/// [handler] is invoked on every call. The embedding app is responsible
/// for any deduplication or rate-limiting it needs in its own logging
/// pipeline.
///
/// Any exception thrown by [handler] is swallowed so rendering can never
/// be brought down by faulty diagnostics code.
///
/// This file is intentionally NOT re-exported from `flutter_quill.dart`
/// so [@internal] visibility holds for downstream consumers.
@internal
void notifyQuillStyleError({
  required QuillStyleErrorHandler? handler,
  required Object error,
  required StackTrace stackTrace,
  required String context,
  required String message,
}) {
  debugPrint(message);
  if (handler != null) {
    try {
      handler(error, stackTrace, context: context);
    } catch (_) {
      // Never let the app's handler crash rendering.
    }
  }
}
