import 'package:flutter/material.dart';
import 'package:lims_app/utils/barcode_utility.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
// import 'dart:html' as html;

class PdfUtility {
  static void savePdf(BuildContext context, String barcodeString) async {
    pw.Document pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          children: [
            pw.SvgImage(svg: BarcodeUtility.getBarcodeSvgString(barcodeString)),
          ],
        ),
      ),
    );

    Uint8List pdfInBytes = await pdf.save();
    // var blob = html.Blob([pdfInBytes], 'application/pdf');
    await Printing.layoutPdf(onLayout: (format) async => pdfInBytes);
    // var url = html.Url.createObjectUrlFromBlob(blob);
    // final anchor = html.document.createElement('a') as html.AnchorElement
    //   ..href = url
    //   ..style.display = 'none'
    //   ..download = 'export.pdf';
    // html.document.body?.children.add(anchor);

    // anchor.click();
  }
}
