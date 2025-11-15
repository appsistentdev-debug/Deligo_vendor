import 'dart:io';

import 'package:delivoo_store/Auth/AuthRepo/auth_interceptor.dart';
import 'package:delivoo_store/JsonFiles/Address/getaddress_json.dart';
import 'package:delivoo_store/JsonFiles/Address/postaddress_json.dart';
import 'package:delivoo_store/JsonFiles/file_upload_response.dart';
import 'package:delivoo_store/OrderItemAccount/HomeRepository/home_client.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeRepository {
  final Dio dio;
  final HomeClient client;

  HomeRepository._(this.dio, this.client);

  factory HomeRepository() {
    Dio dio = Dio();
    dio.interceptors.add(AuthInterceptor());
    HomeClient client = HomeClient(dio);
    dio.options.headers = {
      "content-type": "application/json",
      'Accept': 'application/json'
    };
    return HomeRepository._(dio, client);
  }

  Future<List<GetAddress>> getAddress() {
    return client.getAddresses();
  }

  Future<void> postAddress(String title, String formattedAddress,
      String address1, double latitude, double longitude) async {
    PostAddress address =
        PostAddress(title, formattedAddress, address1, longitude, latitude);
    await client.postAddress(address);
  }

  // Future<ListVendors> searchVendors(String text) {
  //   return client.searchVendors(text);
  // }
  //
  // Future<ListProduct> searchProducts(int vendorId, String text) {
  //   return client.searchProducts(vendorId, text);
  // }

  Future<GetAddress> getSelectedAddress() async {
    var prefs = await SharedPreferences.getInstance();
    String? address = prefs.getString('selectedAddress');
    List<GetAddress> addresses = await getAddress();
    if (address == null) {
      return addresses.first;
    } else {
      return addresses.firstWhere((element) => element.title == address);
    }
  }

  Future<FileUploadResponse> uploadFile(File file) =>
      client.uploadFile(file: file);
}
