import '../models/item.dart';

abstract class ItemsRepository {
  Future<List<Item>> fetchItems({int startIndex = 0, int limit = 20, String? query, String? sortBy, bool? ascending});
  Future<Item> createItem(Item item);
  Future<Item> updateItem(Item item);
}