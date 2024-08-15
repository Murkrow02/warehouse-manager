import '../models/item.dart';
import 'items_repository.dart';

class ItemsMockRepository implements ItemsRepository {
  Future<List<Item>> fetchItems({int startIndex = 0, int limit = 20, String? query, String? sortBy, bool? ascending}) async {
    await Future.delayed(Duration(seconds: 1));  // Simulating a delay
    // Add logic to fetch items (e.g., send a GET request to an API).
    return List.generate(limit, (index) => Item(
      id: index + startIndex,
      name: 'Item ${index + startIndex}',
      price: (index + startIndex) * 10.0,
    ));
  }

  Future<Item> createItem(Item item) async {
    // Add logic to create an item (e.g., send a POST request to an API).
    return item;  // Returning the item for simplicity
  }

  Future<Item> updateItem(Item item) async {
    // Add logic to update an item (e.g., send a PUT request to an API).
    return item;  // Returning the updated item for simplicity
  }
}