import 'package:bloc/bloc.dart';
import 'package:delivoo_store/JsonFiles/Categories/category_data.dart';
import 'package:delivoo_store/JsonFiles/Products/add_product.dart';
import 'package:delivoo_store/JsonFiles/Products/addon_group_request.dart';
import 'package:delivoo_store/JsonFiles/Products/addon_groups.dart';
import 'package:delivoo_store/JsonFiles/Products/product_data.dart';
import 'package:delivoo_store/JsonFiles/User/vendor_info.dart';
import 'package:delivoo_store/OrderItemAccount/ProductRepository/product_repository.dart';
import 'package:delivoo_store/Pages/Bloc/AddItem/addItemEvent.dart';
import 'package:delivoo_store/Pages/Bloc/AddItem/addItemState.dart';
import 'package:delivoo_store/UtilityFunctions/helper.dart';

class AddItemBloc extends Bloc<AddItemEvent, AddItemState> {
  ProductRepository _repository = ProductRepository();

  AddItemBloc() : super(AddItemStateInitial());

  @override
  Stream<AddItemState> mapEventToState(AddItemEvent event) async* {
    if (event is AddSubmittedEvent) {
      yield* _mapSubmitToState(event);
    } else if (event is FetchCategoriesEvent) {
      yield* _mapFetchCategoriesToState();
    }
  }

  Stream<AddItemState> _mapFetchCategoriesToState() async* {
    yield AddItemStateLoadingCategories();
    try {
      VendorInfo? vendorInfo = await Helper().getVendorInfo();
      List<int> vendorCategories =
          (vendorInfo?.categories ?? []).map((e) => e.id).toList();
      List<CategoryData> categories =
          await _repository.getProductCategory(vendorCategories.join(","));
      yield AddItemStateLoadedCategories(categories);
    } catch (e) {
      print("_mapFetchCategoriesToState: $e");
      yield AddItemStateLoadFailedCategories();
    }
  }

  Stream<AddItemState> _mapSubmitToState(AddSubmittedEvent event) async* {
    yield AddItemStateLoadingProduct();
    try {
      List<AddonGroupsRequest> addOnGroupsRequest = [];
      if (event.addOnGroups != null) {
        for (AddOnGroups addOnGroup in event.addOnGroups!)
          addOnGroupsRequest.add(addOnGroup.getRequest());
      }
      VendorInfo? vendorInfo = await Helper().getVendorInfo();
      ProductData productData;
      if (event.productId != null) {
        productData = await _repository.editProduct(
          AddProduct(
            event.title,
            event.description,
            event.price,
            vendorInfo!.id,
            event.category,
            event.imageurls,
            event.stockQuantity,
            addOnGroupsRequest,
          ),
          event.productId!,
        );
      } else {
        productData = await _repository.addProduct(
          AddProduct(
            event.title,
            event.description,
            event.price,
            vendorInfo!.id,
            event.category,
            event.imageurls,
            event.stockQuantity,
            addOnGroupsRequest,
          ),
        );
      }
      yield AddItemStateLoadedProduct(productData);
    } catch (e) {
      print("_mapSubmitToState: $e");
      yield AddItemStateLoadFailedProduct();
    }
  }
}
