import 'package:delivoo_store/Constants/constants.dart';
import 'package:delivoo_store/UtilityFunctions/helper.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    var token = await Helper().getAuthToken();
    options.headers[Constants.authHeaderKey] = "Bearer $token";
    options.headers.addAll({
      "content-type": "application/json",
      'Accept': 'application/json',
    });
    super.onRequest(options, handler);
  }
}
