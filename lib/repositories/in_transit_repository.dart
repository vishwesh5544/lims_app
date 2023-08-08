import 'dart:convert';

import 'package:lims_app/models/in_transit.dart';
import 'package:lims_app/models/invoice_mapping.dart';
import 'package:lims_app/models/response_callback.dart';
import 'package:lims_app/network/lims_http_client.dart';
import 'package:lims_app/utils/lims_logger.dart';
import 'package:lims_app/utils/strings/common_strings.dart';
import "package:http/http.dart" as http;

abstract class IInTransitRepository {
  Future<ResponseCallback<List<InvoiceMapping>>> getAllInvoiceMapping();

  Future<ResponseCallback<InvoiceMapping>> updateInvoiceMapping(InTransit invoiceMapping, int invoiceId);
}

class InTransitRepository implements IInTransitRepository {
  final _headers = LimsHttpClient.headers;

  @override
  Future<ResponseCallback<InvoiceMapping>> updateInvoiceMapping(InTransit invoiceMapping, int invoiceId) async {
    Uri url = Uri.http(CommonStrings.apiAuthority, "lms/api/testpatient/${invoiceId.toString()}");
    ResponseCallback<InvoiceMapping> responseCallback = ResponseCallback();
    try {
      final response = await http.post(url, body: jsonEncode(invoiceMapping.toJson()), headers: _headers);
      responseCallback.code = response.statusCode;
      responseCallback.data = jsonDecode(response.body)["data"][0];
    } on http.ClientException catch (e) {
      LimsLogger.log("*** http.ClientException in Test Repository addTest().");
      LimsLogger.log("Message => ${e.message}");
      LimsLogger.log("Uri => ${e.uri}");
      responseCallback.message = e.message;
      responseCallback.uri = e.uri;
    } on Exception catch (e) {
      responseCallback.message = e.toString();
    }

    return responseCallback;
  }

  @override
  Future<ResponseCallback<List<InvoiceMapping>>> getAllInvoiceMapping() {
    // TODO: implement getAllInvoiceMapping
    throw UnimplementedError();
  }
}
