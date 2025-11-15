import 'package:delivoo_store/JsonFiles/Ratings/ratings_data.dart';
import 'package:delivoo_store/JsonFiles/Ratings/ratings_meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ratings_list.g.dart';

@JsonSerializable()
class RatingsList {
  final List<RatingsData> data;
  @JsonKey(name: 'meta')
  final dynamic dynamicMeta;

  RatingsList(this.data, this.dynamicMeta);

  factory RatingsList.fromJson(Map<String, dynamic> json) =>
      _$RatingsListFromJson(json);

  Map<String, dynamic> toJson() => _$RatingsListToJson(this);

  RatingsMeta? get meta {
    return (dynamicMeta != null && dynamicMeta is Map)
        ? RatingsMeta.fromJson(dynamicMeta)
        : null;
  }
}
