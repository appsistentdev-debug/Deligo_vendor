import 'dart:io';

import 'package:delivoo_store/AppConfig/app_config.dart';
import 'package:delivoo_store/JsonFiles/Auth/Responses/login_response.dart';
import 'package:delivoo_store/JsonFiles/Auth/check_user_json.dart';
import 'package:delivoo_store/JsonFiles/Auth/login_json.dart';
import 'package:delivoo_store/JsonFiles/Auth/register_json.dart';
import 'package:delivoo_store/JsonFiles/Notification/notification.dart';
import 'package:delivoo_store/JsonFiles/Support/support_json.dart';
import 'package:delivoo_store/JsonFiles/User/Put/update_vendor.dart';
import 'package:delivoo_store/JsonFiles/User/vendor_info.dart';
import 'package:delivoo_store/JsonFiles/file_upload_response.dart';
import 'package:delivoo_store/JsonFiles/settings.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_client.g.dart';

@RestApi(baseUrl: AppConfig.baseUrl)
abstract class AuthClient {
  factory AuthClient(Dio dio, {String baseUrl}) = _AuthClient;

  @POST('/check-user')
  Future<void> checkUser(@Body() CheckUser checkUser);

  @POST('/register')
  Future<void> registerUser(@Body() RegisterUser registerUser);

  @POST('/login')
  Future<LoginResponse> login(@Body() Login login);

  @POST('/support')
  Future<void> createSupport(@Body() Support support);

  @GET('/vendors')
  Future<VendorInfo> getVendorByToken();

  @PUT('/vendors/{id}')
  Future<VendorInfo> updateVendor(
    @Path('id') int id,
    @Body() UpdateVendorInfo updateVendor,
  );

  @GET('/settings')
  Future<List<Setting>> getSettings();

  @PUT('/user')
  Future<void> updateNotificationId(
    @Body() Notification notification,
  );

  @DELETE('/user')
  Future<void> deleteUser();

  @POST("/file-upload")
  @MultiPart()
  Future<FileUploadResponse> uploadFile({@Part() File? file});
}
