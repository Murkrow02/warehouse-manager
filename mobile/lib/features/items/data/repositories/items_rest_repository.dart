import 'dart:io';

import 'package:warehouse_manager/core/networking/http/rest_client.dart';
import 'package:warehouse_manager/features/items/data/repositories/items_repository.dart';

import '../models/item.dart';

class ItemsRestRepository implements ItemsRepository {

  final RestClient _restClient = RestClient();

  @override
  Future<Item> createItem(Item item) async {
    return await _restClient.post("items", item.toJson()).then((item) => Item.fromJson(item));
  }

  @override
  Future<List<Item>> fetchItems({int startIndex = 0, int limit = 20, String? query, String? sortBy, bool? ascending}) async {
    return (await _restClient.get("items")).map<Item>((item) => Item.fromJson(item)).toList();
  }

  @override
  Future<Item> updateItem(Item item) {
    // TODO: implement updateItem
    throw UnimplementedError();
  }

  @override
  Future<Item> fetchItem(int id) async {
    return await _restClient.get("items/$id").then((item) => Item.fromJson(item));
  }

  @override
  Future<Item> fetchItemByCode(String code) async {
    return await _restClient.get("items/code/$code").then((item) => Item.fromJson(item));
  }
}
