import 'package:barcode/barcode.dart';

class BarcodeUtility {
  final barcode = Barcode.code128(useCode128A: true, useCode128B: true, useCode128C: true);

  // final barcode = Barcode.gs128();
  // final barcode = Barcode.up();

  static String getBarcodeSvgString(String barcodeData,
      {double width = 200, double height = 100, bool drawText = false}) {
    return BarcodeUtility().barcode.toSvg(barcodeData, width: width, height: height, drawText: drawText);
  }
}
