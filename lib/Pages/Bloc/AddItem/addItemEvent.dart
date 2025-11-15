import 'package:delivoo_store/JsonFiles/Products/addon_groups.dart';
import 'package:equatable/equatable.dart';

abstract class AddItemEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchCategoriesEvent extends AddItemEvent {}

class AddSubmittedEvent extends AddItemEvent {
  final int? productId;
  final String title;
  final String description;
  final double price;
  final List<String> category;
  final List<String> imageurls;
  final int stockQuantity;
  final List<AddOnGroups>? addOnGroups;

  AddSubmittedEvent(
    this.productId,
    this.title,
    this.description,
    this.price,
    this.category,
    this.imageurls,
    this.stockQuantity,
    this.addOnGroups,
  );

  @override
  List<Object?> get props => [
        title,
        description,
        price,
        category,
        imageurls,
        stockQuantity,
        addOnGroups
      ];
}
