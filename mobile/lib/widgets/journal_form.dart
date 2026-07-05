import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'journal_paper.dart';

class JournalFormScaffold extends StatelessWidget {
  const JournalFormScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.leading,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return JournalPaper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: leading,
          title: Text(
            title,
            style: GoogleFonts.fraunces(fontWeight: FontWeight.w600, fontStyle: FontStyle.italic, color: AppColors.inkBrown),
          ),
          actions: actions,
        ),
        body: body,
      ),
    );
  }
}

class JournalFormSection extends StatelessWidget {
  const JournalFormSection({super.key, this.title, required this.child, this.padding});

  final String? title;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return JournalPageCard(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null) ...[
            Text(title!, style: journalSectionStyle(context)),
            const SizedBox(height: AppSpacing.sm),
          ],
          child,
        ],
      ),
    );
  }
}

TextStyle journalSectionStyle(BuildContext context) {
  return GoogleFonts.fraunces(fontSize: 16, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic, color: AppColors.coffeeBrown);
}

InputDecoration journalInputDecoration({String? hint, String? label}) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    filled: true,
    fillColor: const Color(0xFFFFFDF8),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: AppColors.inkBrown.withValues(alpha: 0.18))),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: AppColors.inkBrown.withValues(alpha: 0.14))),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: AppColors.coffeeBrown, width: 1.5)),
    labelStyle: GoogleFonts.caveat(fontSize: 16, color: AppColors.textMuted),
    hintStyle: GoogleFonts.caveat(fontSize: 16, color: AppColors.textSubtle),
  );
}
