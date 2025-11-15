import 'dart:io';

import 'package:delivoo_store/Auth/AuthRepo/auth_interceptor.dart';
import 'package:delivoo_store/Constants/constants.dart';
import 'package:delivoo_store/JsonFiles/Categories/category_data.dart';
import 'package:delivoo_store/JsonFiles/Order/Get/order_data.dart';
import 'package:delivoo_store/JsonFiles/Products/add_product.dart';
import 'package:delivoo_store/JsonFiles/Products/product_data.dart';
import 'package:delivoo_store/JsonFiles/Ratings/ratings_data.dart';
import 'package:delivoo_store/JsonFiles/Wallet/Post/send_to_bank.dart';
import 'package:delivoo_store/JsonFiles/Wallet/Transaction/transaction.dart'
    as myTransaction;
import 'package:delivoo_store/JsonFiles/Wallet/get_wallet_balance.dart';
import 'package:delivoo_store/JsonFiles/base_list_response.dart';
import 'package:delivoo_store/JsonFiles/file_upload_response.dart';
import 'package:delivoo_store/JsonFiles/insights/vendor_insight.dart';
import 'package:delivoo_store/JsonFiles/settings.dart';
import 'package:delivoo_store/OrderItemAccount/ProductRepository/product_client.dart';
import 'package:firebase_database/firebase_database.dart';
//import 'package:firebase_database/firebase_database.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:dio/dio.dart';

class ProductRepository {
  final Dio dio;
  final ProductClient client;

  ProductRepository._(this.dio, this.client);

  factory ProductRepository() {
    Dio dio = Dio();
    dio.interceptors.add(AuthInterceptor());
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
    ProductClient client = ProductClient(dio);
    dio.options.headers = {
      "content-type": "application/json",
      'Accept': 'application/json'
    };
    return ProductRepository._(dio, client);
  }

  DatabaseReference _firebaseDbRef = FirebaseDatabase.instance.ref();

  Stream<DatabaseEvent> getOrdersFirebaseDbRefChildAdded(int vendorId) async* {
    print("getOrdersFirebaseDbRef: $vendorId");
    yield* _firebaseDbRef.child('vendors/$vendorId/orders').onChildAdded;
  }

  Stream<DatabaseEvent> getOrdersFirebaseDbRefChildChanged(
      int vendorId) async* {
    print("getOrdersFirebaseDbRef: $vendorId");
    yield* _firebaseDbRef.child('vendors/$vendorId/orders').onChildChanged;
  }

  Future<BaseListResponse<OrderData>> getOrdersNew(int vendorId, int pageNum) {
    return client.getOrdersNew(vendorId, pageNum);
  }

  Future<BaseListResponse<OrderData>> getOrdersPast(int vendorId, int pageNum) {
    return client.getOrdersPast(vendorId, pageNum);
  }

  Future<OrderData> updateOrder(int id, Map<String, dynamic> updateOrder) {
    return client.updateOrder(id, updateOrder);
  }

  Future<void> sendToBank(SendToBank sendToBank) {
    return client.sendToBank(sendToBank);
  }

  Future<OrderData> getOrderById(int orderId) async {
    return client.getOrderById(orderId);
  }

  Future<BaseListResponse<ProductData>> getProducts(
      int id, int categoryId, int pageNum) async {
    return client.getProducts(id, categoryId, pageNum);
  }

  Future<List<Setting>> getSettings() {
    return client.getSettings();
  }

  Future<WalletBalance> getBalance() {
    return client.getBalance();
  }

  Future<BaseListResponse<myTransaction.Transaction>> getTransactions(
      int page) {
    return client.getTransactions(page);
  }

  Future<List<CategoryData>> getVendorCategory(String? vendorType) {
    return client.getCategories(
      parent: 1,
      scope: Constants.scopeEcommerce,
      vendorType: vendorType,
    );
  }

  Future<List<CategoryData>> getProductCategory(
      String parentCategoryIdsCommaSeparated) {
    return client.getCategories(
        parentCatIdsCommaSeparated: parentCategoryIdsCommaSeparated);
  }

  Future<List<CategoryData>> getCategoriesWithScope(String scope) {
    return client.getCategories(scope: scope);
  }

  // Future<RatingsList> getVendorReviews(int id) {
  //   return client.getVendorReviews(id);
  // }

  // Future<ListProduct> listOfProducts(int vendorId, int categoryId) {
  //   return client.getProducts(vendorId, categoryId);
  // }

  Future<VendorInsight> fetchInsights(
      int id, Map<String, String> insightRequest) {
    return client.vendorInsights(
        id, insightRequest["duration"], insightRequest["limit"]);
  }

  Future<BaseListResponse<ProductData>> fetchTopSellingItems(int id) {
    return client.fetchTopSellingList(id);
  }

  Future<ProductData> addProduct(AddProduct addProduct) {
    Map<String, dynamic> requestMap = addProduct.toJson();
    requestMap.removeWhere((key, value) => value == null);
    return client.postProduct(requestMap);
  }

  Future<ProductData> editProduct(AddProduct addProduct, int productId) {
    Map<String, dynamic> requestMap = addProduct.toJson();
    requestMap.removeWhere((key, value) => value == null);
    return client.editProduct(productId, requestMap);
  }

  Future<BaseListResponse<RatingsData>> getVendorReviews(int id, int page) {
    return client.getVendorReviews(id, page);
  }

  Future<FileUploadResponse> uploadFile(File file) =>
      client.uploadFile(file: file);
}
