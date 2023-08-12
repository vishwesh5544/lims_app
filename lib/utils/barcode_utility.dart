import 'package:barcode/barcode.dart';
import 'package:lims_app/utils/lims_logger.dart';

class BarcodeUtility {
  // final barcode = Barcode.code128(useCode128A: true, useCode128B: true, useCode128C: true);
  final barcode = Barcode.upcA();

  // final barcode = Barcode.gs128();
  // final barcode = Barcode.up();

  static String getBarcodeSvgString(String barcodeData,
      {double width = 200, double height = 100, bool drawText = true}) {
    try {
      BarcodeUtility().barcode.verify(barcodeData);
    } catch (e) {
      // TODO(backend): Change this to handle barcode properly via backend
      if (e.toString().contains('should be')) {
        final parts = e.toString().split('should be');
        final lastCharacter = parts[1].replaceAll('"', '').trim();
        barcodeData =
            barcodeData.substring(0, barcodeData.length - 2) + lastCharacter;
      }
      LimsLogger.log('Barcode changed to $barcodeData');
    }
    // return BarcodeUtility().barcode.make(barcodeData, width: width, height: height, drawText: drawText);
    return BarcodeUtility()
        .barcode
        .toSvg(barcodeData, width: width, height: height, drawText: drawText);
  }
}
