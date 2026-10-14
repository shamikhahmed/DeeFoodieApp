import 'package:flutter/material.dart';

import '../services/auth_token_store.dart';
import '../services/web_beta_gate.dart';
import '../theme/app_theme.dart';

/// Blocks all Flutter web journal UI until a beta access token is saved.
class WebBetaGateScreen extends StatefulWidget {
  const WebBetaGateScreen({super.key, required this.onUnlocked, this.store});

  final VoidCallback onUnlocked;
  final AuthTokenStore? store;

  @override
  State<WebBetaGateScreen> createState() => _WebBetaGateScreenState();
}

class _WebBetaGateScreenState extends State<WebBetaGateScreen> {
  final _controller = TextEditingController();
  String? _error;
  bool _busy = false;

  AuthTokenStore get _store => widget.store ?? AuthTokenStore();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final raw = _controller.text.trim();
    if (!WebBetaGate.isValidToken(raw)) {
      setState(() {
        _error =
            'Enter your invite access token (${WebBetaGate.minTokenLength}+ characters).';
      });
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    await _store.write(raw);
    if (!mounted) return;
    widget.onUnlocked();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1A14),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'DeeFoodie',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: const Color(0xFFE8C27A),
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Private beta',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: const Color(0xFFE8C27A).withValues(alpha: 0.85),
                        ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your Karachi food journal is invite-only. Enter your access token to continue. There is no public install.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFFD6E0D8),
                          height: 1.45,
                        ),
                  ),
                  const SizedBox(height: 28),
                  TextField(
                    controller: _controller,
                    obscureText: true,
                    autocorrect: false,
                    enableSuggestions: false,
                    enabled: !_busy,
                    style: const TextStyle(color: Color(0xFFF7F1E8)),
                    decoration: InputDecoration(
                      labelText: 'Access token',
                      labelStyle: TextStyle(
                        color: const Color(0xFFE8C27A).withValues(alpha: 0.9),
                      ),
                      filled: true,
                      fillColor: const Color(0xFF1A2E1F),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF2F4A38)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF2F4A38)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE8C27A)),
                      ),
                    ),
                    onSubmitted: (_) => _submit(),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _error!,
                      style: const TextStyle(color: Color(0xFFFFB4A8)),
                    ),
                  ],
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: _busy ? null : _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFE8C27A),
                      foregroundColor: const Color(0xFF0F1A14),
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: Text(_busy ? 'Saving…' : 'Continue'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No public install link. Hub lists DeeFoodie as Private beta.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textMuted.withValues(alpha: 0.7),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
