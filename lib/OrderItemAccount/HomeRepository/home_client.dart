import 'dart:io';

import 'package:delivoo_store/AppConfig/app_config.dart';
import 'package:delivoo_store/JsonFiles/Address/getaddress_json.dart';
import 'package:delivoo_store/JsonFiles/Address/postaddress_json.dart';
import 'package:delivoo_store/JsonFiles/Products/list_products.dart';
import 'package:delivoo_store/JsonFiles/Vendors/list_vendors.dart';
import 'package:delivoo_store/JsonFiles/file_upload_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'home_client.g.dart';

@RestApi(baseUrl: AppConfig.baseUrl)
abstract class HomeClient {
  factory HomeClient(Dio dio, {String baseUrl}) = _HomeClient;

  @GET('/addresses')
  Future<List<GetAddress>> getAddresses();

  @POST('/addresses')
  Future<void> postAddress(
    @Body() PostAddress address,
  );

  @GET('/vendors/list')
  Future<ListVendors> searchVendors(@Query('search') String text);

  @GET('/products')
  Future<ListProduct> searchProducts(
      @Query('vendor') int vendorId, @Query('search') String text);

  @POST("/file-upload")
  @MultiPart()
  Future<FileUploadResponse> uploadFile({@Part() File? file});
}
