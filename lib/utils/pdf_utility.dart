import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lims_app/utils/barcode_utility.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'dart:html' as html;

class PdfUtility {
  static void savePdf(BuildContext context, String barcodeString) async{
    pw.Document pdf = pw.Document();
    var anchor;

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
    var blob = html.Blob([pdfInBytes], 'application/pdf');
    var url = html.Url.createObjectUrlFromBlob(blob);
    anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'export.pdf';
    html.document.body?.children.add(anchor);

    anchor.click();
  }
}
