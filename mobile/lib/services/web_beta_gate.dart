/// DFD-V3-1 / D-10 — Web entry requires a beta bearer before journal content.
///
/// Matches issued API tokens (32+ bytes). Native iOS is TestFlight-gated and
/// does not use this check.
class WebBetaGate {
  WebBetaGate._();

  /// Minimum length for a D-10 per-user bearer (random 32+ bytes).
  static const int minTokenLength = 32;

  static bool isValidToken(String? token) {
    if (token == null) return false;
    final t = token.trim();
    return t.length >= minTokenLength;
  }
}
