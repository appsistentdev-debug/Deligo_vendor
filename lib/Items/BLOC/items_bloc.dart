// import 'package:delivoo_store/repository.dart';
import 'package:delivoo_store/Items/BLOC/items_event.dart';
import 'package:delivoo_store/Items/BLOC/items_state.dart';
import 'package:delivoo_store/JsonFiles/Products/product_data.dart';
import 'package:delivoo_store/JsonFiles/base_list_response.dart';
import 'package:delivoo_store/OrderItemAccount/ProductRepository/product_repository.dart';
import 'package:delivoo_store/UtilityFunctions/helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemsBloc extends Bloc<ItemsEvent, ItemsState> {
  ProductRepository _repository = ProductRepository();

  late List<ProductData> _products;
  int? _vendorId, _categoryId;
  int _currentPage = 1;
  bool _allDone = false;

  ItemsBloc() : super(ItemsLoadingState());

  @override
  Stream<ItemsState> mapEventToState(ItemsEvent event) async* {
    if (event is FetchItemsEvent) {
      yield ItemsLoadingState();
      try {
        _categoryId = event.categoryId;
        _products = await _loadProducts();
        yield ItemsSuccessState(_products);
      } catch (e) {
        yield ItemsFailureState(e);
      }
    } else if (event is PaginateItemsEvent) {
      _categoryId = event.categoryId;
      if (!_allDone) {
        _currentPage++;
        List<ProductData> products = await _loadProducts();
        yield ItemsLoadingState();
        _products.addAll(products);
        yield ItemsSuccessState(_products);
      }
    } else if (event is AddUpdateInList) {
      yield ItemsLoadingState();
      int existingIndex = -1;
      for (int i = 0; i < _products.length; i++) {
        if (event.productData.id == _products[i].id) {
          existingIndex = i;
          break;
        }
      }
      if (existingIndex == -1)
        _products.insert(0, event.productData);
      else
        _products[existingIndex] = event.productData;
      yield ItemsSuccessState(_products);
      print("AddUpdateInList existingIndex: $existingIndex");
    }
  }

  Future<List<ProductData>> _loadProducts() async {
    if (_vendorId == null) {
      await Helper().getVendorInfo().then((value) => _vendorId = value?.id);
    }
    BaseListResponse<ProductData> productsRes =
        await _repository.getProducts(_vendorId!, _categoryId!, _currentPage);
    _allDone = productsRes.meta.current_page == productsRes.meta.last_page;
    return productsRes.data;
  }
}
