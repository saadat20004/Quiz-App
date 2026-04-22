import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:file_saver/file_saver.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ReportExportHelper {
  static Future<void> exportPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Quiz Report',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Total Attempts: 9,620'),
              pw.Text('Average Score: 86%'),
              pw.Text('Completion Rate: 91%'),
              pw.Text('Active Participants: 1,284'),
            ],
          );
        },
      ),
    );

    final Uint8List bytes = Uint8List.fromList(await pdf.save());

    await FileSaver.instance.saveFile(
      name: 'quiz_report',
      bytes: bytes,
      ext: 'pdf',
      mimeType: MimeType.pdf,
    );
  }

  static Future<void> exportExcel() async {
    final Excel excel = Excel.createExcel();
    final Sheet sheet = excel['Reports'];

    sheet.appendRow([
      TextCellValue('Metric'),
      TextCellValue('Value'),
    ]);
    sheet.appendRow([
      TextCellValue('Total Attempts'),
      TextCellValue('9620'),
    ]);
    sheet.appendRow([
      TextCellValue('Average Score'),
      TextCellValue('86%'),
    ]);
    sheet.appendRow([
      TextCellValue('Completion Rate'),
      TextCellValue('91%'),
    ]);
    sheet.appendRow([
      TextCellValue('Active Participants'),
      TextCellValue('1284'),
    ]);

    final List<int>? fileBytes = excel.encode();
    if (fileBytes == null) return;

    await FileSaver.instance.saveFile(
      name: 'quiz_report',
      bytes: Uint8List.fromList(fileBytes),
      ext: 'xlsx',
      mimeType: MimeType.microsoftExcel,
    );
  }
}