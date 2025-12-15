import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

import 'package:delivoo_store/AppConfig/app_config.dart';
import 'package:delivoo_store/JsonFiles/Categories/category_data.dart';
import 'package:delivoo_store/JsonFiles/Order/Get/order_data.dart';
import 'package:delivoo_store/JsonFiles/Products/product_data.dart';
import 'package:delivoo_store/JsonFiles/Ratings/ratings_data.dart';
import 'package:delivoo_store/JsonFiles/Vendors/list_vendors.dart';
import 'package:delivoo_store/JsonFiles/Wallet/Post/send_to_bank.dart';
import 'package:delivoo_store/JsonFiles/Wallet/Transaction/transaction.dart';
import 'package:delivoo_store/JsonFiles/Wallet/get_wallet_balance.dart';
import 'package:delivoo_store/JsonFiles/base_list_response.dart';
import 'package:delivoo_store/JsonFiles/file_upload_response.dart';
import 'package:delivoo_store/JsonFiles/insights/vendor_insight.dart';
import 'package:delivoo_store/JsonFiles/settings.dart';

part 'product_client.g.dart';

@RestApi(baseUrl: AppConfig.baseUrl)
abstract class ProductClient {
  factory ProductClient(Dio dio, {String baseUrl}) = _ProductClient;

  @PUT('/orders/{id}')
  Future<OrderData> updateOrder(
    @Path('id') int orderId,
    @Body() Map<String, dynamic> updateOrderRequest,
  );

  @GET('/orders/{id}')
  Future<OrderData> getOrderById(@Path('id') int orderId);

  @GET('/orders?active=1')
  Future<BaseListResponse<OrderData>> getOrdersNew(
    @Query('vendor') int vendorId,
    @Query('page') int page,
  );

  @GET('/orders?past=1')
  Future<BaseListResponse<OrderData>> getOrdersPast(
    @Query('vendor') int vendorId,
    @Query('page') int page,
  );

  @GET('/products')
  Future<BaseListResponse<ProductData>> getProducts(
    @Query('vendor') int id,
    @Query('category') int categoryId,
    @Query('page') int pageNo,
  );

  @GET('/vendors/list')
  Future<ListVendors> getVendors(@Query('category') int id);

  @GET('/user/wallet/balance')
  Future<WalletBalance> getBalance();

  @GET('/user/wallet/transactions')
  Future<BaseListResponse<Transaction>> getTransactions(
      @Query('page') int pageNo);

  @GET("/categories?pagination=0")
  Future<List<CategoryData>> getCategories({ 
    @Query("parent") int? parent,
    @Query("scope") String? scope,
    @Query("meta[vendor_type]") String? vendorType,
    @Query("categories") String? parentCatIdsCommaSeparated,
    @Query("title") String? query,
  });

  @POST('/user/wallet/payout')
  Future<void> sendToBank(@Body() SendToBank sendToBank);

  @POST('/products')
  Future<ProductData> postProduct(@Body() Map<String, dynamic> addProduct);

  @PUT('/products/{productId}')
  Future<ProductData> editProduct(
    @Path('productId') productId,
    @Body() Map<String, dynamic> addProduct,
  );

  @GET('/settings')
  Future<List<Setting>> getSettings();

  @GET('/vendors/insights/{id}')
  Future<VendorInsight> vendorInsights(
    @Path('id') int id,
    @Query('duration') String? duration,
    @Query('limit') String? limit,
  );

  @GET('/products?best-seller=1')
  Future<BaseListResponse<ProductData>> fetchTopSellingList(
    @Query('vendor') int vendorId,
  );

  @GET('/vendors/ratings/{id}')
  Future<BaseListResponse<RatingsData>> getVendorReviews(
      @Path() int id, @Query('page') int page);

  @POST("/file-upload")
  @MultiPart()
  Future<FileUploadResponse> uploadFile({@Part() File? file});
}
