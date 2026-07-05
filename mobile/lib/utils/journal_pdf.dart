import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/visit.dart';
import '../theme/app_theme.dart';

Future<void> exportJournalPdf({
  required String title,
  required List<Visit> visits,
}) async {
  final doc = pw.Document();
  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (ctx) => [
        pw.Header(level: 0, child: pw.Text(title, style: pw.TextStyle(fontSize: 22))),
        pw.SizedBox(height: 12),
        ...visits.map((v) {
          return pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 14),
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('${v.eateryName} · ${v.rating.toStringAsFixed(1)}★', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                pw.Text(v.date, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                if (v.reviewText != null && v.reviewText!.trim().isNotEmpty)
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(top: 6),
                    child: pw.Text(v.reviewText!, style: const pw.TextStyle(fontSize: 11)),
                  ),
                if (v.items.isNotEmpty)
                  pw.Text('Ordered: ${v.items.map((i) => i.name).join(', ')}', style: const pw.TextStyle(fontSize: 10)),
              ],
            ),
          );
        }),
        pw.SizedBox(height: 20),
        pw.Text('Exported from DeeFoodieApp — Karachi food archive', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
      ],
    ),
  );

  final bytes = await doc.save();
  await Printing.sharePdf(bytes: Uint8List.fromList(bytes), filename: 'deefoodie-journal.pdf');
}
