import 'dart:html' as html;

/// Token already accepted by `web/index.html` (sessionStorage) before Flutter boots.
String? readHtmlWebBetaToken() {
  try {
    final t = html.window.sessionStorage['deefoodie_web_beta_token'];
    if (t == null) return null;
    final trimmed = t.trim();
    return trimmed.isEmpty ? null : trimmed;
  } catch (_) {
    return null;
  }
}
