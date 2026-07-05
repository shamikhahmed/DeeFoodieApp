import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'app_background.dart';

/// Ruled-paper shell for pushed archive screens — Fraunces title + Caveat subtitle.
class JournalScreenShell extends StatelessWidget {
  const JournalScreenShell({
    super.key,
    required this.title,
    this.subtitle,
    required this.body,
    this.variant = AppBackgroundVariant.journal,
    this.floatingActionButton,
    this.actions,
  });

  final String title;
  final String? subtitle;
  final Widget body;
  final AppBackgroundVariant variant;
  final Widget? floatingActionButton;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      variant: variant,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: const Color(0xFFF6EFE3).withValues(alpha: 0.92),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(CupertinoIcons.back),
            onPressed: () => context.pop(),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.fraunces(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                  color: AppColors.inkBrown,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: GoogleFonts.caveat(fontSize: 15, color: AppColors.textMuted),
                ),
            ],
          ),
          actions: actions,
        ),
        body: body,
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
